# Avis @fullstack — Migration Replit → GitHub + Cloudflare Pages/Workers + Neon

**Date** : 2026-05-06
**Agent** : @fullstack
**Angle** : développement quotidien (DX, hot-reload, debug, vélocité d'écriture, Stripe, Next.js, multi-env, secrets, migration code)
**Périmètre** : avis technique exclusif sur la stack par défaut futurs projets Gradient. Pas first principles (écarté), pas IA edge (parallèle @ia).

---

## Verdict (1 phrase)

**GO CONDITIONNEL** — DevRefs en pilote sur **Cloudflare Pages + Neon dès J0** est la bonne décision pour un projet greenfield avec Next.js App Router en runtime Node, à condition d'écarter dès le départ l'edge runtime pour les API routes Stripe / NextAuth / IA et de basculer sur Workers Node-mode ou un runtime Node managé tiers (Render, Railway, Vercel) si plus de 3 routes critiques tombent sur des libs Node lourdes.

---

## 1. Hot-reload et debug

`wrangler pages dev` (et son frère `wrangler dev` pour Workers) tourne sur **Miniflare 3** (workerd local), donc on a un edge runtime quasi-iso prod en local. Hot-reload sur les fichiers Pages Functions et les assets Next.js fonctionne (≈300-800 ms après save), mais le mode `next dev` natif reste **plus rapide** (≈100-200 ms) parce qu'il bypass workerd et utilise Turbopack/Webpack en mémoire. **Pattern recommandé** : développer 90% du code avec `next dev` standard sur Node, et basculer sur `npx @cloudflare/next-on-pages && wrangler pages dev .vercel/output/static` uniquement avant un push pour valider la compat edge. Cette boucle "Node d'abord, edge avant push" évite la friction au quotidien.

**Debug breakpoints** : c'est le point faible structurel. Sur Replit, breakpoint dans une route `/api/*` = direct dans l'IDE, ça marche. Sur `wrangler pages dev`, les breakpoints VSCode passent par `--inspect` + Chrome DevTools attaché à workerd : ça fonctionne mais l'expérience est moins fluide (10-15s d'attache, source maps parfois cassées sur les fichiers `.vercel/output/static/_worker.js/*` post-build). En pratique on debug via `console.log` + `wrangler tail` (logs streamés en temps réel depuis prod). Pour les **erreurs lisibles** : Sentry est non négociable côté CF (pas d'équivalent au "Replit logs UI"). `wrangler tail --format pretty` est utilisable mais sans rétention.

**Verdict honnête** : Replit reste meilleur pour le debug interactif "je clique je vois". CF + Sentry est meilleur pour le debug post-mortem en prod (logs structurés, source maps uploadées). Pour Thomas en mode Claude-orchestrated, le second compte plus.

---

## 2. Stripe + webhooks

Workflow concret CF Pages Functions ou Workers :

1. **Réception event** : route `/api/webhooks/stripe` en Pages Function. Le body brut est requis pour la vérif HMAC — utiliser `await request.text()` AVANT toute lecture, ne JAMAIS appeler `request.json()` d'abord. Stripe SDK officiel marche en edge runtime via `Stripe.createSubtleCryptoProvider()` pour la vérif signature (méthode async exposée précisément pour CF Workers depuis v12 du SDK).
2. **Vérif signature** : `await stripe.webhooks.constructEventAsync(body, sig, secret, undefined, cryptoProvider)` — la version `Async` est obligatoire en edge (la version sync utilise Node crypto qui n'existe pas en workerd).
3. **Test local** : `stripe listen --forward-to localhost:8788/api/webhooks/stripe` (8788 = port par défaut wrangler pages dev). Identique à la DX Replit/Next, zéro friction.
4. **Cold start** : 5-50 ms typique sur Workers/Pages Functions (vs 100-300 ms première hit Replit autoscale après idle). **Avantage CF**. Aucun timeout 30s à craindre côté webhook (durée < 1s typique).

**Risque réel** : si le webhook déclenche une **action longue** (génération PDF, email avec RAG, batch IA), il faut découper. Pattern obligatoire : webhook reçoit → enqueue dans une **CF Queue** ou directement déclenche un **Worker dédié** via `env.QUEUE.send()` ou `fetch(workerURL)` → réponse 200 immédiate à Stripe. Sur Replit on s'en sortait avec `await` direct (proc Node persistant), sur CF on doit penser **fan-out** systématique. C'est un changement de mindset, pas un blocage.

**Comparaison Replit** : Replit était plus tolérant (Node persistant, on pouvait tout faire dans la route webhook). CF force le bon pattern (queue + worker dédié). Long terme = mieux. Court terme = 1 jour d'apprentissage par dev.

---

## 3. Next.js App Router sur CF Pages — le point dur

**Compatibilité réelle via `@cloudflare/next-on-pages` (v1.13+ au 2026-05)** :

| Feature Next.js | Status CF Pages | Workaround |
|---|---|---|
| App Router (layouts, pages, loading, error) | OK | — |
| Server Components | OK (edge runtime forcé) | — |
| Server Actions | OK depuis next-on-pages v1.10 | — |
| Route Handlers (`route.ts`) | OK **en edge runtime uniquement** | `export const runtime = 'edge'` obligatoire sur CHAQUE route |
| Middleware | OK | — |
| ISR (`revalidate: 3600`) | **Limité** : revalidation par tag/path OK mais le cache est **par data-center** (pas global). Pas de SSG hybride classique. | Utiliser CF Cache API + KV pour cache global, ou repasser sur Vercel pour ISR critique |
| `next/image` optimization | **Cassé** par défaut (sharp = Node-only) | Utiliser `loader: 'custom'` + Cloudflare Images ($5/mois) OU `unoptimized: true` + R2 |
| `fetch()` cache Next | OK partiel (in-memory request scope, pas persistant cross-request) | Acceptable pour la plupart des cas |
| Libs Node lourdes (sharp, puppeteer, canvas) | **Cassé** en edge | Browser Rendering API (Workers) pour puppeteer, R2 + Image Resizing pour sharp, écarter canvas serveur |
| `bcrypt` | **Cassé** (binding natif) | `bcryptjs` (pure JS, ~3x plus lent mais OK pour auth) |
| `jsonwebtoken` | **Cassé** (Node crypto) | `jose` (compatible WebCrypto, recommandé NextAuth v5) |
| `pg` (driver Postgres TCP) | **Cassé** (TCP non supporté en workerd) | `@neondatabase/serverless` (HTTP/WS driver) — seule option viable |
| Prisma | OK depuis v5.11 avec driver adapter Neon, MAIS bundle size +300 KB | Drizzle recommandé pour edge (50 KB, perf comparable) |
| `nodejs_compat` flag | Disponible (CF 2024+) | Ajouter `compatibility_flags = ["nodejs_compat"]` dans `wrangler.toml` règle 95% des cas Stripe SDK / OpenAI SDK |

**Cas critique : `nodejs_compat` ne couvre PAS les bindings natifs** (sharp, bcrypt, canvas, puppeteer, better-sqlite3). Pour ces cas, deux issues :
- **Option A** : repasser le projet entier sur **Vercel** (Next.js natif Node, mais on perd l'argument coût face à Replit) ou **Render** (Node managé classique ~$7/mois).
- **Option B** : isoler les routes incompatibles dans un **Worker séparé** en mode Node (CF Workers avec `nodejs_compat` + binding natif via WebAssembly recompile, complexe et fragile).

**Recommandation** : pour Gradient, **toujours commencer par Vercel comme plan B mental**. Si un projet a 3+ routes Node incompatibles, c'est plus rentable de mettre tout sur Vercel + Neon (et garder R2 + CF DNS uniquement) que de tordre l'app pour CF Pages. Sur DevRefs (greenfield) on choisit edge-first depuis J0 — pas de migration de libs Node legacy.

---

## 4. Multi-env (dev / preview / prod)

**Vrai gain CF Pages vs Replit** : c'est probablement le delta DX le plus important après le pricing.

- **Replit aujourd'hui** : 1 Repl = 1 env. Pour avoir un staging il faut un second Repl, dupliquer les Secrets, dupliquer la DB. Pour tester une PR = bricolage avec une branche checkoutée localement.
- **CF Pages + GitHub** : chaque PR ouvre automatiquement un **preview deploy** sur `<sha>.<projet>.pages.dev` avec un build complet, les env vars de preview, et son own URL. **Gratuit, illimité**.

Couplé à **Neon database branching** (1 commande `neonctl branches create --parent main --name pr-123`), on obtient un **environnement isolé complet par PR** : code + DB. C'est un game changer pour QA et @reviewer : ils peuvent tester chaque PR sur une URL réelle avec une DB peuplée, sans toucher à prod.

**Workflow standard** :
- `main` → prod (`devrefs.fr`)
- toute autre branche → preview auto (`<branch>.devrefs.pages.dev`) + Neon branch dédiée
- env vars CF Pages : 2 environnements (`production`, `preview`) configurables via `wrangler pages secret put --env preview`

**Caveat** : la **création automatique de branches Neon par PR** n'est pas native — il faut une GitHub Action `.github/workflows/preview-db.yml` qui appelle l'API Neon. ~30 lignes de YAML, à mettre dans le template Gradient une fois pour toutes.

**Verdict** : Replit perd net ici. Le multi-env gratuit par PR est inégalable.

---

## 5. Secrets management

**Pattern CF** :
- **Production** : `wrangler pages secret put DATABASE_URL --project-name devrefs` (interactif, jamais en clair). Stockage CF chiffré, accessible via `env.DATABASE_URL` dans les Functions/Workers.
- **Preview** : même commande avec `--env preview`.
- **Dev local** : fichier `.dev.vars` à la racine (format `KEY=value`, **gitignoré**). Lu automatiquement par `wrangler pages dev`. **PAS de `.env`** côté CF — c'est `.dev.vars` qui est le standard.

**Conformité préférence Thomas** ("DATABASE_URL en Replit Secrets uniquement, jamais .env") : la préférence est respectée par construction côté **production CF** (secrets dans le dashboard CF, pas dans le repo, pas dans `.env`). Côté **dev local**, `.dev.vars` est l'équivalent de `.env` mais **uniquement local**, jamais commit, jamais en prod. C'est conforme à l'esprit de la préférence (la prod n'a pas accès à un fichier env). À documenter dans `_base-agent-protocol.md` : ajouter `.dev.vars` à `.gitignore` global, et expliciter que c'est un fichier dev-only.

**DX vs Replit Secrets UI** : Replit gagne sur le "je clique je tape c'est sauvé". `wrangler secret put` demande un terminal, mais c'est scriptable et automatisable par Claude (token CF API). À 7 projets, c'est du temps gagné.

**Anti-pattern à bloquer** : ne PAS mettre les secrets dans `wrangler.toml` même sous `[vars]` — ces vars sont commitées. Toujours `wrangler secret put` pour tout ce qui est sensible.

---

## 6. Migration code projet par projet — checklist concrète

Au-delà de pg_dump/pg_restore (déjà couvert par @infrastructure), voici les modifs **code** d'un projet Next.js Replit pour qu'il déploie sur CF Pages + Neon. Ordre d'exécution recommandé.

### 6.1 Dépendances

```bash
pnpm add @cloudflare/next-on-pages
pnpm add -D wrangler@latest
pnpm remove bcrypt jsonwebtoken pg @prisma/client  # à remplacer
pnpm add bcryptjs jose @neondatabase/serverless drizzle-orm  # equivalents edge
# Si on garde Prisma : pnpm add @prisma/adapter-neon @neondatabase/serverless
```

### 6.2 Fichiers à créer

- `wrangler.toml` (cf snippet section 8)
- `.dev.vars` (gitignoré, dev local)
- `.github/workflows/deploy.yml` (build + deploy CF Pages)
- `.github/workflows/preview-db.yml` (création branche Neon par PR)
- `src/lib/db.ts` adapté pour driver `@neondatabase/serverless`

### 6.3 Code à modifier

| Pattern Replit | Pattern CF Pages |
|---|---|
| `process.env.PORT` (auto-injecté Replit) | Supprimer, CF n'utilise pas PORT |
| `fetch('http://127.0.0.1:${PORT}/api/...')` self-fetch | **Réécrire en appel direct de fonction** (import et await), PAS de self-fetch sur CF (pas de localhost workerd interne fiable cross-route en preview deploy) |
| Long jobs en route API (`await heavyTask()` puis `NextResponse.json()`) | Déporter vers CF Queue + Worker consumer, route renvoie 202 Accepted |
| `import sharp from 'sharp'` (image processing) | Supprimer, utiliser CF Image Resizing ou next/image avec loader Cloudflare |
| `import bcrypt from 'bcrypt'` | Remplacer par `bcryptjs` (1-line API compat) |
| `import jwt from 'jsonwebtoken'` | Remplacer par `jose` (`jwtVerify`, `SignJWT`) — NextAuth v5 utilise `jose` nativement |
| Storage local (`fs.writeFile`) | Déjà interdit côté Replit autoscale — confirmer R2 partout |
| `prisma migrate deploy` au boot | Déplacer dans CI (GitHub Action pre-deploy) — pas de "boot" sur edge |
| `export const runtime = 'nodejs'` | Remplacer par `export const runtime = 'edge'` sur chaque route |
| Logs `console.log` espérant Replit logs | Ajouter Sentry SDK, garder console.log secondaires |

### 6.4 Self-fetch — point critique pour les agents

La règle actuelle de l'agent fullstack ("self-fetch via 127.0.0.1:${PORT}") est **invalide sur CF**. À reformuler dans la doc agent post-migration :

> Sur CF Pages : pas de self-fetch HTTP. Les API routes appelées depuis un Server Component doivent être **importées et appelées directement** (`import { handler } from '@/app/api/foo/route'; await handler(req)`), ou la logique doit être extraite dans une fonction lib (`src/lib/foo.ts`) appelée des deux côtés. Pour les jobs longs, utiliser CF Queue + Worker dédié.

C'est une mise à jour à faire dans `fullstack.md` post-validation pilote DevRefs (pas dans cette session).

### 6.5 Validation post-migration

```bash
npx @cloudflare/next-on-pages  # build local
npx wrangler pages dev .vercel/output/static  # serve local edge
# Tester : auth, CRUD, Stripe webhook (stripe listen), upload, email
npm run build && next-on-pages  # build CI
```

### 6.6 Estimation effort code par projet

| Profil projet | Heures |
|---|---|
| Greenfield (DevRefs) | 0h migration, 4h setup template |
| Vitrine légère (ISSA Capital) | 2-4h |
| App standard avec Stripe + Auth + DB (Sarani, Mandataire-Immo) | 6-10h |
| App avec sharp / puppeteer / scraping (ImmoCrew si applicable) | 12-20h **OU bascule Vercel** |
| Versiroom (peur persistance Thomas) | 8-12h + audit migration data ultra-strict |

---

## 7. Verdict GO/NO-GO DevRefs J0

**GO** — DevRefs commence sur CF Pages + Neon dès J0. Trois raisons :

1. **Greenfield = zéro dette legacy Replit**. Pas de `process.env.PORT`, pas de `pg`, pas de `bcrypt` à migrer. On part propre.
2. **Multi-env par PR + DB branching** = saut qualitatif QA/reviewer immédiat, applicable à tous les futurs projets.
3. **Coûts Replit "très élevés" côté Thomas** : aucun argument à garder Replit pour un projet qui n'a pas encore de users.

### Top 3 pièges à anticiper (par ordre de probabilité)

1. **Lib Node "qu'on n'avait pas vu venir"** — au moment d'intégrer une feature (PDF generation, image manipulation, scraping), on tombera sur une lib avec binding natif. Anticipation : pour chaque nouvelle feature DevRefs, **lister les libs candidates AVANT install** et vérifier compat edge sur https://workers.cloudflare.com/works ou en testant `wrangler pages dev`. Mitigation prévue : Browser Rendering API CF (puppeteer-as-a-service), CF Image Resizing (sharp), parsing PDF côté client si possible.
2. **NextAuth v5 + Neon + edge** — la combo fonctionne mais le tuning du `session strategy: 'jwt'` (pas `'database'` pour éviter les writes DB sur chaque hit) et la config du `trustHost: true` sur preview deploys (URLs *.pages.dev varient) sont des mines. Prévoir 2-3h de setup auth dédiées sur le pilote, documenter dans `dev-decisions.md` comme template Gradient.
3. **`next-on-pages` build occasionnellement cassé sur upgrade Next.js mineur** — l'adapter est maintenu par CF mais avec lag sur les nouveaux features Next. Pinner Next.js et `next-on-pages` à des versions exactes (pas de `^`), upgrader manuellement avec test, et **ne pas faire `next dev` et `wrangler pages dev` en environnements de versions différentes**.

### Quand ce serait NO-GO

- Si DevRefs avait besoin de **puppeteer pour scraper** (non, il génère des refs basées sur des données saisies/IA).
- Si NextAuth.js v5 ne marchait pas en edge (test pilote), il faudrait soit Auth.js + driver Neon (probable OK), soit basculer sur Lucia, soit fallback Vercel.
- Si la peur persistance Thomas se transposait sur Neon (cold start data loss perçu) : à l'usage, vérifier qu'un keep-alive cron règle 100% du symptôme.

---

## 8. Snippet `wrangler.toml` minimal pour DevRefs (si GO)

```toml
name = "gradient-devrefs"
compatibility_date = "2026-04-01"
compatibility_flags = ["nodejs_compat"]
pages_build_output_dir = ".vercel/output/static"

[vars]
NODE_ENV = "production"
NEXT_PUBLIC_APP_URL = "https://devrefs.fr"

# Secrets (à set via : wrangler pages secret put <KEY> --project-name gradient-devrefs)
# - DATABASE_URL (Neon HTTP connection string)
# - NEXTAUTH_SECRET
# - NEXTAUTH_URL (auto-géré sur preview via trustHost)
# - STRIPE_SECRET_KEY
# - STRIPE_WEBHOOK_SECRET
# - RESEND_API_KEY
# - OPENAI_API_KEY (ou ANTHROPIC_API_KEY)
# - SENTRY_DSN

[[r2_buckets]]
binding = "BUCKET"
bucket_name = "gradient-devrefs-uploads"
preview_bucket_name = "gradient-devrefs-uploads-preview"

[[kv_namespaces]]
binding = "CACHE"
id = "<production-id>"
preview_id = "<preview-id>"

[[queues.producers]]
queue = "devrefs-jobs"
binding = "JOBS"

[[queues.consumers]]
queue = "devrefs-jobs"
max_batch_size = 10
max_batch_timeout = 30

[env.preview]
vars = { NODE_ENV = "preview", NEXT_PUBLIC_APP_URL = "https://preview.devrefs.fr" }

# Cron triggers (keep-alive Neon + jobs récurrents)
[triggers]
crons = ["*/5 * * * *"]  # ping Neon toutes les 5 min pour éviter scale-to-zero pénalisant
```

`.gitignore` complément :
```
.dev.vars
.vercel/
.wrangler/
```

---

## 9. Stack code recommandée — packages edge-compatibles

| Catégorie | Package recommandé | Raison |
|---|---|---|
| ORM | **Drizzle** (`drizzle-orm` + `drizzle-orm/neon-http`) | Edge-natif, 50 KB, pas de build step, types directs. **Prisma reste OK** avec adapter Neon mais bundle 300 KB+. Drizzle est le défaut futurs projets, Prisma autorisé sur projets existants. |
| Driver Postgres | `@neondatabase/serverless` | Le SEUL driver compatible Workers (HTTP/WS, pas TCP). |
| Auth | **NextAuth.js v5** (`next-auth@beta`) | Compat edge native depuis v5, utilise `jose` (pas jsonwebtoken). Conforme préférence Thomas (gratuit, ownership total). Provider DB via Drizzle adapter. |
| Hash password | `bcryptjs` | Pure JS, edge-compatible. ~3x plus lent que bcrypt mais imperceptible sur auth occasionnel. |
| JWT | `jose` | WebCrypto natif. Déjà dépendance NextAuth v5 — pas d'ajout. |
| Stripe | `stripe@latest` avec `Stripe.createSubtleCryptoProvider()` | SDK officiel, mode async pour edge. |
| OpenAI / Anthropic | SDK officiels (compat edge documentée) | OK avec `nodejs_compat`. |
| Email | **Resend** (`resend`) | API HTTP, edge-compat. React Email pour templates. |
| Upload | **R2** via binding (`env.BUCKET.put()`) | Zero egress fee, sécurité par binding. UploadThing reste OK mais coût cumulé. |
| Image optimization | **Cloudflare Images** ($5/mois flat) ou `next/image unoptimized: true` + R2 | Sharp interdit edge. CF Images = simple, prédictible. |
| Validation | `zod` | Edge-compat, déjà standard Gradient. |
| Forms | `react-hook-form` + `@hookform/resolvers/zod` | Client-side, pas d'enjeu edge. |
| Rate limiting | `@upstash/ratelimit` + `@upstash/redis` | API HTTP, edge-compat. CF KV alternative free pour cas simples. |
| Logging / Monitoring | **Sentry** (`@sentry/nextjs`) + `wrangler tail` | Sentry pour erreurs structurées, tail pour debug live. |
| Tests E2E | `playwright` | Pas d'enjeu edge (tourne en CI Node). |
| Tests unitaires | `vitest` | Idem. |
| Cron | CF Cron Triggers (déclaré dans `wrangler.toml`) | Natif. |
| Queues | CF Queues (binding) | Natif, gratuit jusqu'à 1M op/mois. |

**Packages à éviter / interdire post-migration** :
- `bcrypt` (binding natif) → `bcryptjs`
- `jsonwebtoken` → `jose`
- `pg` (TCP) → `@neondatabase/serverless`
- `sharp` côté serveur → CF Images
- `puppeteer` / `playwright` côté serveur → CF Browser Rendering API
- `node-fetch` → `fetch` global (déjà dispo)
- `aws-sdk` (massif, pas edge-friendly) → `@aws-sdk/client-s3` v3 (modulaire) ou direct R2 binding

---

## 10. Ce que Replit garde de meilleur (honnêteté technique)

Pour ne pas être cargo-cult, voici les 4 cas où Replit reste préférable au moment d'écrire (2026-05-06) :

1. **POC instantané "je veux voir un Next.js qui tourne dans 30 secondes"** — Replit Templates + run = imbattable. Sur CF il faut au minimum : créer repo, init Next, install next-on-pages, push, configurer Pages dans le dashboard. ~10-15 min même bien rodé.
2. **App qui exige une lib Node native non-portable** (puppeteer custom build, ffmpeg-static, librairie scientifique) — sur Replit c'est juste `npm install` et ça marche. Sur CF c'est une recherche d'alternative ou un fallback.
3. **Dev sur tablette / Chromebook / sans environnement local** — Replit IDE web > VSCode local + wrangler. Pour Thomas qui code souvent sur Mac, non-bloquant.
4. **Long-running processes en mémoire** (worker IA qui garde un modèle local en RAM, websocket persistant) — incompatible CF Workers (stateless, 128 MB, durée bornée). Remède : Durable Objects ou un serveur dédié. Pour Gradient aujourd'hui, aucun projet n'en a besoin.

Aucun de ces cas n'est un blocage pour DevRefs ni pour les 6 autres projets actuels. **Verdict honnête : la migration est la bonne décision pour Gradient v2026.**

---

## Handoff → @orchestrator

**Fichiers produits** :
- `/home/user/Agent-Team/docs/reviews/fullstack-replit-vs-cloudflare-dx-2026-05-06.md`

**Verdict net** : **GO CONDITIONNEL** — DevRefs J0 sur CF Pages + Neon. Conditions : (1) accepter edge runtime sur toutes les routes, (2) écarter dès le départ libs Node natives non-portables, (3) avoir Vercel comme plan B mental documenté pour les 1-2 projets futurs où une lib Node lourde s'avérerait critique.

**Décisions techniques prises** :
- Drizzle ORM = défaut futurs projets (Prisma autorisé sur projets existants)
- NextAuth v5 + jose + bcryptjs = stack auth edge-compat (conforme préférence Thomas)
- `@neondatabase/serverless` = driver unique Postgres edge
- `.dev.vars` = pattern secrets local CF (jamais commit, jamais en prod)
- CF Queues + Worker consumer = pattern obligatoire pour jobs longs déclenchés par webhook
- `next-on-pages` v1.13+ avec `compatibility_flags = ["nodejs_compat"]` dans wrangler.toml

**Points d'attention prioritaires** :
- Self-fetch `127.0.0.1:${PORT}` à supprimer du pattern @fullstack post-migration (à mettre à jour dans `fullstack.md` après validation pilote, PAS dans cette session)
- NextAuth v5 + preview deploys = config `trustHost: true` + URL dynamique à valider tôt sur DevRefs
- `next-on-pages` à pinner (pas de `^`)
- Keep-alive cron 5 min sur Neon obligatoire pour UX (sinon cold start 300-500 ms)
- Image optimization = décision CF Images ($5/mois) vs `unoptimized: true` à arbitrer projet par projet
- Stripe webhook = pattern Queue obligatoire pour jobs > 1s

**Pas de chevauchement avec @ia** : ma section 9 mentionne OpenAI/Anthropic SDK mais ne traite pas Workers AI, x402, RAG vectoriel ni pgvector — angle @ia.

**Pas de chevauchement avec @infrastructure** : pas de redite sur Neon vs D1 vs Supabase, pricing, plan migration phasé, blast radius tokens. Mon angle = code, DX, packages, patterns dev.

**Actions Replit requises** : aucune dans cette session (livrable strictement consultatif, lecture seule). Dès validation Thomas + lancement pilote DevRefs, créer une todo dans `REPLIT_ACTIONS.md` du projet DevRefs pour : exporter Replit Secrets DevRefs s'il y en a (sinon skip), figer le Repl si déjà créé.

**Pre-commit check** : N/A (pas de code dans `src/` cette session, uniquement doc dans `docs/reviews/`).

**Agent suivant à invoquer** :
- **@orchestrator** pour synthétiser les 3 avis (@infrastructure, @ia parallèle, @fullstack ici) et présenter à Thomas une décision unifiée GO/NO-GO + plan d'action DevRefs J0.
- **@fullstack** (moi-même) sera réinvoqué post-validation pilote DevRefs pour : (a) implémenter le template GitHub + CF Pages + Neon, (b) mettre à jour `fullstack.md` (BDD section, self-fetch, packages edge-compat) en mode net-zero rule conservation.

---

*Avis produit par @fullstack le 2026-05-06. Source de vérité : documentation Cloudflare Pages / Workers 2026-04, `@cloudflare/next-on-pages` v1.13, NextAuth v5, Drizzle ORM, expérience cross-projets Gradient (Sarani, Mandataire-Immo, Archi, ImmoCrew).*
