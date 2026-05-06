# Audit infrastructure : Replit vs GitHub + Cloudflare — Stack par défaut Gradient Agents

**Date** : 2026-05-06
**Agent** : @infrastructure
**Périmètre** : 7 projets actifs (Versiroom, Sarani, Mandataire-Immo, ImmoCrew, ISSA Capital, DevRefs, Archi)
**Contexte fondateur** : Thomas pilote N projets en parallèle, peur explicite sur la migration BDD, demande un verdict technique honnête.

---

## Verdict synthétique (1 phrase)

**GO migration phasée — DevRefs comme pilote sur Cloudflare Pages + Neon Postgres serverless, puis migration projet par projet sur 8-12 semaines ; PostgreSQL Replit conservé en fallback de secours pendant 60 jours par projet migré ; Cloudflare D1 (SQLite) écarté pour Gradient car les apps actuelles dépendent de fonctionnalités Postgres-spécifiques (JSONB, full-text search, transactions complexes Stripe).**

---

## 1. BDD — analyse priorité (le verrou Thomas)

### 1.1 Profil d'usage BDD réel des projets Gradient

| Projet | Volume estimé | Features BDD critiques |
|---|---|---|
| ImmoCrew | ~10 tables, JSONB lourds (briefs, livrables IA) | Postgres JSONB, transactions Stripe, full-text search mandataires |
| Sarani | ~15 tables, devis/proposals versionnés | Postgres, transactions multi-tables, audit log |
| Mandataire-Immo | Dashboard coaching, plans d'action contextualisés | Postgres + JSONB plans |
| Versiroom | Persistance critique (peur n°1 Thomas) | Postgres + backups stricts |
| ISSA Capital | Vitrine — BDD légère ou statique | Très peu de DB (vitrine) |
| DevRefs | Lancement, schéma à définir | Inconnu (à dimensionner pendant pilote) |
| Archi | Galerie photos, plans d'action | Postgres + storage S3/R2 |

**Constat** : 6/7 projets utilisent des fonctionnalités Postgres-spécifiques (JSONB, FTS, transactions). **SQLite (D1) ne convient pas** sans réécriture lourde du data layer.

### 1.2 Comparatif des 4 options

#### Option A — Cloudflare D1 (SQLite serverless) — **NO-GO pour Gradient**

| Critère | Détail |
|---|---|
| Modèle | SQLite serverless, edge-replicated |
| Pricing | Free tier : 5 GB stockage, 5M reads/jour, 100K writes/jour. Payant : $0.001 / 1K writes |
| Latence | Excellente en lecture edge (< 10ms), mais writes uniquement primary region |
| Schéma | SQLite — pas de JSONB natif (TEXT JSON), pas de FTS comparable, pas de types riches |
| Transactions | Limitées (pas de SERIALIZABLE, locks rudimentaires) |
| Prisma | Support beta via driver adapter, pas production-grade pour stack Gradient |
| Drizzle | Bon support D1, migration nécessaire |
| **Verdict** | **NO-GO** — incompatible avec JSONB lourds (briefs IA), transactions Stripe complexes, full-text search FR. Réécriture data layer estimée 15-25h par projet = perte sèche. |

#### Option B — Neon Postgres (serverless Postgres, partenaire CF officiel) — **GO recommandation principale**

| Critère | Détail |
|---|---|
| Modèle | Postgres 16 serverless, scale-to-zero, branching DB (comme git) |
| Pricing | Free tier : 0.5 GB stockage, 1 projet, branches illimitées. Launch : $19/mois (10 GB, autoscale). Scale : $69/mois |
| Latence cold start | 300-500ms (proxy WebSocket Neon). Tiède : <50ms. **Acceptable pour Gradient** (charge faible cross-projets) |
| Schéma | Postgres complet — JSONB, FTS, extensions (pgvector pour IA) |
| Transactions | Full Postgres (SERIALIZABLE supporté) |
| Prisma | Support officiel via `@neondatabase/serverless` driver. Edge-compatible |
| Branching | **Killer feature** : `git checkout` mais pour la DB. Une branche DB par PR, parfait pour preview deploys |
| Compatibilité CF Workers | Excellente via HTTP fetch driver (pas de TCP requis) |
| Migration Replit | `pg_dump` → `psql` direct. Schéma identique. Risque parité = quasi-nul |
| **Verdict** | **GO principal** — Postgres complet + serverless + branching. Compatible Prisma, edge, et les data layers actuels Gradient sans réécriture. |

