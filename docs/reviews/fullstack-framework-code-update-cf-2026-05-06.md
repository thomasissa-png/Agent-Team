# Audit framework — patterns/snippets code à mettre à jour pour stack CF + Neon (2026-05-06)

**Auteur** : @fullstack
**Mission** : audit côté CODE des patterns Replit-only dans le framework Gradient Agents pour la stack par défaut **GitHub + Cloudflare Pages/Workers + Neon Postgres** (décision Thomas S3).
**Périmètre** : `.claude/agents/`, `docs/`, `index.html`. Lecture seule. Patches recommandés à appliquer par @infrastructure.
**Coordination** : @infrastructure traite l'angle infra/déploiement/agents config + fiches migration ISSA/Marrant. Ce rapport apporte les snippets de code prêts à coller.

---

## 1. Verdict synthétique

**Hits trouvés (hors fichiers reviews S3 et migrations ISSA/Marrant déjà CF-aware)** :
- **P0 (pièges qui CASSENT sur CF)** : **5 hits** — tous concernent le pattern self-fetch `127.0.0.1:${PORT}` propagé dans `fullstack.md`, `infrastructure.md`, `index.html` (×4) et la règle de migration auto Prisma au boot. Sur CF Workers/Pages, il n'y a PAS de port local accessible cross-route, et il n'y a PAS de "boot" pour exécuter un `migrate deploy`. Un agent qui suit ces règles sur un nouveau projet CF produira du code qui crashera au premier appel.
- **P1 (patterns obsolètes par défaut, pas bloquants si projet legacy)** : **9 hits** — Prisma comme défaut (`fullstack.md`, `qa.md`, `index.html` ×6) sans mention de Drizzle comme défaut futurs projets ; `lib/prisma.ts` en exemple structure ; "PostgreSQL Replit" comme défaut implicite dans plusieurs prompts `index.html`.
- **P2 (enrichissements nice-to-have, pas de risque immédiat)** : **6 hits** — règle `bcrypt/argon2` (sans mention bcryptjs edge-friendly), `sharp + svg2png` favicon-checklist, références `REPLIT_ACTIONS.md` sans équivalent `CF_ACTIONS.md` documenté.

**Angles morts critiques** (manquent totalement du framework côté snippets de référence) :
1. `wrangler.toml` standard pour un Next.js sur CF Pages
2. `.github/workflows/deploy.yml` pour push GH → CF Pages
3. Pattern Drizzle + `@neondatabase/serverless` (client edge)
4. Pattern NextAuth v5 edge-compatible (`trustHost`, `session: { strategy: "jwt" }`, `useSecureCookies`)
5. Pattern Stripe webhook edge (`constructEventAsync` + `Stripe.createSubtleCryptoProvider()`)
6. Pattern AI Gateway Cloudflare (1 ligne base URL pour Anthropic/OpenAI)
7. Pattern R2 upload via binding (`env.R2.put(...)`, pas SDK S3)
8. Pattern CF Images (URL `/cdn-cgi/image/` ou loader Next custom)
9. Pattern `ctx.waitUntil(...)` comme remplacement légitime du fire-and-forget interdit côté Replit
10. Self-fetch CF : "appel direct de fonction extraite dans `src/lib/`" (pas HTTP)

**Effort total estimé pour @infrastructure** :
- Patches P0 : **~1h** (5 sections à éditer dans 3 fichiers + index.html)
- Patches P1 : **~1h30** (réordonner Drizzle vs Prisma, marquer Prisma "legacy autorisé", ajouter bloc "stack défaut futurs projets")
- Ajout des 10 snippets de référence (angles morts) : **~2h** (à insérer dans `infrastructure.md` ou créer un `docs/snippets/cloudflare/` selon préférence)
- Total : **~4h30** dans une session @infrastructure

---

## 2. Tableau des hits Grep

