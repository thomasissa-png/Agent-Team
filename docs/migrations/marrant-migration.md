# Migration Deviens Marrant — Replit → GitHub + Cloudflare Pages + Neon

**Date emission** : 2026-05-06 (S3)
**Auteur** : @infrastructure
**Statut** : Pret a executer (en attente confirmation Thomas pre-audit obligatoire)
**Criticite** : Moyenne-Haute (projet long-courrier 51 jours, 51 entrees historique, pattern @fullstack 16x = projet COMPLEXE)
**Effort estime** : 10-20h (audit pre-migration obligatoire avant cutover)

---

## 1. Identite projet

| Champ | Valeur |
|---|---|
| Nom | Deviens Marrant (alias Marrant) |
| Type | Plateforme contenu / formation humour ? `[A CONFIRMER]` |
| Repo GitHub | `[A CONFIRMER PAR THOMAS]` (probable : `gradient-thomas/deviens-marrant`) |
| Stack actuelle | Next.js (App Router) + PostgreSQL Replit + Replit Deployments |
| URL prod actuelle | `[A CONFIRMER]` (probable : `deviensmarrant.com` ou `.replit.app`) |
| Mode (Vitrine/Funnel) | **Funnel probable** (51 jours dev = produit avec parcours utilisateur, pas vitrine) |
| Volume DB | Inconnu — **a auditer** (probable > 100 MB si contenus lourds) |
| Trafic estime | `[A CONFIRMER]` |
| Criticite business | Moyenne-Haute (investissement temps important) |

**Implication 51 jours dev + 16 invocations @fullstack** : projet techniquement riche. Migration probable 10-20h, pas 4-8h. Audit obligatoire.

---

## 2. Pre-audit OBLIGATOIRE (a executer par Thomas avant Phase 0)

**Sans pre-audit complet : NE PAS lancer migration.** Risque casse production.

### 2.1 Code & dependances (priorite 1)
- [ ] Lister `package.json` complet : `cat package.json | jq '.dependencies, .devDependencies' | wc -l` (compter packages)
- [ ] **Detecter les 5 packages critiques incompatibles CF Workers** :
  ```bash
  jq '.dependencies | keys[]' package.json | grep -E "^\"(bcrypt|jsonwebtoken|pg|sharp|puppeteer)\"$"
  ```
- [ ] Detecter autres modules natifs : `grep -E "node-gyp|prebuild|napi|.node$" node_modules/.package-lock.json` (proxy)
- [ ] Detecter usage filesystem : `grep -rn "fs\.writeFile\|fs\.readFile\|fs\.unlink" src/` (Workers = stateless, pas de fs persistant)
- [ ] Detecter self-fetch : `grep -rn "127.0.0.1\|process.env.PORT" src/`
- [ ] Detecter API routes longues : `grep -rn "maxDuration\|export const runtime" src/app/api/` (CF limite 30s CPU sur free, 5min sur paid)
- [ ] Detecter websockets : `grep -rn "WebSocket\|socket.io\|ws " src/` (Workers supportent via Durable Objects, pas Pages)
- [ ] Detecter cron jobs : verifier `.replit` ou `package.json` scripts pour `node-cron`, `bull`, `agenda` (CF = Cron Triggers Workers)

### 2.2 BDD (priorite 1)
- [ ] `pg_dump --schema-only "$DATABASE_URL" | grep -c "CREATE TABLE"` → nombre de tables
- [ ] `psql "$DATABASE_URL" -c "SELECT pg_size_pretty(pg_database_size(current_database()));"` → taille reelle
- [ ] **Si > 0.5 GB** : Neon free tier suffit pas, basculer Neon Launch ($19/mois) ou Pro
- [ ] Lister extensions : `psql -c "SELECT extname FROM pg_extension;"` — verifier chaque support Neon
- [ ] Detecter triggers/functions PL/pgSQL : `psql -c "\df+ public.*" | head` — peuvent compliquer migration
- [ ] Compter rows par table : `psql -c "SELECT schemaname, tablename, n_live_tup FROM pg_stat_user_tables ORDER BY n_live_tup DESC;"`

### 2.3 IA & cout (priorite 2)
- [ ] Detecter usage IA : `grep -rn "anthropic\|openai\|@anthropic-ai\|@openai" src/`
- [ ] Si IA present : volume tokens/mois ? cout actuel ? → **AI Gateway -20-30% activable J0** (cf. section 8)
- [ ] Detecter generation contenu masse : si humour genere par IA, cron-based ? sur demande ?
- [ ] Detecter image generation : DALL-E ? Midjourney ? Stable Diffusion local ? (Workers AI possible alternative)