**Risques Neon** :
- Cold start 300-500ms sur scale-to-zero — atténuer en gardant un keep-alive ping toutes les 5 min (cron CF Worker) sur projets à trafic erratique.
- Vendor : startup mais bien capitalisée (acquisition par Databricks annoncée 2024). Plan B = export pg_dump à tout moment.
- Pricing : $19/mois × 7 projets = 133$/mois si tous actifs (vs Replit Core ~$20/mois si 1 abonnement couvre tout). À mitiger par mutualisation : 1 projet Neon Free pour les vitrines + projets payants pour les apps critiques.

#### Option C — Supabase (Postgres + auth + storage + realtime managed) — **GO conditionnel (fallback ou cas auth)**

| Critère | Détail |
|---|---|
| Modèle | Postgres managed + auth + storage + realtime. PaaS complet |
| Pricing | Free tier : 500 MB DB, 1 GB storage, 50K MAU auth. Pro : $25/mois |
| Latence | Postgres direct (TCP). Pas de WebSocket — moins ami CF Workers en edge runtime |
| Avantage | Auth + storage inclus = remplace NextAuth + S3 si projet greenfield |
| Inconvénient pour Gradient | Thomas a explicitement choisi NextAuth.js (preference 2026-03-26) — auth Supabase contredit la préférence |
| Vendor lock-in | Auth Supabase ↔ Supabase. Migration ailleurs = lourde. **Anti-pattern Thomas n°7** |
| **Verdict** | **GO conditionnel** — uniquement pour un nouveau projet où auth + storage + realtime sont tous nécessaires en même temps. **NO-GO comme standard Gradient** car contredit préférence NextAuth + risque vendor lock-in. |

#### Option D — Postgres dédié hors-CF (Railway, Render, Fly.io) — **GO en fallback**

| Provider | Pricing | Latence | Verdict |
|---|---|---|---|
| Railway | $5/mois minimum + usage. Postgres ~$10-20/mois | TCP, pas serverless edge | Fallback si Neon défaillant |
| Render | Free tier 1 GB éphémère, payant $7/mois Starter | TCP, region fixe | Fallback acceptable |
| Fly.io | Postgres self-hosted dans VM Fly. ~$5-15/mois | Multi-région possible | Plus complexe, mais ownership total |

**Verdict Option D** : **Fallback technique** si Neon devient indisponible ou si un projet a un besoin de Postgres avec extensions exotiques (timescale, postgis lourd) non supportées par Neon. Pour le standard Gradient → **Neon**.

### 1.3 Recommandation BDD finale

| Rôle | Provider | Justification |
|---|---|---|
| **Standard Gradient** | **Neon Postgres** (Free → Launch $19/mois selon trafic) | Postgres complet, edge-friendly via HTTP driver, branching pour preview deploys, migration triviale depuis Replit (pg_dump direct), pas de réécriture data layer. |
| **Fallback** | **Railway Postgres** ($10-20/mois) | TCP Postgres standard, ownership simple, redondance si Neon down. |
| **Cas d'auth managed** | Supabase (uniquement greenfield + besoin realtime) | Pas le standard, mais autorisé en exception documentée. |
| **Écarté** | Cloudflare D1 (SQLite) | Incompatible JSONB / FTS / transactions Stripe lourdes. Réécriture data layer non rentable. |

---

## 2. Migration depuis PostgreSQL Replit — protocole concret

