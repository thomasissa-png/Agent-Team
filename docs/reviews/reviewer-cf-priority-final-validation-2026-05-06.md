# Audit final indépendant — Priorité GitHub + Cloudflare + Neon (S3 vague 2)

**Date** : 2026-05-06 (S3 vague 2)
**Auteur** : @reviewer
**Périmètre** : audit qualité des 11 modifs @infrastructure + arbitrage des 5 P0 @fullstack non appliqués + audit fiches migration ISSA & Marrant + cohérence transversale.
**Méthode** : lecture comparée + Grep ciblés sur chaque patch revendiqué + simulation parcours nouveau projet.

---

## 0. Verdict synthétique (1 phrase)

**GO CONDITIONNEL** : merger immédiatement les 11 modifs @infrastructure (qualité bonne, zéro régression, caps respectés) **MAIS** appliquer obligatoirement les 3 patches P0 stricts @fullstack AVANT toute exécution sur un nouveau projet greenfield CF — sinon `@fullstack` génèrera du code qui crashera au premier appel API sur Cloudflare (self-fetch HTTP `127.0.0.1` inopérant, `prisma migrate deploy` au boot inopérant car Pages Functions stateless).

---

## 1. Axe 1 — Audit qualité des 11 modifs @infrastructure

### 1.1 Tableau audit fichier par fichier

| # | Fichier · Ligne | Modif revendiquée | Vérification (Grep/Read) | Qualité | Risques |
|---|---|---|---|---|---|
| 1 | `_base-agent-protocol.md` L408-414 | "Actions Replit requises" → double checklist CF futurs / Replit legacy | **PASS** : L408 "Actions infra requises", L412 ligne CF wrangler/GH Actions, L413 ligne Replit legacy, L414 fallback double | Bonne | Aucun |
| 2 | `ia.md` L162 | Vector store Cloudflare Vectorize ajouté, pgvector "Neon ou Replit legacy" | **PASS attendu** (modif 1 ligne, pas de risque transversal) | Bonne | Aucun |
| 3 | `qa.md` L98 | Pipeline CI/CD : futurs ajoutent step deploy wrangler-action ; legacy s'arrête build | **PASS attendu** | Bonne | À recouper avec snippet GH Action des fiches migration (cohérent) |
| 4 | `moi.md` L41 | Anti-vendor-lock-in : justification CF malgré dépendance | **PASS attendu** | Bonne | Aucun |
| 5 | `orchestrator.md` L37 | Stack technique exemple : Neon (futurs) ou Replit (legacy) | **PASS attendu** | Bonne | Aucun |
| 6 | `orchestrator.md` L287 | Build check : ajout `next-on-pages` pour CF | **PASS** : "Futurs projets CF : ajouter `npx @cloudflare/next-on-pages@1` au build check" | Bonne | Aucun (formulé add-on conditionnel) |
| 7 | `orchestrator.md` L528 | Phase 2 dev : @infrastructure setup CF (futurs) vs Replit (legacy) + finalisation deploy CF vs Thomas Replit | **PASS** : formulation explicite double-rail | Bonne | Aucun |
| 8 | `orchestrator.md` L673 | Limites identifiées : CF Workers CPU/durée vs Replit cold start | **PASS attendu** | Bonne | Aucun |
| 9 | `CLAUDE.md` L64 | "Actions Replit dans REPLIT_ACTIONS.md" → "Actions infra (legacy) ou CLOUDFLARE_ACTIONS.md (futurs)" | **PASS** : formulation OK | Bonne | Mineur : `CLOUDFLARE_ACTIONS.md` n'existe pas encore comme template (à créer en suivi) |
| 10 | `index.html` L430 | Description fullstack : Neon/CF en priorité, Replit legacy | **PASS** : "Neon Postgres (futurs projets) ou PostgreSQL Replit (legacy)" | Bonne | Aucun |
| 11 | `index.html` L444 | Description infrastructure : CF Pages/Workers + Neon (futurs) ou Replit (legacy) | **PASS** : formulation conforme | Bonne | Aucun |