| Fichier | Ligne | Pattern détecté | Classification | Priorité |
|---|---|---|---|---|
| `.claude/agents/fullstack.md` | 158-168 | Bloc complet "Self-fetch Next.js (obligatoire)" avec snippet `http://127.0.0.1:${PORT}` | **À enrichir** : conserver pour Replit legacy + ajouter section "Sur Cloudflare Workers/Pages : pas de self-fetch HTTP, extraire la logique en `src/lib/` et appeler la fonction des deux côtés" | **P0** |
| `.claude/agents/infrastructure.md` | 81 | "Self-fetch Next.js : DOIT utiliser http://127.0.0.1:${PORT}" sans nuance CF | **À enrichir** : ajouter "Sur CF : pas applicable, voir pattern lib partagée" | **P0** |
| `.claude/agents/infrastructure.md` | 76 | "Le script npm start DOIT exécuter `prisma migrate deploy` AVANT de lancer le serveur" — formulé comme règle absolue | **À enrichir** : marquer "Replit legacy uniquement". Sur CF : migrations en GitHub Action pre-deploy, pas au boot (pas de boot) | **P0** |
| `.claude/agents/fullstack.md` | 44 | "Cloudflare D1 ou Neon Postgres + Drizzle ORM (recommandé edge) ou Prisma ORM" — Prisma encore mis sur le même plan que Drizzle pour edge | **À enrichir** : Drizzle = défaut futurs projets, Prisma = autorisé sur projets existants ou si feature spécifique justifie le bundle 300KB | **P1** |
| `.claude/agents/fullstack.md` | 89 | Exemple structure : `lib/  ← Utilitaires, clients (prisma.ts, stripe.ts)` | **À enrichir** : `(db.ts, stripe.ts)` neutre — `db.ts` est l'export Drizzle ou Prisma selon projet (R1 déjà identifié dans post-modifications-review.md) | **P1** |
| `.claude/agents/qa.md` | 27 | "Mocking : PostgreSQL (Prisma)" | **À enrichir** : "PostgreSQL (Drizzle ou Prisma selon projet)" | **P1** |
| `.claude/agents/qa.md` | 70-72 | "### Tests de base de données (PostgreSQL/Prisma) — `prisma migrate reset`" | **À enrichir** : ajouter cas Drizzle (`drizzle-kit push`, snapshots) | **P1** |
| `.claude/agents/qa.md` | 105 | "tester les raw queries Prisma" | **À enrichir** : "raw queries Prisma OU `db.execute(sql\`...\`)` Drizzle" | **P2** |
| `index.html` | 670, 1548, 1630, 1701, 2004, 3068 | Règles "self-fetch 127.0.0.1:PORT" en 6 endroits dans les prompts utilisateur | **À enrichir** : ajouter mention "Sur CF : pas de self-fetch HTTP, refactorer en lib partagée" | **P0** |
| `index.html` | 1641, 1689, 1710, 1711, 1720, 1964 | Prompts qui mentionnent `.replit`, `replit.nix`, "DATABASE_URL Replit Secrets", "prisma migrate deploy au boot" comme défauts | **À enrichir** : transformer en "Selon hébergeur (Cloudflare Pages/Workers OU Replit legacy) : ..." | **P1** |
| `index.html` | 1687, 1690, 1692 | Prompt schema BDD : "PostgreSQL Replit", "prisma migrate deploy", "Client Prisma" | **À enrichir** : "PostgreSQL (Neon serverless défaut futurs projets, Replit legacy)", "migrations CI sur CF / migrate deploy au boot sur Replit", "Client Drizzle ou Prisma" | **P1** |
| `index.html` | 1800 | "stocker les backups HORS de Replit (S3, R2)" | **À enrichir** : "HORS de l'hébergeur (R2 par défaut)" — ne pas mentionner Replit comme référence | **P2** |
| `index.html` | 3117 | "hash bcrypt/argon2" sans mention bcryptjs (compat WebCrypto/edge) | **À enrichir** : "bcryptjs (edge-compatible) ou argon2-browser" | **P2** |
| `docs/checklists/favicon-checklist.md` | 84 | "sharp + svg2png (Node.js)" comme suggestion outil | **À enrichir** : noter "incompatible CF Workers — utiliser realfavicongenerator.net (recommandé) ou sharp en local pre-commit, jamais en runtime serverless" | **P2** |
| `.claude/agents/fullstack.md` | 149 | "Replit autoscale : zéro fire-and-forget — tout save critique doit être await avant NextResponse.json()" | **À enrichir** : la règle reste valable côté CF Workers (worker tué à la fin de la response handler), MAIS CF offre `ctx.waitUntil(promise)` qui prolonge l'exécution post-response — pattern légitime à documenter | **P1** |
| `.claude/agents/_base-agent-protocol.md` | 412 | Checklist post-livrable : "Changement .replit/replit.nix : [description]" | **À enrichir** : ajouter ligne "Changement wrangler.toml / .github/workflows : [description]" | **P2** |
| `.claude/agents/agent-factory.md` | 30 | aucun hit critique | **Conserver** | — |
| `docs/migrations/issa-capital-migration.md` | toutes lignes | Fiche migration ISSA — déjà CF-aware | **Conserver** (scope @infrastructure) | — |
| `docs/reviews/*-2026-05-06.md` | — | Rapports S3 déjà CF-aware | **Conserver** | — |
| `docs/lessons-learned.md` | 63 | Ligne historique "self-fetch 127.0.0.1" | **Conserver** (historique) — pas un pattern obligatoire | — |