### 2.1 Inventaire pré-migration (par projet, ~30 min)

1. `pg_dump --schema-only` → vérifier extensions utilisées (uuid-ossp, pgcrypto, pgvector ?)
2. `\dt+` dans psql → lister tables + tailles
3. Grep `prisma/schema.prisma` → confirmer types JSONB, FTS, triggers
4. Identifier les jobs cron Replit (si existants) → à migrer en CF Cron Triggers
5. Lister les Replit Secrets liés à la DB → exporter dans 1Password

### 2.2 Migration data (par projet, 1-2h selon volume)

**Ordre d'opérations** :

```bash
# 1. Provisionner Neon (web UI ou neonctl)
neonctl projects create --name gradient-<projet>
neonctl databases create main

# 2. Export Replit
pg_dump $REPLIT_DATABASE_URL \
  --no-owner --no-acl --clean --if-exists \
  -F c -f /tmp/<projet>.dump

# 3. Import Neon
pg_restore -d $NEON_DATABASE_URL \
  --no-owner --no-acl --clean --if-exists \
  /tmp/<projet>.dump

# 4. Validation parité
psql $REPLIT_DATABASE_URL -c "SELECT count(*) FROM <table>" > replit.txt
psql $NEON_DATABASE_URL -c "SELECT count(*) FROM <table>" > neon.txt
diff replit.txt neon.txt  # doit être vide
```

### 2.3 Stratégie de cutover

**Option recommandée — Single cutover (bas trafic)** :
1. Annoncer fenêtre de maintenance 30 min (la nuit, vu le trafic Gradient).
2. Pause des écritures (mode read-only via flag env).
3. `pg_dump` final → `pg_restore`.
4. Bascule `DATABASE_URL` (Replit Secret → CF Worker Secret / GitHub Action env).
5. Tests de fumée 5 min (auth, CRUD principal, paiement Stripe sandbox).
6. Réouverture des écritures.

**Option double-écriture transitoire** : **non recommandée pour Gradient** — complexité (2-3j de dev) disproportionnée par rapport au trafic actuel. Single cutover suffit.

### 2.4 Plan de rollback

- Garder Replit DB **en lecture seule pendant 60 jours** après migration.
- Conserver le `pg_dump` final dans 2 endroits (R2 + local).
- Si bug critique post-migration : flipper `DATABASE_URL` vers Replit (rollback < 5 min) puis investiguer.

### 2.5 Coût migration estimé

| Tâche | Temps par projet |
|---|---|
| Inventaire pré-migration | 30 min |
| Provisionnement Neon + secrets | 20 min |
| Dump + restore + validation | 30-60 min |
| Bascule DNS / env vars | 15 min |
| Tests de fumée | 30 min |
| Documentation post-migration | 20 min |
| **Total par projet** | **~3h** (orchestrable en grande partie par Claude avec tokens API) |

**7 projets × 3h ≈ 21h de migration totale**, étalés sur 8-12 semaines (1 projet par semaine = rythme prudent).

---

## 3. Stack déploiement frontend/backend recommandée

### 3.1 Comparatif Cloudflare Pages vs Workers vs hybride

| Option | Pour Gradient (Next.js + API + Stripe + IA) |
|---|---|
| **Cloudflare Pages + Functions** | Bon pour sites statiques + petites API. Limite : Functions = sous-set de Workers, certaines libs Node ne marchent pas (Stripe SDK Node require). Build Next.js sur Pages = OK via `@cloudflare/next-on-pages` mais runtime edge (pas Node). |
| **Cloudflare Workers** | Edge runtime pur, stateless. Excellente perf. Limite : 128 MB RAM, 30s CPU max sur paid plan, pas de Node natif (besoin polyfills). Streaming IA = OK. |
| **Hybride Pages + Workers + tiers Node** | Pages pour le statique, Workers pour edge logic, et un Postgres serverless (Neon) pour la persistance. Pour les libs Node lourdes (Stripe, certaines libs IA) : route API via `nodejs_compat` flag CF (disponible 2024+) OU délégation à un Worker Node-compatible. |

