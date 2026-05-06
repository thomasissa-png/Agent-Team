# Migration ISSA Capital — Replit → GitHub + Cloudflare Pages + Neon

**Date emission** : 2026-05-06 (S3)
**Auteur** : @infrastructure
**Statut** : Pret a executer (en attente confirmation Thomas pre-audit)
**Criticite** : Faible (vitrine institutionnelle, pas de funnel paiement actif)
**Effort estime** : 4-8h (projet leger, peu de surface technique)

---

## 1. Identite projet

| Champ | Valeur |
|---|---|
| Nom | ISSA Capital |
| Type | Site institutionnel / family office / vitrine |
| Repo GitHub | `[A CONFIRMER PAR THOMAS]` (probable : `gradient-thomas/issa-capital` ou similaire) |
| Stack actuelle | Next.js (App Router) + PostgreSQL Replit + Replit Deployments |
| URL prod actuelle | `[A CONFIRMER]` (probable : `issacapital.replit.app` + custom domain) |
| Mode (Vitrine/Funnel) | **Vitrine** (cf. founder-preferences S2 — ISSA classe Vitrine) |
| Volume DB | Faible (probable < 100 MB — formulaire contact uniquement ?) |
| Trafic estime | Faible (institutionnel, pas de campagne acquisition active) |
| Criticite business | Faible (pas de chiffre d'affaires direct, image de marque) |

**Implication Vitrine** : pas de funnel achat, pas de paywall, pas de cron complexe. Migration la plus simple du portefeuille.

---

## 2. Pre-audit obligatoire (a executer par Thomas avant Phase 0)

Checklist d'inventaire — confirmer ou infirmer chaque item :

### 2.1 Code & dependances
- [ ] Lister contenu `package.json` → `cat package.json | jq '.dependencies, .devDependencies'`
- [ ] Verifier presence des 5 packages incompatibles CF Workers : `bcrypt`, `jsonwebtoken`, `pg`, `sharp`, `puppeteer`
- [ ] Detecter usage `process.env.REPL_SLUG` ou `REPL_OWNER` (variables Replit-specifiques)
- [ ] Detecter self-fetch interne : `grep -rn "127.0.0.1\|localhost:\${PORT}" src/`
- [ ] Detecter API routes longues (> 30s) → `grep -rn "maxDuration\|export const runtime" src/app/api/`

### 2.2 BDD
- [ ] `pg_dump --schema-only` → compter tables (estimation : 1-3 tables : `contact_form`, `newsletter`, peut-etre `admin_users`)
- [ ] `SELECT pg_size_pretty(pg_database_size(current_database()))` → confirmer < 100 MB
- [ ] Verifier extensions Postgres utilisees (probable : aucune) — Neon supporte 60+ extensions
- [ ] Compter rows par table → cible parite post-migration

### 2.3 Assets & storage
- [ ] Lister assets statiques `public/` (logos, images) — taille totale ?
- [ ] Identifier eventuels uploads utilisateurs (probable : aucun pour vitrine)
- [ ] Identifier fichiers stockes hors `public/` (PDF rapports investisseurs ?)

### 2.4 Secrets & integrations
- [ ] Lister Replit Secrets : `DATABASE_URL`, `RESEND_API_KEY` (?), `SMTP_*` (?), eventuels webhooks
- [ ] Identifier integrations externes : email transactionnel, formulaire contact, analytics (GA4 / Plausible ?)
- [ ] Verifier presence Stripe ou autre paiement → si OUI, **ce n'est pas Vitrine, escalader**

### 2.5 DNS & domaine
- [ ] Domaine custom utilise ? (probable : `issacapital.com` ou `.fr`)
- [ ] DNS gere ou ? (Cloudflare deja ? OVH ? Gandi ?)
- [ ] Certificat SSL : Replit auto ou Cloudflare ?

**Verdict pre-audit attendu** : confirmer profil "Vitrine simple, < 100 MB DB, 0-2 secrets externes, 0 cron, 0 paiement" → migration en 4-8h. Si surprise (Stripe, gros volume, lib native lourde) → escalader @fullstack.

---

## 3. Plan de migration phase

### Phase 0 — Preparation (30 min)
- Confirmer pre-audit ci-dessus avec Thomas
- Creer compte Neon (free tier suffit : 0.5 GB, branching illimite)
- Verifier compte Cloudflare Pages actif
- Generer token Cloudflare scope projet ISSA (Account: Cloudflare Pages — Edit, Zone: DNS — Edit pour le domaine ISSA uniquement)
- Stocker token dans GitHub Secrets : `CLOUDFLARE_API_TOKEN_ISSA`, `CLOUDFLARE_ACCOUNT_ID`

### Phase 1 — Dev environment (1h)
- Cloner repo ISSA en local (ou Codespaces)
- Creer branche `migration/cloudflare-neon`
- Installer Wrangler : `npm install -g wrangler` puis `wrangler login`
- Tester `next build` localement → si OK, projet build-compatible
- **Si erreur sharp/bcrypt** → appliquer remplacements Phase 4 immediatement

### Phase 2 — BDD migration (1h)
- `pg_dump` depuis Replit (cf. snippet section 7)
- Creer projet Neon : `gradient-issa-capital`, region `eu-west-1` (Paris) ou `eu-central-1`
- Restore dump dans Neon
- Validation parite : count rows, sample 5 lignes par table, comparer
- Recuperer `DATABASE_URL` Neon (avec `?sslmode=require`)

### Phase 3 — Deploy Cloudflare Pages preview (2h)
- Choix architecture : **Pages avec next-on-pages adapter** (vitrine = SSR leger compatible Pages)
- Ajouter `wrangler.toml` (cf. section 5)
- Ajouter `.github/workflows/deploy.yml` (cf. section 6)
- Configurer Pages project sur dashboard Cloudflare : `gradient-issa-capital`
- Push branche `migration/cloudflare-neon` → preview deploy auto
- Configurer secrets Pages : `DATABASE_URL` (Neon), `RESEND_API_KEY`, `NODE_ENV=production`
- Tester preview URL : home, formulaire contact, mentions legales, tous liens

### Phase 4 — Code changes (1-3h selon resultats pre-audit)
Cf. section 4 ci-dessous. Pour ISSA (vitrine), probable que seul `bcrypt` soit a remplacer si admin login existe.

### Phase 5 — Cutover DNS (30 min)
- Activer custom domain sur Pages : `issacapital.com` (et `www.`)
- Si DNS deja sur Cloudflare : un clic, propagation < 1 min
- Si DNS ailleurs : pointer NS vers Cloudflare (propagation 24-48h, faire la veille)
- Tester prod : home, formulaire, SEO meta tags
- **Maintenir Replit deployment actif en parallele 60j** (rollback window)

### Phase 6 — Rollback window (60j)
- Replit en read-only : ne plus pousser de commit, mais deployment reste up
- Backup Neon hebdomadaire (pg_dump local + R2 storage)
- A J+60 : decommissioner Replit, supprimer Replit DB

---

## 4. Code changes — checklist

### 4.1 Packages a remplacer
| Avant | Apres | Justification |
|---|---|---|
| `bcrypt` | `bcryptjs` | Workers ne supportent pas modules natifs N-API |
| `jsonwebtoken` | `jose` | jose est WebCrypto-native, optimal Workers |
| `pg` | `@neondatabase/serverless` | Driver HTTP optimise edge, pas de pool TCP |
| `sharp` | Cloudflare Images (`/cdn-cgi/image/`) | Sharp = native, incompatible Workers |
| `puppeteer` | Cloudflare Browser Rendering API | Si screenshots/PDF necessaires |

Pour ISSA vitrine, probables : `bcryptjs` (si admin) + `@neondatabase/serverless`. Les autres : sans objet.

### 4.2 Nettoyage Replit
- [ ] Supprimer `.replit`
- [ ] Supprimer `replit.nix`
- [ ] Supprimer toute reference `process.env.REPL_*`
- [ ] Supprimer logique de migration auto Prisma au boot (Cloudflare gere via build)
- [ ] Supprimer self-fetch `127.0.0.1` (Workers n'ont pas de port local)

### 4.3 Adaptation Next.js
- [ ] `next.config.js` : ajouter `output: 'standalone'` ou utiliser `@cloudflare/next-on-pages`
- [ ] Verifier toutes les API routes : ajouter `export const runtime = 'edge'` (sauf si dependance Node.js irreductible)
- [ ] Si Prisma utilise → migrer vers Drizzle (recommandation @fullstack S3) OU activer Prisma Data Proxy / driver adapters
- [ ] Adapter `next/image` si `sharp` etait utilise → loader Cloudflare Images

### 4.4 Variables d'environnement
- [ ] Renommer `DATABASE_URL` Replit → `DATABASE_URL` Neon (meme nom, valeur differente)
- [ ] Stocker dans Cloudflare Pages Secrets via dashboard ou `wrangler pages secret put`
- [ ] Mirror dans GitHub Secrets pour preview deploys CI

---

## 5. wrangler.toml minimal (Pages)

```toml
name = "gradient-issa-capital"
compatibility_date = "2026-05-01"
compatibility_flags = ["nodejs_compat"]
pages_build_output_dir = ".vercel/output/static"

[vars]
NODE_ENV = "production"

# Secrets via wrangler pages secret put DATABASE_URL --project-name=gradient-issa-capital
# DATABASE_URL = (Neon connection string)
# RESEND_API_KEY = (si formulaire contact)
```

---

## 6. GitHub Actions — `.github/workflows/deploy.yml`

```yaml
name: Deploy ISSA Capital
on:
  push:
    branches: [master]
  pull_request:
    branches: [master]

jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      deployments: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npx tsc --noEmit && npx next lint
      - run: npx @cloudflare/next-on-pages@1
      - name: Deploy
        uses: cloudflare/wrangler-action@v3
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN_ISSA }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          command: pages deploy .vercel/output/static --project-name=gradient-issa-capital --branch=${{ github.head_ref || github.ref_name }}
```

PR → preview deploy auto. Push master → prod deploy.

---

## 7. BDD migration — commandes exactes

### 7.1 Dump depuis Replit
```bash
# Dans Replit shell :
pg_dump "$DATABASE_URL" \
  --no-owner --no-acl --clean --if-exists \
  --format=plain \
  --file=/tmp/issa-dump.sql

# Telecharger via Replit file browser ou :
cat /tmp/issa-dump.sql | base64  # puis decode local
```

### 7.2 Restore Neon
```bash
# Local, apres creation projet Neon :
export NEON_URL="postgresql://user:pass@ep-xxx.eu-west-1.aws.neon.tech/issa_capital?sslmode=require"
psql "$NEON_URL" -f issa-dump.sql

# Validation parite :
psql "$NEON_URL" -c "SELECT schemaname, tablename, n_live_tup FROM pg_stat_user_tables ORDER BY tablename;"
# Comparer avec meme requete sur Replit DB
```

### 7.3 Configuration Cloudflare Pages
```bash
wrangler pages secret put DATABASE_URL --project-name=gradient-issa-capital
# Coller : postgresql://...neon.tech/issa_capital?sslmode=require
```

---

## 8. AI Gateway activation (si IA presente)

**ISSA Capital probable** : peu d'IA active (vitrine). Si formulaire de contact utilise classification IA ou si chatbot : activer AI Gateway (rapport @ia S3, `-20-30%` facture immediat).

```javascript
// avant
const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY })

// apres (1 ligne change)
const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
  baseURL: `https://gateway.ai.cloudflare.com/v1/${ACCOUNT_ID}/issa-gateway/anthropic`
})
```

Setup AI Gateway : dashboard Cloudflare > AI > AI Gateway > Create > `issa-gateway`.

---

## 9. Estimation effort

| Phase | Duree |
|---|---|
| Phase 0 Preparation | 30 min |
| Phase 1 Dev env | 1h |
| Phase 2 BDD | 1h |
| Phase 3 Deploy preview | 2h |
| Phase 4 Code changes | 1-3h (selon pre-audit) |
| Phase 5 Cutover DNS | 30 min |
| **Total** | **6-8h** |

Si admin auth absent et zero lib native : peut tomber a 4h.

---

## 10. Criteres validation post-migration

- [ ] URL `issacapital.com` repond 200
- [ ] Lighthouse desktop : LCP < 2.5s, CLS < 0.1, INP < 200ms
- [ ] Lighthouse mobile : LCP < 4s, CLS < 0.1
- [ ] Formulaire contact envoie email (test reel)
- [ ] Toutes pages : home, equipe, services, mentions legales, contact
- [ ] Robots.txt + sitemap.xml accessibles
- [ ] OG tags presents (test sharingdebug FB / cards Twitter)
- [ ] HTTPS force, HSTS active (Cloudflare auto)
- [ ] Health check `/api/health` retourne 200 + DB OK
- [ ] Rollback test : forcer une bascule DNS retour Replit, mesurer downtime (cible < 5 min)

---

## 11. Risques specifiques + mitigations

| Risque | Probabilite | Mitigation |
|---|---|---|
| DNS NS change (si DNS pas deja Cloudflare) → propagation 24-48h | Moyenne | Faire la veille du go-live, monitor `dig`, prevoir fallback Replit |
| Formulaire contact email non delivrable (SPF/DKIM si nouvelle config) | Faible | Configurer SPF/DKIM/DMARC AVANT cutover. Tester avec mail-tester.com |
| Admin login casse si bcrypt non remplace | Moyenne | Pre-audit detecte. bcryptjs drop-in replacement, hashes compatibles |
| SEO drop si URLs changent | Faible (URLs identiques) | Verifier sitemap, soumettre Google Search Console, monitor 30j |
| Backup Replit perdu pendant migration | Faible | pg_dump triple : local + Neon backup + R2 storage |

---

## 12. Contacts / escalade

| Probleme | Tagger |
|---|---|
| Build CF echoue (next-on-pages) | @fullstack |
| Driver Neon erreur connexion | @infrastructure (moi) |
| DNS / cutover | @infrastructure |
| Lib native incontournable detectee pre-audit | @fullstack — escalade decision (rester Replit ou refactor) |
| Performance degradee post-migration | @infrastructure + audit perf |
| Email non delivrable | @infrastructure (SPF/DKIM/DMARC) |

---

**Handoff → Thomas (execution) puis @reviewer (audit post-migration J+7)**
- Pre-requis : valider pre-audit section 2
- Cible cutover : a planifier (recommandation : un mardi ou mercredi matin, jamais vendredi)
- Apres execution : @reviewer audit URL prod + parite + rollback test