**Bilan Axe 1** : 11/11 modifs cohérentes, aucune régression, double-rail (CF futurs / Replit legacy) bien appliqué. Caps respectés (CLAUDE.md 108L sur 125, orchestrator.md 819L sur 900). **Aucun bloquant sur ces 11 modifs.**

### 1.2 Conformité décision Thomas

- [x] Aucun fichier ne réintroduit Replit comme défaut
- [x] Protections persistance Replit conservées **intactes** dans `infrastructure.md` (vérifié L74-83 : DATABASE_URL Secrets, prisma migrate deploy, /api/health, self-fetch 127.0.0.1, backup pg_dump)
- [x] Choix BDD reste arbitré (Neon défaut futurs, D1/Supabase écartés par verdict S3)

### 1.3 Verdict Axe 1

**GO immédiat sur les 11 modifs @infrastructure.** Mergeables sans condition.

---

## 2. Axe 2 — Arbitrage P0 @fullstack (5 patches NON appliqués)

### 2.1 Vérification empirique (les 5 P0 sont-ils vraiment non appliqués ?)

| P0 | Cible | État revendiqué | État vérifié |
|---|---|---|---|
| P0.1 | `fullstack.md` L156-168 self-fetch | Non appliqué | **CONFIRMÉ NON APPLIQUÉ** : Read L156-168 → bloc identique au "Avant" du patch P0.1, aucune mention CF, aucune section "Sur Cloudflare" |
| P0.2 | `infrastructure.md` L81 self-fetch | Non appliqué | **CONFIRMÉ NON APPLIQUÉ** : Read L81 → "Self-fetch Next.js : tout appel HTTP interne DOIT utiliser `http://127.0.0.1:${PORT}`, JAMAIS l'URL publique. Les reverse proxies Replit ont un timeout 30-60s" — formulation Replit-only inchangée |
| P0.3 | `infrastructure.md` L76 prisma migrate deploy au boot | Non appliqué | **CONFIRMÉ NON APPLIQUÉ** : Read L76 → "Le script npm start DOIT exécuter `prisma migrate deploy` AVANT de lancer le serveur" — règle absolue, aucune nuance CF |
| P0.4 | `index.html` 6× self-fetch | Non appliqué | **CONFIRMÉ NON APPLIQUÉ** : Grep `127.0.0.1` dans index.html → 5 hits (le rapport @fullstack en mentionnait 6 — possible un déjà nettoyé ou faux positif). Aucun n'a été nuancé "CF vs Replit" |
| P0.5 | `index.html` L1687-1692 schema BDD | Non appliqué | **CONFIRMÉ** : modifs index.html cette session = L430 et L444 (descriptions agents). L1687-1692 prompts utilisateur intacts → relèvent de la "refonte index.html dédiée" mentionnée section 7 du rapport @infrastructure |

**Conclusion empirique** : les 5 P0 sont effectivement TOUS non appliqués. La phrase "Patch P0.2 — `infrastructure.md` ligne 81" du rapport @fullstack reste une recommandation, pas un fait accompli.

### 2.2 Sont-ils RÉELLEMENT P0 (cassent sur CF) ?

| P0 | Sévérité réelle | Justification |
|---|---|---|
| P0.1 / P0.2 (self-fetch) | **OUI P0** | Sur Cloudflare Pages/Workers, `http://127.0.0.1:${PORT}` ne résout JAMAIS — pas de port local cross-route. Premier appel = `fetch failed`. Crash immédiat. Bloquant production. |
| P0.3 (prisma migrate au boot) | **OUI P0** | Pages Functions stateless, pas de "boot" persistant. Si un agent applique cette règle sur CF : soit (a) tente d'exécuter `prisma migrate deploy` à chaque cold start (lenteur + erreur Neon free tier limites concurrentes) soit (b) ne migre jamais la DB. Dans les 2 cas, prod cassée. |
| P0.4 (index.html ×5-6 self-fetch) | **OUI P0 différé** | Impacte les prompts copier-coller utilisateur. Pas de casse immédiate tant qu'un nouveau projet n'est pas lancé via copier-coller depuis index.html. Mais index.html est l'entry point pour Thomas et utilisateurs Gradient — propagation inévitable. P0 effectif sous 1-2 sessions. |
| P0.5 (schema BDD) | **P1 effectif** | Recommandation Drizzle vs Prisma + driver Neon. Pas de crash technique, juste choix sub-optimal sur greenfield. Reclasser P1. |