### 3.2 Recommandation stack

**Stack standard Gradient v2 (post-migration)** :

```
GitHub (source of truth)
   │
   ├──> GitHub Actions (lint + test + build)
   │       │
   │       └──> Cloudflare Pages (Next.js via @cloudflare/next-on-pages)
   │              ├── Static assets (CDN edge)
   │              └── API routes → Pages Functions (edge)
   │
   ├──> Neon Postgres (data layer, HTTP driver)
   ├──> Cloudflare R2 (object storage : photos, PDFs)
   ├──> Cloudflare KV (cache, sessions ephemeral)
   ├──> Cloudflare Workers (cron jobs, webhooks Stripe lourds, batch IA)
   └──> Sentry (error tracking)
```

**Détail par responsabilité** :

| Responsabilité | Service | Justification |
|---|---|---|
| Hosting frontend | CF Pages | Free 500 builds/mois, edge CDN inclus, custom domain |
| API routes courtes | CF Pages Functions (edge) | Co-localisées avec le front, latence minimale |
| API routes Stripe / Node lourd | CF Worker avec `nodejs_compat` OU route fallback Vercel Functions Node si bloquant | Compat Stripe SDK Node officiel |
| BDD | Neon Postgres | Cf section 1 |
| Storage | CF R2 | $0.015/GB-mois, zero egress fee (vs S3 $0.023 + egress $0.09/GB) |
| Cache / sessions | CF KV ou Upstash Redis serverless | KV pour cache simple, Upstash si TTL fin |
| Cron jobs | CF Cron Triggers | Gratuit jusqu'à 5 par compte, simples crontabs |
| DNS + WAF + DDoS | CF (inclus) | Protection native, gratuit |
| Email transactional | Resend (3K/mois free) | Compatible CF Workers |

### 3.3 Cas problématique : Next.js App Router + libs Node lourdes

**Risque réel** : certains projets Gradient utilisent Stripe SDK Node, OpenAI SDK, librairies de PDF. Toutes ne sont pas edge-runtime compatibles.

**Mitigation** :
1. Activer `nodejs_compat` flag dans `wrangler.toml` (CF 2024+).
2. Pour les routes vraiment incompatibles edge → fallback Workers Node-mode OU déporter vers une Function Vercel/Railway (1 service tiers, pas tout le projet).
3. Tests de compat à faire **sur DevRefs en pilote** AVANT migration des projets critiques.

---

## 4. Gain opérationnel pour Claude (orchestrator) — actions automatisables

Avec un **token CF API** (scope minimal par projet) + **GitHub MCP** + **Neon API token**, voici ce que Claude peut piloter automatiquement, **impossible avec Replit aujourd'hui** :

| # | Action automatisable | API utilisée | Gain vs Replit |
|---|---|---|---|
| 1 | Push code → trigger build → vérifier statut → rollback si échec | GitHub Actions API + CF Pages API | Aujourd'hui : Thomas ouvre Replit, regarde, rollback à la main |
| 2 | Créer une preview deploy par PR (avec branche DB Neon) | GitHub PR webhook + CF Pages preview + Neon branch API | Replit ne fait pas de preview deploys par PR |
| 3 | Lire les logs d'erreurs production en temps réel | CF Logpush / Tail API + Sentry API | Replit logs = console manuelle |
| 4 | Créer un nouveau projet (DNS + Pages + DB + secrets) en 1 prompt | CF API + Neon API + GitHub API | Replit : 30 min de clics manuels |
| 5 | Rotation automatique des secrets (Stripe, OpenAI) | CF Secrets API + GitHub Secrets API | Replit : copier-coller manuel dans UI |
| 6 | Provisionner DB branch pour test, exécuter migration, valider, merger | Neon branch API | Impossible sur Replit (1 seule DB par projet) |
| 7 | Configurer DNS sous-domaine + SSL en 1 commande | CF DNS API | Replit Custom Domain = config UI |
| 8 | Auditer le bundle size post-build et alerter si > seuil | GitHub Actions artifact API | Manuel sur Replit |
| 9 | Trigger `pg_dump` automatique vers R2 (backup) | Neon API + R2 API + CF Cron | Replit pas de backup natif fiable |
| 10 | Bloquer un déploiement si tests Lighthouse < seuil | GitHub Actions + Lighthouse CI | Possible sur Replit mais non automatisé |
| 11 | Voir le coût mensuel cross-projets et alerter sur dépassement | CF Billing API + Neon Billing API | Replit pas d'API billing fine |
| 12 | Activer / désactiver maintenance mode globalement | CF Worker route + KV flag | Replit nécessite redéploiement |