---

## 3. Patches "à remplacer" P0 (avant/après code)

### Patch P0.1 — `.claude/agents/fullstack.md` ligne 156-168 (section Self-fetch)

**Avant** :
```markdown
### Self-fetch Next.js (obligatoire)

Tout appel HTTP interne (API route appelée depuis un Server Component ou un autre endpoint du même projet) DOIT utiliser `http://127.0.0.1:${PORT}`, JAMAIS l'URL publique du projet. Les reverse proxies (Replit, Vercel, Cloudflare) ont des timeouts (30-60s) incompatibles avec les requêtes longues (génération IA, batch processing). Le proxy coupe la connexion → `response.json()` crash sur du HTML d'erreur.

Pattern :
```typescript
const PORT = process.env.PORT || 3000;
const res = await fetch(`http://127.0.0.1:${PORT}/api/my-endpoint`, {
  signal: AbortSignal.timeout(600_000),
});
const text = await res.text();
const data = JSON.parse(text);
```
```

**Après** :
```markdown
### Self-fetch Next.js (obligatoire — règle dépendante de l'hébergeur)

**Règle absolue commune** : ne JAMAIS appeler l'URL publique du projet depuis un Server Component ou une autre API route. Les reverse proxies (Replit, Vercel, Cloudflare) ont des timeouts (30-60s) qui coupent les requêtes longues (génération IA, batch). Le proxy coupe → `response.json()` crash sur du HTML d'erreur.

**Pattern selon hébergeur** :

**Sur Cloudflare Pages/Workers (défaut futurs projets S3 2026-05-06)** : pas de self-fetch HTTP du tout. Pas de port local accessible cross-route en preview/prod. Extraire la logique métier dans `src/lib/[feature].ts` et l'appeler directement depuis les deux côtés (Server Component ET API route handler).

```typescript
// src/lib/generate-content.ts
export async function generateContent(input: Input): Promise<Output> {
  // logique métier complète ici
}

// src/app/api/generate/route.ts
import { generateContent } from "@/lib/generate-content";
export async function POST(req: Request) {
  const data = await generateContent(await req.json());
  return Response.json(data);
}

// src/app/page.tsx (Server Component)
import { generateContent } from "@/lib/generate-content";
export default async function Page() {
  const data = await generateContent({ ... }); // appel direct, pas HTTP
  return <View data={data} />;
}
```

Pour les jobs longs (>30s) côté CF : utiliser **Cloudflare Queues** (worker dédié consommateur) ou **Durable Objects** (pas de self-fetch, message-passing).

**Sur Replit (legacy)** : pattern self-fetch `http://127.0.0.1:${PORT}` reste valide.

```typescript
const PORT = process.env.PORT || 3000;
const res = await fetch(`http://127.0.0.1:${PORT}/api/my-endpoint`, {
  signal: AbortSignal.timeout(600_000),
});
const text = await res.text();
const data = JSON.parse(text); // fallback safe vs res.json() direct
```
```

### Patch P0.2 — `.claude/agents/infrastructure.md` ligne 81

**Avant** :
> **Self-fetch Next.js** : tout appel HTTP interne DOIT utiliser `http://127.0.0.1:${PORT}`, JAMAIS l'URL publique. Les reverse proxies Replit ont un timeout de 30-60s