### 2.4 Assets & storage (priorite 2)
- [ ] Taille `public/` : `du -sh public/`
- [ ] Uploads utilisateurs ? `grep -rn "multer\|formidable\|busboy" src/` (a migrer vers R2 si oui)
- [ ] Audio/video assets ? (R2 pertinent pour streaming, pas de egress fee)
- [ ] CDN actuel ? (Replit basique vs Cloudflare CDN gratuit auto)

### 2.5 Auth & paiement (priorite 1)
- [ ] Auth implementee ? NextAuth ? custom JWT ? Clerk ?
- [ ] Si custom JWT avec `jsonwebtoken` → remplacer par `jose`
- [ ] Stripe present ? `grep -rn "stripe" src/` — webhooks ? abonnements ?
- [ ] Si Stripe webhooks : verifier endpoint `/api/webhooks/stripe` → CF Workers compatible (HMAC verification OK)

### 2.6 Secrets & integrations
- [ ] Lister TOUS Replit Secrets (ne pas exposer valeurs) : noms uniquement
- [ ] Pour chaque secret : confirmer compatibilite CF Pages Secrets (limite 64 KB total)
- [ ] Integrations externes : SendGrid/Resend/Postmark, Stripe, analytics, Sentry, etc.

### 2.7 DNS & SEO
- [ ] Domaine : `deviensmarrant.com` ou autre ?
- [ ] DNS actuel : Cloudflare deja ? Sinon : prevoir migration NS 48h avant
- [ ] Trafic SEO : pages indexees Google ? sitemap ? canonical URLs critiques ?
- [ ] Backlinks externes pointant URLs specifiques ? (ne PAS casser routes)

**Verdict pre-audit** : si > 3 surprises (lib native lourde, > 1 GB DB, websockets, > 10 cron jobs) → escalader @fullstack pour decision : refactor lourd OU rester Replit OU partir Vercel.

---

## 3. Plan de migration phase

### Phase 0 — Preparation (1h)
- Confirmer pre-audit complet avec Thomas
- Decision architecture : **Pages avec next-on-pages** (defaut) OU **Workers + Pages separes** si API lourde
- Creer compte Neon : projet `gradient-deviens-marrant`, region `eu-west-1`
- Plan tier Neon : Free (0.5 GB) si DB < 400 MB ; Launch ($19) si plus
- Generer token Cloudflare scope projet Marrant
- Stocker tokens GitHub Secrets : `CLOUDFLARE_API_TOKEN_MARRANT`, `CLOUDFLARE_ACCOUNT_ID`

### Phase 1 — Dev environment (2h)
- Cloner repo, creer branche `migration/cloudflare-neon`
- `npm install` local, tester `next build` → noter erreurs (probable : sharp, bcrypt si presents)
- Installer Wrangler `npm install -g wrangler`
- Lancer `wrangler pages dev` localement avec DB Neon de dev
- Documenter tous les warnings/erreurs build

### Phase 2 — Code changes (4-10h selon resultats pre-audit)
Cf. section 4 pour checklist detaillee. **C'est la phase la plus longue pour Marrant** (vs ISSA ou cette phase = 1h).

### Phase 3 — BDD migration (1-2h)
- `pg_dump` complet depuis Replit (cf. section 7)
- Restore Neon
- Validation parite stricte (count rows par table, sample 10 lignes par table critique)
- Tests requetes complexes : si triggers/functions, valider chaque cas

### Phase 4 — Deploy Cloudflare Pages preview (2h)
- Push branche → preview deploy auto
- Configurer Pages secrets (DATABASE_URL Neon, STRIPE_*, AI keys, etc.)
- Tester preview URL : tous parcours utilisateur, paiement test (Stripe test mode), generation contenu IA
- **Tests E2E** : si Playwright present (probable cf. pattern complexite), faire passer suite complete sur preview

### Phase 5 — Cutover DNS (1h, planifie hors heures pic)
- Activer custom domain Pages
- Bascule DNS (si CF deja DNS provider : 1 clic)
- **Maintenir Replit deployment actif 60j parallele**
- Monitor : Sentry errors, Cloudflare Analytics, Neon connection count

### Phase 6 — Rollback window (60j)
- Replit read-only (gel commits, deployment up)
- Backup Neon hebdomadaire automatique (pg_dump → R2)
- A J+30 : check parite trafic + erreurs ; si OK, plan decommission Replit
- A J+60 : couper Replit definitivement