**Gain mesuré** : ~40-60% du temps opérationnel sur les multi-projets passe de "Thomas clique" à "Claude fait + Thomas valide". Particulièrement critique sur les 6+ projets en parallèle.

---

## 5. Risques sécurité & blast radius

### 5.1 Schéma de permissions par token (least privilege)

**1 token CF par projet** = blast radius limité à un projet en cas de compromission.

```
Token CF "gradient-devrefs" :
  - Account: <account_id>
  - Permissions:
      - Workers Scripts: Edit (scope: gradient-devrefs-*)
      - Pages: Edit (scope: gradient-devrefs)
      - DNS: Edit (zone: devrefs.<domain>)
      - R2: Edit (bucket: gradient-devrefs-*)
      - Workers KV: Edit (namespace: gradient-devrefs-*)
  - Rate-limited
  - TTL: 365 jours, rotation annuelle obligatoire
```

**Token GitHub par projet** :
- Fine-grained PAT, scope = 1 repo
- Permissions : contents:write, pull-requests:write, actions:read, secrets:write
- TTL 90 jours (rotation trimestrielle)

**Token Neon** :
- 1 token par projet Neon
- Scope : 1 project
- Permissions : create branch, run migrations, **PAS DROP DATABASE** (interdiction explicite)

### 5.2 Secrets management

| Type | Localisation | Rotation |
|---|---|---|
| `DATABASE_URL` (Neon) | CF Pages env (production) + GitHub Secrets (build) | Annuelle |
| Stripe keys | CF Pages env | Trimestrielle (ou immédiate si fuite) |
| OpenAI API key | CF Pages env + budget cap CF AI Gateway | Trimestrielle |
| Sentry DSN | Public (frontend) — pas critique | N/A |
| Webhook secrets (Stripe HMAC) | CF Pages env | Annuelle |

**Règle absolue** : aucun secret en dur dans le code, jamais. Audit pre-commit via gitleaks dans GitHub Action.

### 5.3 Budget caps (anti-facture surprise)

- **CF AI Gateway** : caps absolus mensuels par projet ($20/mois max). Au-delà → erreur 429 plutôt que charge.
- **Neon** : alerte à 80% du quota Free, upgrade manuel uniquement (pas auto-billing).
- **R2** : alerte à 5 GB stockage, 100 GB transferts.
- **CF Workers** : alerte à 80% du paid plan ($5/mois inclut 10M req).

### 5.4 DNS protection

- CF Zone Lock activé sur les domaines en production.
- DNSSEC activé.
- Email notifications sur tout changement DNS critique (MX, NS, A racine).

### 5.5 Risques résiduels et mitigations

| Risque | Probabilité | Mitigation |
|---|---|---|
| Compromission token CF | Faible | Scope minimal + rotation + alertes Cloudflare |
| Cold start Neon dégrade UX | Moyenne | Keep-alive ping cron 5 min sur projets faible trafic |
| Lib Node incompatible edge | Moyenne | Tester sur DevRefs pilote, fallback Worker Node mode |
| Neon défaillance / shutdown | Faible | pg_dump quotidien vers R2, fallback Railway documenté |
| Replit pivote vers payant agressif pendant migration | Moyenne | Migration phasée, accélération possible si Replit change pricing |