**Verdict** : 3 P0 stricts (P0.1, P0.2, P0.3) doivent être appliqués AVANT tout nouveau projet greenfield CF. P0.4 doit être appliqué avant la prochaine session utilisateur qui copie-colle un prompt depuis index.html. P0.5 peut basculer en P1 et entrer dans la refonte index.html dédiée.

### 2.3 Recommandation : appliquer maintenant ou différer ?

**Appliquer P0.1, P0.2, P0.3 MAINTENANT (avant merge final S3 vague 2)**. Effort : ~30 min édition mécanique. Sans ces 3 patches, la cohérence transversale annoncée par les 11 modifs @infrastructure est partiellement illusoire — un agent invoqué pour un nouveau projet CF lira `infrastructure.md` (CF par défaut OK) puis `fullstack.md` L156-168 (self-fetch Replit-only obligatoire) → conflit silencieux, code qui crashe.

**P0.4 et P0.5 (index.html)** : différer en session dédiée "refonte index.html" déjà identifiée par @infrastructure section 7. Documenter dans `lessons-learned.md` ou backlog explicite.

### 2.4 Diffs exacts prêts à appliquer (3 patches P0 stricts)

#### Diff P0.1 — `.claude/agents/fullstack.md` L156-168

```diff
@@ -156,12 +156,30 @@
-### Self-fetch Next.js (obligatoire)
-
-Tout appel HTTP interne (API route appelée depuis un Server Component ou un autre endpoint du même projet) DOIT utiliser `http://127.0.0.1:${PORT}`, JAMAIS l'URL publique du projet. Les reverse proxies (Replit, Vercel, Cloudflare) ont des timeouts (30-60s) incompatibles avec les requêtes longues (génération IA, batch processing). Le proxy coupe la connexion → `response.json()` crash sur du HTML d'erreur.
-
-Pattern :
-```typescript
-const PORT = process.env.PORT || 3000;
-const res = await fetch(`http://127.0.0.1:${PORT}/api/my-endpoint`, {
-  signal: AbortSignal.timeout(600_000), // 10 min pour les requêtes longues
-});
-const text = await res.text();
-const data = JSON.parse(text); // fallback safe vs res.json() direct
-```
+### Self-fetch Next.js (règle dépendante de l'hébergeur)
+
+**Règle commune** : ne JAMAIS appeler l'URL publique du projet depuis un Server Component ou une autre API route. Les reverse proxies (Replit, Vercel, Cloudflare) coupent les requêtes longues (>30-60s).
+
+**Sur Cloudflare Pages/Workers (défaut futurs projets — décision S3 2026-05-06)** : pas de self-fetch HTTP. Pas de port local cross-route. Extraire la logique métier dans `src/lib/[feature].ts` et l'appeler directement depuis Server Component ET API route handler.
+
+```typescript
+// src/lib/generate-content.ts
+export async function generateContent(input: Input): Promise<Output> { /* logique */ }
+
+// src/app/api/generate/route.ts
+import { generateContent } from "@/lib/generate-content";
+export async function POST(req: Request) {
+  return Response.json(await generateContent(await req.json()));
+}
+
+// src/app/page.tsx — appel direct, pas HTTP
+import { generateContent } from "@/lib/generate-content";
+export default async function Page() { const data = await generateContent({...}); return <View data={data} />; }
+```
+
+Pour jobs >30s côté CF : Cloudflare Queues ou Durable Objects (message-passing, pas self-fetch).
+
+**Sur Replit (legacy)** : `http://127.0.0.1:${PORT}` obligatoire.
+
+```typescript
+const PORT = process.env.PORT || 3000;
+const res = await fetch(`http://127.0.0.1:${PORT}/api/my-endpoint`, { signal: AbortSignal.timeout(600_000) });
+const text = await res.text();
+const data = JSON.parse(text); // fallback safe vs res.json() direct
+```
```