---

## 4. Code changes — checklist detaillee

### 4.1 Packages a remplacer (probable Marrant)
| Avant | Apres | Probabilite presence Marrant |
|---|---|---|
| `bcrypt` | `bcryptjs` | Haute (auth probable) |
| `jsonwebtoken` | `jose` | Moyenne |
| `pg` ou `node-postgres` | `@neondatabase/serverless` | Tres haute (utilise PostgreSQL Replit) |
| `prisma` | Drizzle (recommandation @fullstack S3) OU Prisma + driver adapter Neon | Moyenne — si Prisma, garder mais activer driver adapter |
| `sharp` | Cloudflare Images `/cdn-cgi/image/` | Moyenne (si traitement image) |
| `puppeteer` | Cloudflare Browser Rendering | Faible |
| `node-cron` | Cloudflare Cron Triggers (Workers) | Moyenne (si automatisations) |

### 4.2 Nettoyage Replit
- [ ] Supprimer `.replit`
- [ ] Supprimer `replit.nix`
- [ ] Supprimer toute reference `process.env.REPL_*`
- [ ] Supprimer logique migration auto Prisma au boot
- [ ] **Critique** : supprimer self-fetch `127.0.0.1:${PORT}` — refactorer en appel direct fonction OU pour jobs >30s : Cloudflare Queues / Durable Objects
- [ ] Supprimer `console.log` Replit-specific debug

### 4.3 Adaptation Next.js
- [ ] `next.config.js` : utiliser `@cloudflare/next-on-pages` adapter
- [ ] Auditer chaque API route : `export const runtime = 'edge'` partout sauf irreductible Node
- [ ] Routes irreductibles Node → migrer vers **Cloudflare Workers separes** (deploy via Wrangler) appelees depuis Pages
- [ ] Si Prisma : ajouter `previewFeatures = ["driverAdapters"]` + `@prisma/adapter-neon`
- [ ] `next/image` : configurer loader Cloudflare Images si sharp etait utilise

### 4.4 Cron jobs (si presents)
- [ ] Inventaire cron Replit : extraire de `.replit` ou code
- [ ] Migrer chaque cron vers Cloudflare Cron Triggers (`wrangler.toml [triggers] crons`)
- [ ] OU vers GitHub Actions schedule (si tache lourde > 30s)
- [ ] OU vers service externe (Upstash QStash, $0 free tier)

### 4.5 Storage / uploads
- [ ] Si uploads utilisateurs → migrer vers R2 (S3-compatible, 10 GB free, 0 egress)
- [ ] Adapter SDK : `@aws-sdk/client-s3` avec endpoint R2
- [ ] Migration assets existants : script one-shot Replit → R2 via SDK

### 4.6 Variables d'environnement
- [ ] Mapper TOUS Replit Secrets → Cloudflare Pages Secrets via `wrangler pages secret put`
- [ ] Mirror prod secrets dans GitHub Secrets pour CI builds
- [ ] Documenter dans `docs/infra/secrets.md` (noms uniquement, jamais valeurs)

---

## 5. wrangler.toml minimal (Pages + Cron eventuels)

```toml
name = "gradient-deviens-marrant"
compatibility_date = "2026-05-01"
compatibility_flags = ["nodejs_compat"]
pages_build_output_dir = ".vercel/output/static"

[vars]
NODE_ENV = "production"
NEXT_PUBLIC_APP_URL = "https://deviensmarrant.com"

# Si cron jobs (ex : envoi newsletter quotidien) :
# [[triggers.crons]]
# cron = "0 8 * * *"  # 8h UTC chaque jour
# Note : Pages ne supporte pas cron natif — deployer Worker separe pour cron

# Bindings R2 (si uploads) :
# [[r2_buckets]]
# binding = "MARRANT_ASSETS"
# bucket_name = "gradient-marrant-assets"

# Secrets via wrangler pages secret put :
# DATABASE_URL, STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET, ANTHROPIC_API_KEY, RESEND_API_KEY, NEXTAUTH_SECRET
```

---

## 6. GitHub Actions — `.github/workflows/deploy.yml`