---

## 6. Coûts comparés cross-projets (7 projets actifs)

### Hypothèses
- 7 projets : 5 actifs avec trafic faible (<10K req/jour), 2 actifs trafic moyen (DevRefs + ImmoCrew, ~50K req/jour).
- Stockage moyen DB : 500 MB par projet.
- Stockage R2 : ~5 GB par projet (photos, PDFs).
- Email : ~2K emails/mois total.

### Coût Replit actuel (estimation)

| Item | Coût |
|---|---|
| Replit Core (Hacker plan unique pour Thomas) | ~$20/mois |
| Replit Deployments (Reserved VM × 7 projets si actifs 24/7) | $7 × 7 = $49/mois (estimation Reserved VM small) OU $0 si Autoscale (mais cold starts) |
| PostgreSQL Replit | Inclus dans Deployments mais limité, peut nécessiter upgrade |
| **Total estimé Replit** | **~$70-100/mois** pour 7 projets si Reserved VM, ~$25-40 si Autoscale (mais perte de perf) |

### Coût Cloudflare + Neon (estimation post-migration)

| Item | Coût |
|---|---|
| CF Pages | $0 (Free : 500 builds/mois, illimité bandwidth) |
| CF Workers | $5/mois (paid plan recommandé pour 10M req inclus + nodejs_compat) |
| CF R2 storage 35 GB total | $0.015 × 35 = ~$0.50/mois |
| CF R2 egress | **$0** (zero egress fee) |
| CF KV | $0 (Free : 100K reads/jour suffisant) |
| Neon Postgres : 2 projets payants (DevRefs + ImmoCrew) à $19/mois Launch | $38/mois |
| Neon Postgres : 5 projets sur Free tier mutualisé ou plan unique | $0-19/mois |
| CF AI Gateway (cap budgétaire IA) | Pass-through : ce qu'on paie déjà à OpenAI/Anthropic |
| Resend (email transactional) | $0 (3K emails/mois free) |
| Sentry | $0 (Free : 5K events/mois) |
| Domaines (déjà payés ailleurs probablement) | inchangé |
| **Total estimé CF + Neon** | **~$45-65/mois** pour 7 projets |

### Économie estimée

**~$25-35/mois** d'économie potentielle sur 7 projets, soit **~$300-420/an**.

**Mais le vrai gain n'est pas le coût** : c'est la **vitesse de déploiement Claude-pilotée** + **preview deploys par PR** + **rollback instantané** + **branching DB** = gain horaire >> gain monétaire.

---

## 7. DX comparée — pour un dev indie (Thomas)