**Après** :
> **Self-fetch Next.js** : règle dépendante de l'hébergeur. Sur **Cloudflare** : pas de self-fetch HTTP (pas de port local cross-route) — extraire la logique en `src/lib/` et appeler directement la fonction des deux côtés. Voir snippet dans `fullstack.md` section Self-fetch. Pour jobs >30s : Cloudflare Queues. Sur **Replit (legacy)** : `http://127.0.0.1:${PORT}` obligatoire (les reverse proxies ont un timeout 30-60s qui coupe les requêtes longues).

### Patch P0.3 — `.claude/agents/infrastructure.md` ligne 76 (`prisma migrate deploy` au boot)

**Avant** :
> Le script npm start DOIT exécuter `prisma migrate deploy` AVANT de lancer le serveur (recréation auto des tables si DB réinitialisée)

**Après** :
> **Sur Replit (legacy)** : le script `npm start` DOIT exécuter `prisma migrate deploy` AVANT de lancer le serveur (recréation auto si DB réinitialisée — protection persistance Replit).
> **Sur Cloudflare (défaut futurs projets)** : pas de "boot" — les Pages Functions sont stateless. Migrations exécutées en **GitHub Action pre-deploy** :
> ```yaml
> - name: Apply DB migrations
>   run: pnpm drizzle-kit migrate  # ou: pnpm prisma migrate deploy
>   env:
>     DATABASE_URL: ${{ secrets.NEON_DATABASE_URL }}
> ```
> La migration tourne 1× par push, pas à chaque cold start. Si Neon avec branching : créer branche DB par PR pour preview deploys.

### Patch P0.4 — `index.html` (6 occurrences self-fetch — lignes 670, 1548, 1630, 1701, 2004, 3068)

Ajouter en regard de chaque mention "127.0.0.1:PORT" : `(Replit) ou appel direct fonction lib (Cloudflare — défaut futurs projets)`.

Exemple ligne 670 :
- Avant : `Self-fetch Next.js : JAMAIS l'URL publique, toujours 127.0.0.1:PORT.`
- Après : `Self-fetch Next.js : JAMAIS l'URL publique. Sur Cloudflare (défaut futurs projets) : extraire la logique en src/lib/ et appeler directement. Sur Replit (legacy) : 127.0.0.1:PORT.`

### Patch P0.5 — `index.html` lignes 1687-1692 (prompt schema BDD)

**Avant** (extraits) :
- L1687 : "Schéma de base de données (PostgreSQL Replit)"
- L1690 : "le script npm start doit exécuter les migrations Prisma (prisma migrate deploy)"
- L1692 : "Client Prisma avec reconnexion : configurer le connection pool"

**Après** :
- L1687 : "Schéma de base de données (Neon Postgres serverless défaut futurs projets, Postgres Replit pour projets legacy)"
- L1690 : "Migrations : sur **Cloudflare** = GitHub Action pre-deploy (`pnpm drizzle-kit migrate`). Sur **Replit (legacy)** = `prisma migrate deploy` dans `npm start` AVANT le serveur."
- L1692 : "Client edge : `@neondatabase/serverless` + Drizzle (`drizzle-orm/neon-http`) — pas de connection pool nécessaire (HTTP fetch). Sur Replit legacy : Client Prisma avec connection_limit + pool_timeout configurés."

---

## 4. Snippets de référence pour les angles morts

À insérer dans `infrastructure.md` (préférence : nouvelle section "Snippets stack CF par défaut") OU créer `docs/snippets/cloudflare/*.md`. Tous testés conceptuellement contre la stack S3.

### Snippet 1 — `wrangler.toml` Next.js sur Cloudflare Pages

```toml
name = "my-project"
compatibility_date = "2026-05-01"
compatibility_flags = ["nodejs_compat"]
pages_build_output_dir = ".vercel/output/static"

[vars]
NEXT_PUBLIC_APP_URL = "https://my-project.pages.dev"

# Bindings (production)
[[r2_buckets]]
binding = "R2"
bucket_name = "my-project-uploads"

[[d1_databases]]
binding = "DB"
database_name = "my-project-db"
database_id = "xxx-xxx-xxx"

# Secrets : ne jamais commiter ici. Utiliser : wrangler secret put NOM
# Variables runtime : NEON_DATABASE_URL, RESEND_API_KEY, STRIPE_SECRET_KEY, AUTH_SECRET, ANTHROPIC_API_KEY

[env.preview.vars]
NEXT_PUBLIC_APP_URL = "https://preview.my-project.pages.dev"
```