```yaml
name: Deploy Deviens Marrant
on:
  push:
    branches: [master]
  pull_request:
    branches: [master]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npx tsc --noEmit
      - run: npx next lint
      - run: npm test --if-present

  deploy:
    needs: test
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
      - run: npx @cloudflare/next-on-pages@1
      - name: Deploy to Cloudflare Pages
        uses: cloudflare/wrangler-action@v3
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN_MARRANT }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          command: pages deploy .vercel/output/static --project-name=gradient-deviens-marrant --branch=${{ github.head_ref || github.ref_name }}

  e2e:
    needs: deploy
    if: github.event_name == 'pull_request'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npx playwright test
        env:
          BASE_URL: ${{ steps.deploy.outputs.deployment-url }}
```

PR → preview deploy + E2E. Push master → tests + prod deploy.

---

## 7. BDD migration — commandes exactes

### 7.1 Dump complet depuis Replit
```bash
# Replit shell :
pg_dump "$DATABASE_URL" \
  --no-owner --no-acl --clean --if-exists \
  --format=custom \
  --file=/tmp/marrant-dump.dump

# Verification taille :
ls -lh /tmp/marrant-dump.dump

# Si > 100 MB : split en plusieurs dumps par schema/table critique
```

### 7.2 Telecharger dump local
- Via Replit file browser (drag&drop)
- OU `base64 /tmp/marrant-dump.dump > /tmp/dump.b64` puis copier-coller chunks

### 7.3 Restore Neon
```bash
# Local :
export NEON_URL="postgresql://user:pass@ep-xxx.eu-west-1.aws.neon.tech/marrant?sslmode=require"
pg_restore --no-owner --no-acl --clean --if-exists \
  -d "$NEON_URL" \
  /tmp/marrant-dump.dump

# Validation parite :
psql "$NEON_URL" -c "SELECT schemaname, tablename, n_live_tup FROM pg_stat_user_tables ORDER BY n_live_tup DESC;"
# Comparer ligne a ligne avec Replit

# Sample queries critiques (a adapter selon Marrant) :
psql "$NEON_URL" -c "SELECT COUNT(*) FROM users;"
psql "$NEON_URL" -c "SELECT COUNT(*) FROM contents;"  # ou table contenu humour
psql "$NEON_URL" -c "SELECT * FROM users ORDER BY created_at DESC LIMIT 5;"
```

### 7.4 Configuration Cloudflare Pages
```bash
wrangler pages secret put DATABASE_URL --project-name=gradient-deviens-marrant
# Coller URL Neon avec sslmode=require et channel_binding=require pour securite max

# Autres secrets :
wrangler pages secret put STRIPE_SECRET_KEY --project-name=gradient-deviens-marrant
wrangler pages secret put STRIPE_WEBHOOK_SECRET --project-name=gradient-deviens-marrant
wrangler pages secret put ANTHROPIC_API_KEY --project-name=gradient-deviens-marrant
wrangler pages secret put NEXTAUTH_SECRET --project-name=gradient-deviens-marrant
```

### 7.5 Driver code change (critique)
```typescript
// avant (lib pg incompatible Workers)
import { Pool } from 'pg'
const pool = new Pool({ connectionString: process.env.DATABASE_URL })

// apres (driver Neon HTTP serverless)
import { neon } from '@neondatabase/serverless'
const sql = neon(process.env.DATABASE_URL!)
const users = await sql`SELECT * FROM users WHERE id = ${userId}`
```

Si Prisma : pas besoin de changer queries, juste activer driver adapter `@prisma/adapter-neon`.

---

## 8. AI Gateway activation (si IA presente — quasi certain Marrant)

Marrant = generation contenu humoristique probable → **forte presence IA**. Activation AI Gateway = **-20-30% facture immediat** sans changer code (cf. rapport @ia S3).

```typescript
// Anthropic
import Anthropic from '@anthropic-ai/sdk'

const ACCOUNT_ID = process.env.CF_ACCOUNT_ID
const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
  baseURL: `https://gateway.ai.cloudflare.com/v1/${ACCOUNT_ID}/marrant-gateway/anthropic`
})