| Tâche quotidienne | Replit | GitHub + CF |
|---|---|---|
| Coder dans le navigateur | Excellent (IDE intégré) | Moyen (besoin VSCode local ou GitHub Codespaces) |
| Voir le résultat live | Excellent (preview instant) | Bon (CF Pages preview par PR, ~30s build) |
| Déployer en prod | Click deploy | Push to main → auto deploy |
| Rollback | UI Replit, parfois fragile | GitHub revert + auto redeploy, traçable |
| Multi-environnements (dev/preview/prod) | Limité | Natif via branches + CF preview |
| Accès logs | UI console manuelle | wrangler tail / CF dashboard / Sentry |
| Secrets management | UI Replit Secrets | wrangler secret put / GitHub Secrets |
| Multi-projets | 1 onglet par Repl | 1 repo par projet, dashboard CF unifié |
| Collaboration Claude | Limitée (pas d'API mature) | Excellente (GitHub MCP + CF API + Neon API) |
| **Verdict pour Thomas** | Confortable mais friction Claude + multi-projet | Plus structuré, **excellent pour pilotage Claude**, légère courbe apprentissage Wrangler (1 journée) |

**Conclusion DX** : Replit gagne sur "ouvrir l'éditeur et coder maintenant". CF + GitHub gagne sur tout le reste : multi-projets, automatisation Claude, observabilité, rollback, environnements. Pour le profil de Thomas (multi-projets, Claude-orchestrated), **CF + GitHub est le bon choix structurel**.

---

## 8. Permissions Claude proposées (résumé actionnable)

| Permission Claude | Token nécessaire | Périmètre |
|---|---|---|
| Push code, créer PR, merger | GitHub fine-grained PAT (per repo) | 1 repo = 1 token |
| Déclencher build, lire artifacts | GitHub Actions API (inclus dans PAT) | idem |
| Déployer sur CF Pages, lire logs, rollback | CF API token (Pages:Edit, Workers:Edit, scope projet) | 1 projet = 1 token |
| Créer branch DB, exécuter migration | Neon API key (project-scoped) | 1 projet Neon = 1 key |
| Modifier DNS sous-domaine | CF API (DNS:Edit, zone-scoped) | 1 zone = 1 token |
| Lire métriques + erreurs | Sentry API token (read-only org) | 1 token org-wide |
| Lire billing | CF Billing API (read-only) | 1 token account |

**Stockage des tokens Claude** : variables d'environnement Claude Code, jamais dans le repo, rotation automatique trimestrielle documentée dans `docs/infra/secrets-rotation.md`.

---

## 9. Plan de migration phasé (recommandation finale)

### Phase 0 — Préparation (semaine 0, ~6h)
- Créer compte CF (déjà fait probablement) + Neon
- Générer tokens scope minimum (CF + GitHub + Neon)
- Documenter dans `docs/infra/cloudflare-setup.md` + `docs/infra/neon-setup.md`
- Setup gitleaks pre-commit
- Choisir le projet pilote : **DevRefs** (greenfield, faible risque, déjà choisi par Thomas)

### Phase 1 — Pilote DevRefs (semaines 1-2, ~10h)
- Créer repo GitHub `gradient-devrefs`
- Setup CF Pages + Neon (Free tier suffit pour pilote)
- Implémenter `.github/workflows/ci.yml` (lint + test + build)
- Tester edge runtime + Stripe + IA + auth NextAuth
- Documenter friction points dans `docs/reviews/devrefs-migration-postmortem.md`
- **Gate de validation** : DevRefs en prod, parité fonctionnelle 100%, perf ≥ Replit

### Phase 2 — Migration projet à faible risque (semaine 3, ~3h)
- ISSA Capital (vitrine, BDD légère ou statique) — risque minimal
- Valider le pattern de migration

### Phase 3 — Migration projets actifs (semaines 4-8, ~12h)
- Versiroom, Mandataire-Immo, Sarani, Archi, ImmoCrew (1 par semaine)
- Single cutover de nuit avec fenêtre annoncée
- Replit conservé en read-only 60 jours après chaque migration

### Phase 4 — Phase-out Replit (semaines 9-12)
- Validation 60 jours stable post-migration
- Suppression Replit Deployments (économie immédiate)
- Replit conservé éventuellement pour prototypage rapide (compte Free)
- Documentation finale `docs/infra/replit-to-cloudflare-migration-complete.md`

### Critères Stop / Rollback
- Si performance dégradée >20% → rollback projet vers Replit, investiguer
- Si bug critique en prod >2h sans fix → rollback
- Si coût mensuel > prévision +50% → revoir architecture

---

## 10. Risques + mitigations (synthèse)

| Risque | Sévérité | Mitigation |
|---|---|---|
| BDD migration corrompt données critiques | **Haute** | pg_dump pré + post + diff counts + rollback Replit 60 jours |
| Cold start Neon dégrade UX | Moyenne | Keep-alive cron 5 min |
| Edge runtime incompatible avec une lib Node | Moyenne | Tester sur DevRefs pilote, fallback Worker Node mode ou Vercel Function |
| Compromission token CF | Faible | Scope minimal par projet + rotation + alertes |
| Coûts dérapent | Faible | Caps budgétaires + alertes 80% |
| Thomas perdu dans Wrangler CLI | Faible | 1 journée d'onboarding documentée |
| Replit change pricing pendant migration | Faible | Migration phasée, accélération possible |
| Dépendance forte à Cloudflare (vendor) | Moyenne | Stack reste portable : code Next.js standard, Postgres standard. Migration vers Vercel/Fly possible en 1 semaine si nécessaire. |

---

## Décisions actionnables pour Thomas

1. **Valider le verdict GO migration phasée** ou demander un tour de table avec @elon (audit ROI cross-projets) avant de bouger.
2. **Choisir le projet pilote** : recommandation DevRefs (greenfield, risque min). Si Thomas préfère un projet existant à faible enjeu = ISSA Capital (vitrine).
3. **Provisionner les comptes** : CF (probablement déjà), Neon (créer), tokens API.
4. **Donner les tokens à Claude** (scope minimum, par projet) → débloque les 12 actions automatisables.
5. **Décider du pricing Neon** : Free tier mutualisé pour démarrer (1 projet) ou Launch $19/mois dès le pilote DevRefs ? Recommandation : Free pour le pilote, Launch dès la mise en prod.
6. **Confirmer la stack auth** : NextAuth.js maintenu (cf préférence). Supabase auth écarté.
7. **Confirmer écartement Cloudflare D1** : SQLite incompatible avec features Postgres-spécifiques actuelles.
8. **Documenter les Replit Secrets actuels** par projet AVANT migration (inventaire complet).
9. **Préparer la communication** : si users payants (ImmoCrew, Sarani), annoncer la fenêtre de maintenance par projet.

---

## Handoff → @orchestrator

**Fichiers produits** :
- `/home/user/Agent-Team/docs/reviews/infrastructure-replit-vs-cloudflare-2026-05-06.md`

**Décisions techniques prises** :
- Standard BDD Gradient v2 = **Neon Postgres** (pas D1, pas Supabase comme standard)
- Stack déploiement = **GitHub + CF Pages + CF Workers + Neon + R2**
- Migration phasée 8-12 semaines, **DevRefs pilote**
- Auth = **NextAuth.js maintenu** (préférence Thomas respectée)
- 1 token CF + GitHub + Neon **par projet** (scope minimum, blast radius limité)

**Points d'attention** :
- Cold start Neon 300-500ms — keep-alive ping requis sur projets faible trafic
- Edge runtime = tester compat libs Node lourdes sur le pilote DevRefs AVANT migration projets critiques
- Replit conservé en read-only 60 jours par projet migré (rollback safety net)
- **BDD = peur Thomas** : pg_dump pré+post + diff counts + double conservation (R2 + local) NON-NÉGOCIABLE
- D1 écarté = **vérité technique**, pas frilosité : JSONB + FTS + transactions Stripe = besoins réels Gradient

**Actions Replit requises** :
- Rien à modifier dans Replit pendant la phase préparation
- À la migration de chaque projet : passer DB Replit en read-only (UPDATE pg_database SET datallowconn = false ou flag applicatif)
- À la fin Phase 4 : suppression Replit Deployments

**Agent suivant à invoquer** :
- **@elon** (en parallèle, si pas déjà lancé) pour audit ROI first principles cross-projets
- **@fullstack** une fois pilote DevRefs validé : implémentation concrète du template GitHub + CF Pages + Neon (avec @cloudflare/next-on-pages, wrangler.toml, .github/workflows/ci.yml type)
- **@reviewer** pour valider ce livrable contre les gates G1-G32 avant exécution

---

*Audit produit par @infrastructure le 2026-05-06. Source de vérité : dépendances Postgres réelles des projets Gradient, profils de trafic estimés, pricing public CF / Neon / Replit au 2026-05-06.*