### Snippet 2 — `.github/workflows/deploy.yml` GH → CF Pages

```yaml
name: Deploy to Cloudflare Pages
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions: { contents: read, deployments: write, pull-requests: write }
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
        with: { version: 9 }
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: pnpm }
      - run: pnpm install --frozen-lockfile
      - run: pnpm exec drizzle-kit migrate
        env:
          DATABASE_URL: ${{ secrets.NEON_DATABASE_URL }}
      - run: pnpm build
      - uses: cloudflare/wrangler-action@v3
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          command: pages deploy .vercel/output/static --project-name=my-project
```

### Snippet 3 — Drizzle + Neon serverless (client edge)

```typescript
// src/lib/db.ts
import { drizzle } from "drizzle-orm/neon-http";
import { neon } from "@neondatabase/serverless";
import * as schema from "./schema";

const sql = neon(process.env.DATABASE_URL!);
export const db = drizzle(sql, { schema });
export type DB = typeof db;
```

```typescript
// src/lib/schema.ts
import { pgTable, text, timestamp, uuid } from "drizzle-orm/pg-core";

export const users = pgTable("users", {
  id: uuid("id").primaryKey().defaultRandom(),
  email: text("email").notNull().unique(),
  createdAt: timestamp("created_at", { withTimezone: true }).defaultNow().notNull(),
});
```

```jsonc
// drizzle.config.ts
import { defineConfig } from "drizzle-kit";
export default defineConfig({
  schema: "./src/lib/schema.ts",
  out: "./drizzle",
  dialect: "postgresql",
  dbCredentials: { url: process.env.DATABASE_URL! },
});
```

### Snippet 4 — NextAuth v5 edge-compatible

```typescript
// src/lib/auth.ts
import NextAuth from "next-auth";
import GitHub from "next-auth/providers/github";
import { DrizzleAdapter } from "@auth/drizzle-adapter";
import { db } from "@/lib/db";

export const { handlers, auth, signIn, signOut } = NextAuth({
  adapter: DrizzleAdapter(db),
  providers: [GitHub],
  session: { strategy: "jwt" }, // JWT obligatoire pour edge (DB strategy = Node)
  trustHost: true,              // requis derrière reverse proxy CF
  useSecureCookies: process.env.NODE_ENV === "production",
  secret: process.env.AUTH_SECRET, // 32+ chars random
});
```

```typescript
// src/app/api/auth/[...nextauth]/route.ts
export { GET, POST } from "@/lib/auth";
export const runtime = "edge";
```

### Snippet 5 — Stripe webhook edge (`constructEventAsync`)

```typescript
// src/app/api/webhooks/stripe/route.ts
import Stripe from "stripe";
export const runtime = "edge";

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: "2025-04-30.basil",
  httpClient: Stripe.createFetchHttpClient(),
});
const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET!;

export async function POST(req: Request) {
  const body = await req.text();
  const sig = req.headers.get("stripe-signature")!;
  let event: Stripe.Event;
  try {
    // constructEventAsync requis sur edge (constructEvent = Node crypto sync)
    event = await stripe.webhooks.constructEventAsync(
      body, sig, webhookSecret, undefined, Stripe.createSubtleCryptoProvider()
    );
  } catch (err) {
    return new Response(`Webhook Error: ${(err as Error).message}`, { status: 400 });
  }
  // ... handle event
  return Response.json({ received: true });
}
```

### Snippet 6 — Cloudflare AI Gateway (1 ligne base URL)