// OpenAI
import OpenAI from 'openai'
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
  baseURL: `https://gateway.ai.cloudflare.com/v1/${ACCOUNT_ID}/marrant-gateway/openai`
})
```

**Setup** : dashboard Cloudflare > AI > AI Gateway > Create > `marrant-gateway`. Active dashboard analytics, cache prompts identiques (gain 20-30%), rate limiting, fallback providers.

**Bonus** : si certains prompts simples (titres, tags, classifications) → migrer vers **Workers AI** (Llama 3.3, Mistral) = 6-10× moins cher pour ces 30% de tokens (cf. rapport @ia S3).

---

## 9. Estimation effort

| Phase | Duree estimee |
|---|---|
| Phase 0 Preparation | 1h |
| Phase 1 Dev env | 2h |
| Phase 2 Code changes | 4-10h **(variable selon pre-audit)** |
| Phase 3 BDD migration | 1-2h |
| Phase 4 Deploy preview + tests E2E | 2h |
| Phase 5 Cutover DNS | 1h |
| **Total** | **11-18h** |

**Si surprises pre-audit** (websockets, lib native lourde, > 1 GB DB) : peut depasser 20h → decision @fullstack escalade.

---

## 10. Criteres validation post-migration

- [ ] URL prod (`deviensmarrant.com` ou autre) repond 200
- [ ] Tous parcours utilisateur testes manuellement (signup, login, achat si Stripe, generation contenu)
- [ ] Suite tests E2E Playwright : 100% pass sur preview ET prod
- [ ] Lighthouse desktop : LCP < 2.5s, CLS < 0.1, INP < 200ms
- [ ] Lighthouse mobile (throttling 4x CPU + 3G) : LCP < 4s
- [ ] Stripe webhook fonctionnel (test endpoint Stripe dashboard)
- [ ] Email transactionnel envoie (signup, confirmation, recap)
- [ ] IA generation fonctionne ET passe par AI Gateway (verifier dashboard CF AI Gateway)
- [ ] Cron jobs (si applicables) declenches au bon moment (verifier logs Workers Cron)
- [ ] Health check `/api/health` retourne 200 + DB OK + IA OK
- [ ] Sentry capture erreurs serveur ET client
- [ ] Backup Neon premier dump effectue + stocke R2
- [ ] Rollback test : bascule DNS retour Replit, downtime mesure (cible < 5 min)
- [ ] Parite metiers : count users, count contents, comparer Replit vs Neon (tolerance 0%)

---

## 11. Risques specifiques + mitigations

| Risque | Probabilite | Impact | Mitigation |
|---|---|---|---|
| Lib native non remplacable detectee tardivement | Moyenne | Haut (blocage migration) | Pre-audit obligatoire section 2.1 |
| Cron jobs critiques rates pendant cutover | Moyenne | Moyen | Liste exhaustive cron J-1, replanifier sur CF apres go-live |
| DB > Free tier Neon (0.5 GB) | Moyenne | Bas (cout +$19/mois) | Mesure pre-audit, plan Neon Launch valide budget |
| Stripe webhooks down pendant migration | Moyenne | Haut (revenu) | Configurer endpoint CF AVANT cutover. Stripe retry auto 3 jours |
| SEO drop si URLs changent | Moyenne | Moyen | Verifier toutes routes, redirects 301 si refactor, monitor GSC 30j |
| Self-fetch 127.0.0.1 casse en prod | Haute | Haut (ecran blanc) | Pre-audit detecte. Refactor en imports directs OU URL publique |
| Cout IA non maitrise post-migration | Faible | Bas | AI Gateway active = monitoring cost natif |
| Cold start Workers > 100ms apres inactivite | Faible | Bas | CF Workers cold start < 5ms (vs Replit 1-3s) — ameliore |
| Backup Replit perdu | Faible | Critique | pg_dump triple : local + Neon backup + R2 |

---

## 12. Contacts / escalade

| Probleme | Tagger |
|---|---|
| Build CF echoue (next-on-pages) | @fullstack |
| Driver Neon erreur connexion / pool | @infrastructure (moi) |
| DNS / cutover / SSL | @infrastructure |
| Lib native incontournable detectee | @fullstack — escalade decision (Replit / Vercel / refactor lourd) |
| Cron jobs migration complexe | @infrastructure |
| Stripe webhooks signature fail | @fullstack + @infrastructure |
| IA generation comportement different post-migration | @ia |
| Performance degradee post-migration | @infrastructure (audit perf + cache) |
| Email non delivrable | @infrastructure (SPF/DKIM/DMARC) |
| Tests E2E fail post-deploy | @qa |

---

**Handoff → Thomas (pre-audit obligatoire) puis @fullstack (validation packages) puis @infrastructure (execution migration)**
- **Pre-requis bloquant** : section 2 pre-audit complete avant Phase 0
- Cible cutover : a planifier apres pre-audit, jamais vendredi, fenetre matinale recommandee
- Apres execution : @reviewer audit URL prod + parite + rollback test J+7
- Suivi 60j : @infrastructure check hebdo Sentry + CF Analytics + Neon usage