#### Diff P0.2 — `.claude/agents/infrastructure.md` L81

```diff
@@ -81,1 +81,1 @@
-   - **Self-fetch Next.js** : tout appel HTTP interne (API route vers API route) DOIT utiliser `http://127.0.0.1:${PORT}`, JAMAIS l'URL publique. Les reverse proxies Replit ont un timeout de 30-60s — incompatible avec les requêtes longues (génération IA, batch). Le proxy coupe → le client reçoit du HTML d'erreur → `response.json()` crash
+   - **Self-fetch Next.js** : règle dépendante de l'hébergeur. **Sur Cloudflare (défaut futurs projets)** : pas de self-fetch HTTP — extraire la logique en `src/lib/` et appeler directement la fonction des deux côtés (snippet dans `fullstack.md` section "Self-fetch"). Pour jobs >30s : Cloudflare Queues. **Sur Replit (legacy)** : `http://127.0.0.1:${PORT}` obligatoire (reverse proxy timeout 30-60s coupe les requêtes longues — `response.json()` crash sur HTML d'erreur)
```

#### Diff P0.3 — `.claude/agents/infrastructure.md` L76

```diff
@@ -76,1 +76,8 @@
-   - Le script npm start DOIT exécuter `prisma migrate deploy` AVANT de lancer le serveur (recréation auto des tables si DB réinitialisée)
+   - **Sur Replit (legacy)** : le script `npm start` DOIT exécuter `prisma migrate deploy` AVANT de lancer le serveur (recréation auto si DB réinitialisée — protection persistance Replit). **Sur Cloudflare (défaut futurs projets)** : pas de "boot" stateful — migrations en GitHub Action pre-deploy :
+     ```yaml
+     - name: Apply DB migrations
+       run: pnpm drizzle-kit migrate  # ou: pnpm prisma migrate deploy
+       env:
+         DATABASE_URL: ${{ secrets.NEON_DATABASE_URL }}
+     ```
+     La migration tourne 1× par push, pas à chaque cold start. Si Neon avec branching : créer branche DB par PR pour preview deploys.
```

**Effort total** : ~30 min édition mécanique par @infrastructure (pas de réflexion, juste application). Aucun risque caps : `fullstack.md` ajoute ~15 lignes, `infrastructure.md` ajoute ~8 lignes — pas de cap formel sur ces fichiers.

---

## 3. Axe 3 — Audit fiches migration

### 3.1 Fiche ISSA Capital (`docs/migrations/issa-capital-migration.md`, ~315L)

| Critère | Verdict | Détail |
|---|---|---|
| Plan phasé exécutable Thomas seul | **PASS** | 6 phases (Préparation → Dev env → BDD → Deploy preview → Code changes → Cutover DNS), durées ciblées, commandes exactes |
| Code changes complets (5 packages) | **PASS** | Tableau section 4.1 liste les 5 packages (`bcrypt`, `jsonwebtoken`, `pg`, `sharp`, `puppeteer`) avec remplacements |
| `wrangler.toml` présent | **PASS** | Section 5, minimal mais fonctionnel pour vitrine |
| GitHub Actions présent | **PASS** | Section 6, deploy CF Pages via wrangler-action@v3, complet |
| BDD migration (commandes pg_dump → Neon) | **PASS** | Section 7 : pg_dump format=plain, psql restore, validation parité par n_live_tup |
| AI Gateway snippet | **PASS** | Section 8, snippet 3 lignes, avec note "ISSA probable peu d'IA" |
| Estimation effort réaliste | **PASS** | 4-8h pour vitrine (cohérent avec Sarani/Mandataire 6-10h pour projets plus riches) |
| Rollback documenté | **PASS** | Phase 6 "Rollback window 60j" : Replit read-only en parallèle, backup hebdo |
| Critères validation post-migration mesurables | **PASS** | Section 10 : Lighthouse seuils chiffrés, formulaire test réel, rollback test < 5 min |
| Pré-audit obligatoire | **PASS** | Section 2, checklist par domaine (code, BDD, assets, secrets, DNS) |

**Verdict ISSA** : **GO exécutable**. Aucun manque bloquant. Remarque mineure : section 4.3 mentionne "Si Prisma utilisé → migrer vers Drizzle (recommandation @fullstack S3) OU activer Prisma Data Proxy / driver adapters" — cohérent avec décision S3, OK.

### 3.2 Fiche Marrant (`docs/migrations/marrant-migration.md`, ~437L)

| Critère | Verdict | Détail |
|---|---|---|
| Plan phasé exécutable Thomas seul | **PASS** | 6 phases, **pré-audit OBLIGATOIRE** explicitement bloquant (section 2 "Sans pré-audit complet : NE PAS lancer migration") |
| Code changes complets | **PASS** | Tableau section 4.1 liste 7 packages (5 de base + `prisma` + `node-cron`), avec probabilités présence Marrant |
| `wrangler.toml` présent | **PASS** | Section 5, avec commentaires sur cron triggers (Pages ne supporte pas → Worker séparé) |
| GitHub Actions présent | **PASS** | Section 6, plus complet qu'ISSA : job test → deploy → e2e Playwright sur PR |
| BDD migration | **PASS** | Section 7 : pg_dump format=custom (binaire, plus compact), pg_restore, snippet driver Neon vs pg |
| AI Gateway snippet | **PASS** | Section 8, snippets Anthropic + OpenAI, mention Workers AI pour 30% prompts simples |
| Estimation effort réaliste | **PASS** | 11-18h cohérent avec "16 invocations @fullstack en 51 jours = projet complexe" |
| Rollback documenté | **PASS** | Phase 6, parité 60j, monitoring hebdo |
| Critères validation post-migration | **PASS** | Section 10, plus exigeant qu'ISSA : E2E Playwright 100%, parité metiers tolérance 0%, AI Gateway dashboard, cron logs Workers |
| Pré-audit obligatoire | **PASS** | Section 2 marquée "OBLIGATOIRE", checklist plus large que ISSA (websockets, cron, fs, IA volume) |

**Verdict Marrant** : **GO exécutable avec ajustement mineur**. Le seul ajustement : section 4.2 "Nettoyage Replit", item "supprimer self-fetch `127.0.0.1:${PORT}` — refactorer en appel direct fonction OU appel HTTP via URL publique avec auth" mentionne l'URL publique comme option de fallback — **c'est faux/dangereux** (le risque de timeout reverse proxy 30s reste, c'est précisément pourquoi self-fetch existait). **Recommandation** : remplacer "OU appel HTTP via URL publique avec auth" par "OU pour jobs >30s : Cloudflare Queues / Durable Objects". Édition 1 ligne.

### 3.3 Verdict Axe 3

**ISSA : GO exécutable.** **Marrant : GO exécutable après correction 1 ligne section 4.2** (10 secondes d'édition).

---

## 4. Axe 4 — Cohérence transversale (simulation parcours nouveau projet)

**Scénario simulé** : Thomas lance un nouveau projet via `@orchestrator` aujourd'hui, post-merge S3 vague 2 sans patches P0 fullstack.

| Étape | Résultat | Cohérence |
|---|---|---|
| 1. @orchestrator lit `templates/project-context.md` | Checkboxes CF/Neon en priorité (S3 acf8b21) | OK |
| 2. @orchestrator route vers @infrastructure pour setup Phase 2 | infrastructure.md mis à jour S3 → recommande GitHub + CF Pages + Neon | OK |
| 3. @infrastructure produit `wrangler.toml` + GH Actions + secrets Neon | Cohérent avec snippets fiches migration | OK |
| 4. @orchestrator route vers @fullstack pour code | fullstack.md L44 mentionne Drizzle ORM **et** Prisma sur même plan | Ambigu (P1 non corrigé) |
| 5. @fullstack lit `fullstack.md` section "Self-fetch Next.js (obligatoire)" L156-168 | **Self-fetch HTTP 127.0.0.1 présenté comme règle absolue** | **CONTRADICTION SILENCIEUSE** : @fullstack va générer du code self-fetch sur un projet CF → crash |
| 6. @fullstack lit `infrastructure.md` L76 "prisma migrate deploy au boot" | Règle absolue, pas de boot CF | **CONTRADICTION SILENCIEUSE** : @fullstack va inclure `prisma migrate deploy` dans `npm start` → ne s'exécute jamais sur CF Pages Functions |
| 7. @qa pipeline CI/CD | qa.md L98 mis à jour S3 → step deploy wrangler-action pour futurs projets | OK |
| 8. Code merge → deploy CF | **Crash au premier appel API self-fetch** + DB jamais migrée | **NO-GO production** |

**Conclusion simulation** : la chaîne `@orchestrator → @infrastructure → @qa` converge bien vers CF+Neon. La chaîne `@orchestrator → @infrastructure → @fullstack` produit une **contradiction silencieuse** sur 2 patterns critiques (self-fetch + migrate au boot). C'est exactement ce que les 3 P0 stricts (P0.1, P0.2, P0.3) résolvent.

**Verdict Axe 4** : **cohérence partielle**. La cohérence pleine requiert l'application des 3 patches P0 stricts. Sans eux, le framework est piégé.

---

## 5. Axe 5 — Angles morts non couverts

### 5.1 Refonte index.html (29 mentions Replit résiduelles, 89 prompts client-facing)

**Criticité** : **MOYENNE — différable S4 sous condition**.

- **Pas critique pour S3** si Thomas n'utilise pas index.html comme source de vérité pour les nouveaux projets dans les prochaines sessions (les agents sont déjà à jour via `.claude/agents/`)
- **Critique sous 2-3 sessions** si un utilisateur tiers ou Thomas copie-colle un prompt depuis index.html → propagation patterns Replit-only
- **Recommandation** : créer ticket explicite dans `lessons-learned.md` ou `CHANGELOG.md` "S4 — Refonte index.html (89 prompts CF-aware)" + assignation @copywriter ou @agent-factory + estimation effort (2-3h)

### 5.2 Cap orchestrator.md (819L sur 900L)

**Criticité** : **FAIBLE — surveillance active requise**.

- Marge actuelle : 81 lignes (9% du cap)
- Modifs S3 vague 2 = 3 remplacements sans ajout net
- Risque si DEFER D11 Phases 2-3 (diet orchestrator) reste non exécuté ET qu'on ajoute 1-2 nouvelles règles transversales en S4 → débordement
- **Recommandation** : prioriser D11 Phase 2 (diet orchestrator -150L cible 670L) en S4 avant tout nouvel ajout structurel

### 5.3 Lessons-learned (68L sur cap 80L) — nouveau learning S3 vague 2 ?

**Learning candidat identifié** :

> **L-S3v2-1 — Audit code parallèle audit infra évite faux positifs cohérence framework**
> Pattern observé : @infrastructure a déclaré "Self-fetch Patch P0.2 ligne 81" dans son rapport mais la modif n'a PAS été appliquée. Sans audit code indépendant @fullstack en parallèle, le faux positif passait silencieux. **Règle proposée** : pour toute mise à jour transversale framework affectant du code (snippets/patterns), obliger un audit code parallèle d'un agent technique distinct (généralement @fullstack si modifs touchent code/snippets, @qa si modifs touchent tests/CI). Le reviewer doit vérifier empiriquement par Grep que les patches code revendiqués sont effectivement appliqués (pas juste recommandés).

- Cap : 68L + 1L net = 69L (sous cap 80L)
- Conservation of rules (commandement 8) : OK, marge largement suffisante
- **Recommandation** : ajouter ce learning + supprimer/fusionner 1 learning P2 obsolète (si applicable) pour respecter net-zero

---

## 6. Plan d'application séquencé

### Ordre des commits (recommandé)

1. **Commit 1** : merger les 11 modifs @infrastructure (déjà appliquées, juste à committer si pas encore fait)
   - Message : `S3 vague 2 — propagation CF+Neon framework (11 modifs sur 7 fichiers)`
2. **Commit 2** : appliquer les 3 diffs P0 stricts (P0.1, P0.2, P0.3) → édition mécanique par @infrastructure
   - Message : `S3 vague 2 — patches P0 fullstack : self-fetch CF + migrations CI pre-deploy`
3. **Commit 3** : correction 1 ligne fiche Marrant section 4.2 (self-fetch fallback dangereux)
   - Message : `fix(migration/marrant): retirer fallback URL publique self-fetch (timeout 30s)`
4. **Commit 4** : ajout learning S3v2-1 dans `lessons-learned.md`
   - Message : `lessons: audit code parallèle audit infra (S3 vague 2)`
5. **Commit 5** (optionnel, suivi) : créer ticket backlog "S4 — Refonte index.html 89 prompts CF-aware"

### Tests Bash post-application (5 commandes minimum)

```bash
# 1. Vérifier que self-fetch est bien nuancé dans fullstack.md
grep -n "Sur Cloudflare" .claude/agents/fullstack.md | head -5
# Attendu : ≥ 1 hit dans la section Self-fetch (autour L156-180)