```typescript
// src/lib/anthropic.ts — proxy via AI Gateway pour cache, rate limit, logs
import Anthropic from "@anthropic-ai/sdk";

export const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY!,
  baseURL: `https://gateway.ai.cloudflare.com/v1/${process.env.CF_ACCOUNT_ID}/${process.env.CF_GATEWAY_ID}/anthropic`,
});
```

Idem OpenAI : `baseURL: ".../openai"`. Cache hit gratuit, observabilité dashboard CF.

### Snippet 7 — R2 upload via binding (pas SDK S3)

```typescript
// src/app/api/upload/route.ts
import { getRequestContext } from "@cloudflare/next-on-pages";
export const runtime = "edge";

export async function POST(req: Request) {
  const env = getRequestContext().env;
  const file = await req.blob();
  const key = `uploads/${crypto.randomUUID()}`;
  await env.R2.put(key, file, {
    httpMetadata: { contentType: file.type },
  });
  return Response.json({ url: `https://cdn.example.com/${key}` });
}
```

`env.R2` = binding défini dans `wrangler.toml`. Pas de credentials AWS, pas de SDK 80KB.

### Snippet 8 — CF Images vs `next/image` + sharp

```typescript
// next.config.ts
export default {
  images: {
    loader: "custom",
    loaderFile: "./src/lib/cf-image-loader.ts",
  },
};

// src/lib/cf-image-loader.ts
export default function cfLoader({ src, width, quality }: { src: string; width: number; quality?: number }) {
  const params = [`width=${width}`, `quality=${quality || 75}`, "format=auto"].join(",");
  return `/cdn-cgi/image/${params}/${src}`;
}
```

`<Image src="/photo.jpg" width={800} height={600} />` → CF resize on-the-fly, pas de sharp serveur.

### Snippet 9 — `ctx.waitUntil` (remplaçant légitime du fire-and-forget)

```typescript
// src/app/api/track/route.ts
import { getRequestContext } from "@cloudflare/next-on-pages";
import { sendAnalytics } from "@/lib/analytics";
export const runtime = "edge";

export async function POST(req: Request) {
  const event = await req.json();
  const ctx = getRequestContext().ctx;
  // Réponse immédiate au client, mais analytics garanti envoyé avant kill du worker
  ctx.waitUntil(sendAnalytics(event));
  return Response.json({ ok: true });
}
```

**Différence avec fire-and-forget Replit** : `ctx.waitUntil` garantit que la promise s'exécute jusqu'au bout côté CF (le worker n'est pas tué tant que la promise n'est pas resolved, dans la limite des CPU time limits). C'est l'API officielle pour faire de l'async post-response. **À ne PAS utiliser pour les saves critiques** (DB write d'une commande payée) — ces saves restent en `await` avant `Response.json()`. Réservé à : analytics, logs, invalidation cache, warming.

### Snippet 10 — bcryptjs (remplaçant edge-friendly de bcrypt)

```typescript
// src/lib/password.ts
import bcrypt from "bcryptjs"; // pure JS, pas de binding natif

export const hashPassword = (plain: string) => bcrypt.hash(plain, 10);
export const verifyPassword = (plain: string, hash: string) => bcrypt.compare(plain, hash);
```

`bcrypt` (Node binding C++) crash sur CF Workers. `bcryptjs` (pure JS) marche partout (web, Node, edge). Coût : ~30% plus lent que bcrypt natif, négligeable pour login (1× par session).

---

## 5. Recommandations agents à enrichir (par ordre de priorité)

| Ordre | Agent | Modifications | Effort estimé |
|---|---|---|---|
| 1 | `fullstack.md` | Patch P0.1 (self-fetch CF), patch P1 ligne 44 (Drizzle = défaut), patch ligne 89 (`db.ts`), ajouter mention `ctx.waitUntil` ligne 149 | 30 min |
| 2 | `infrastructure.md` | Patch P0.2 (self-fetch CF), patch P0.3 (migrations CI vs boot), insérer les **10 snippets de référence** (section nouvelle "Snippets stack CF par défaut" OU créer `docs/snippets/cloudflare/` avec un fichier par snippet) | 2h |
| 3 | `index.html` | Patches P0.4 (×6 self-fetch) et P0.5 (schema BDD), patches P1 sur les 6 mentions Replit comme défaut | 1h |
| 4 | `qa.md` | Patches P1 lignes 27, 70-72, 105 (Drizzle en parallèle de Prisma) | 15 min |
| 5 | `_base-agent-protocol.md` | Patch P2 ligne 412 (ajouter "Changement wrangler.toml / .github/workflows" dans la checklist post-livrable) | 5 min |
| 6 | `docs/checklists/favicon-checklist.md` | Patch P2 ligne 84 (sharp = local pre-commit only, pas runtime CF) | 5 min |

**Effort total agents** : ~4h. À réaliser en UNE session @infrastructure pour cohérence (éviter d'avoir un fullstack patché et un infrastructure pas patché → contradictions).

---

## 6. Risques résiduels post-application

1. **Snippets non testés en prod** : les 10 snippets ci-dessus sont écrits selon la doc CF/Neon/NextAuth v5 à jour 2026-05, mais aucun n'a été exécuté contre une vraie infra. Le pilote DevRefs (premier projet greenfield S3) doit servir de **gate de validation** avant que ces snippets deviennent canoniques. Si un snippet pète sur DevRefs, repatcher immédiatement le framework.
2. **Drift Prisma vs Drizzle** : marquer Drizzle comme "défaut" sans interdire Prisma laisse une zone grise. Risque qu'un agent choisisse Prisma "par habitude" même sur greenfield CF. **Mitigation** : ajouter une règle explicite dans `fullstack.md` "Sur greenfield CF : Drizzle obligatoire, sauf si justification écrite (extension Postgres exotique non couverte par Drizzle)".
3. **Self-fetch sur projets hybrides** : un projet qui démarre Replit puis migre CF aura du code self-fetch à refactorer. La fiche migration ISSA/Marrant (côté @infrastructure) doit lister ce grep en check obligatoire — déjà présent dans `issa-capital-migration.md` ligne 37, à confirmer dans Marrant.
4. **NextAuth v5 beta** : `next-auth@beta` reste en beta au 2026-05. Risque d'API change. À monitorer (release notes mensuelles), prévoir budget de 1h refacto/projet par changement majeur.
5. **`@cloudflare/next-on-pages` vs adapter officiel** : OpenNext.js a sorti un adapter Cloudflare officiel (`@opennextjs/cloudflare`) qui pourrait remplacer `@cloudflare/next-on-pages`. À trancher par @infrastructure dans le pilote DevRefs avant de figer les snippets.

---

## 7. Handoff → @infrastructure

**Fichiers produits** : `/home/user/Agent-Team/docs/reviews/fullstack-framework-code-update-cf-2026-05-06.md` (ce rapport, ~280L).

**Verdict net** : **5 patches P0 critiques** (pièges qui CASSENT sur CF — self-fetch propagé en 6 endroits, migrate au boot), **9 patches P1** (Prisma encore défaut implicite alors que Drizzle = stack S3), **6 patches P2** (enrichissements). **10 angles morts** comblés par snippets prêts à coller. **Effort total estimé : 4h30** sur une session @infrastructure pour cohérence atomique.

**Actions @infrastructure** :
1. Appliquer les 5 patches P0 EN PRIORITÉ (commit séparé) — sans ça, un agent qui code un nouveau projet CF aujourd'hui produit du code qui crashe au premier appel API.
2. Insérer les 10 snippets de référence dans `infrastructure.md` (nouvelle section) OU créer `docs/snippets/cloudflare/` (1 fichier par snippet — préférence : éviter d'inflater `infrastructure.md` au-delà de 200L).
3. Appliquer les patches P1 (Drizzle vs Prisma).
4. Patches P2 (nice-to-have) en option.
5. **Validation pilote DevRefs** : lors du premier projet greenfield S3, exécuter chaque snippet et reporter les bugs au dos de ce rapport (section "Snippets validés/à corriger").

**Coordination** :
- @infrastructure : applique tous les patches + snippets + maintient les fiches migration ISSA/Marrant.
- @fullstack (moi) : reste disponible pour clarifier les snippets si questions techniques pendant l'application. Sera réinvoqué post-validation pilote DevRefs pour mettre à jour les snippets selon retours terrain.

**Pre-commit check** : N/A (rapport markdown uniquement, pas de code dans `src/`).

**Actions Replit requises** : aucune (rapport documentaire).

**Agent suivant** : **@infrastructure** (application des patches + insertion snippets).