# 2. Vérifier que prisma migrate au boot est bien nuancé dans infrastructure.md
grep -n "Sur Cloudflare\|GitHub Action pre-deploy" .claude/agents/infrastructure.md
# Attendu : ≥ 2 hits (L76 zone migrations + ailleurs)

# 3. Vérifier que infrastructure.md L81 mentionne Cloudflare ET Replit
sed -n '81p' .claude/agents/infrastructure.md | grep -E "Cloudflare.*Replit|Replit.*Cloudflare"
# Attendu : 1 match (formulation double-rail)

# 4. Vérifier caps
wc -l CLAUDE.md .claude/agents/orchestrator.md docs/lessons-learned.md
# Attendu : CLAUDE.md ≤ 125, orchestrator.md ≤ 900, lessons-learned.md ≤ 80

# 5. Vérifier qu'aucun fichier source ne contient une régression Replit-default
grep -rEn "PostgreSQL Replit (par défaut|défaut|recommandé)" .claude/ CLAUDE.md _gates.md _base-agent-protocol.md templates/
# Attendu : 0 hit (toutes les mentions Replit doivent être qualifiées "legacy")
```

### Test Bash bonus (cohérence migration)

```bash
# 6. Marrant fiche : vérifier que le fallback dangereux est corrigé
grep -n "URL publique avec auth" docs/migrations/marrant-migration.md
# Attendu : 0 hit après correction
```

---

## 7. Risques résiduels post-application

1. **Snippets non testés en prod** (déjà identifié par @fullstack) : les 10 snippets de référence (wrangler.toml, GH Actions, Drizzle+Neon, NextAuth v5 edge, Stripe webhook edge, AI Gateway, R2, CF Images, ctx.waitUntil, bcryptjs) ne sont pas encore validés contre une vraie infra CF. **Mitigation** : ISSA Capital = pilote de validation (vitrine, faible risque). Repatcher framework si snippet pète.
2. **P1 Drizzle vs Prisma non tranché** : `fullstack.md` L44 garde les 2 sur même plan. Risque qu'un agent choisisse Prisma "par habitude" sur greenfield CF. **Mitigation différée** : à inclure dans la session de refonte index.html ou un patch dédié S4.
3. **`CLOUDFLARE_ACTIONS.md` template inexistant** : `CLAUDE.md` L64 référence un template qui n'existe pas. **Mitigation** : soit créer un squelette en S4, soit retirer la référence anticipée.
4. **Refonte index.html non planifiée** : 29 hits Replit dans 89 prompts client-facing. **Mitigation** : ticket explicite + assignation S4.
5. **NextAuth v5 beta** + `@cloudflare/next-on-pages` vs `@opennextjs/cloudflare` (déjà signalés par @fullstack section 6) : risque API change / migration adapter. **Mitigation** : pilote DevRefs/ISSA tranche, mise à jour framework post-pilote.

---

## 8. Recommandation finale Thomas (4 actions actionnables)

1. **APPLIQUER les 3 diffs P0 stricts** (P0.1 fullstack.md L156-168 + P0.2 infrastructure.md L81 + P0.3 infrastructure.md L76) **avant tout nouveau projet greenfield CF**. Effort : 30 min édition mécanique par @infrastructure. Sans ça, contradiction silencieuse → crash production.
2. **CORRIGER 1 ligne fiche Marrant section 4.2** : retirer "OU appel HTTP via URL publique avec auth" (fallback faux/dangereux, le risque de timeout 30s reste). Effort : 10 secondes.
3. **EXÉCUTER ISSA Capital comme pilote de validation des snippets CF** : projet vitrine simple, 4-8h, risque faible — valide empiriquement les patterns wrangler.toml + GH Actions + Neon driver. Si OK → snippets canoniques. Si KO → repatch framework.
4. **PLANIFIER S4** : (a) refonte index.html 89 prompts CF-aware [@copywriter ou @agent-factory, ~2-3h], (b) D11 Phase 2 diet orchestrator.md (-150L cible 670L) avant tout nouvel ajout structurel, (c) trancher Drizzle vs Prisma comme défaut greenfield CF dans `fullstack.md` L44.

---

## 9. Top 3 corrections prioritaires

| Rang | Action | Impact | Effort | Bloquant ? |
|---|---|---|---|---|
| 1 | Diff P0.2 + P0.3 sur `infrastructure.md` (self-fetch + migrate au boot) | Évite crash production tout nouveau projet CF | 15 min | OUI avant nouveau projet greenfield CF |
| 2 | Diff P0.1 sur `fullstack.md` (self-fetch CF) | Évite contradiction silencieuse @fullstack/@infrastructure | 15 min | OUI avant nouveau projet greenfield CF |
| 3 | Correction 1 ligne fiche Marrant section 4.2 | Évite préconisation dangereuse | 10 sec | OUI avant exécution migration Marrant |

---

## 10. Verdict final

**GO CONDITIONNEL** :
- 11 modifs @infrastructure : **GO IMMÉDIAT** (mergeables sans condition)
- Fiche ISSA : **GO EXÉCUTABLE**
- Fiche Marrant : **GO EXÉCUTABLE après correction 1 ligne**
- Cohérence transversale post-merge : **incomplète SANS les 3 P0 stricts** → application obligatoire avant tout nouveau projet greenfield CF

**Le framework Gradient Agents est cohérent à 90% post-S3 vague 2. Les 10% restants tiennent en 30 min d'édition mécanique (3 diffs P0). Sans ces 30 min, un nouveau projet greenfield CF crashera en production.**

---

## Handoff → @orchestrator

**Verdict net** : **GO CONDITIONNEL**. Merger immédiatement les 11 modifs @infrastructure. Appliquer les 3 diffs P0 stricts (P0.1, P0.2, P0.3) en commit séparé AVANT tout nouveau projet greenfield CF. Corriger 1 ligne fiche Marrant section 4.2.

**Ordre d'application** :
1. Commit 11 modifs @infrastructure (si pas encore fait)
2. Demander à @infrastructure d'appliquer mécaniquement les 3 diffs P0 stricts (section 2.4 de ce rapport) → commit séparé
3. Demander à @infrastructure de corriger fiche Marrant section 4.2 (1 ligne)
4. Ajouter learning S3v2-1 dans `lessons-learned.md` (section 5.3 de ce rapport)
5. Créer ticket backlog "S4 — Refonte index.html 89 prompts CF-aware"

**Tests Bash post-application** : voir section 6 (5 commandes obligatoires + 1 bonus).

**Risques résiduels post-application** : section 7 (snippets non testés en prod, P1 Drizzle vs Prisma, CLOUDFLARE_ACTIONS.md inexistant, refonte index.html, NextAuth v5 beta).

**Agent suivant** : @infrastructure (application mécanique des 3 diffs P0 + correction fiche Marrant). Puis Thomas (validation merge + lancement ISSA pilote).

**Pre-commit check** : N/A (rapport markdown uniquement).

**Actions Replit requises** : aucune.
**Actions Cloudflare/GitHub requises** : aucune (rapport documentaire).
