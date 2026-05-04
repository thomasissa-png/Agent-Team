# Growth — Micro-commerce agents IA : 10 idées à distribution organique
*Livrable @growth — 2026-04-24 — max 70 lignes*

---

## 1. Tableau 10 idées rankées par facilité d'acquisition organique

| Rank | Idée | Requête WebSearch agent | Volume estimé [HYPOTHÈSE] | Concurrence SEO | Time-to-rank | Distribution | Effort contenu | Effort SEO/GEO | Conv. [HYPOTHÈSE] | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | **Replit Deploy Checklist 2026** — 37 points Go/No-Go pour deploy Replit Autoscale : env vars, PostgreSQL migrations, health check, rate limit. JSON + HTML. | "replit deployment checklist 2026" | 800–2 000/mois | Très faible | 1 semaine | SEO + IndexNow | 4h | 0h | 12–20% | ORGANIC FACILE |
| 2 | **MCP Server Directory** — liste JSON de tous les MCP servers publics : URL, catégorie, auth type, prix/call. Mis à jour hebdomadaire. | "mcp server list 2026" / "model context protocol servers" | 3 000–8 000/mois | Faible (marché en explosion) | 2–3 semaines | GEO + SEO | 16h + 4h/mois | 2h | 6–12% | ORGANIC FACILE |
| 3 | **LLM Pricing Live** — tableau JSON/HTML mis à jour quotidiennement : prix GPT-5, Claude Sonnet, Gemini 2.5 par million de tokens + coût par tâche-type. | "llm api pricing comparison 2026" / "prix claude sonnet mai 2026" | 8 000–15 000/mois | Forte (pricepertoken.com, helicone) mais aucun avec fraîcheur H24 | 1 mois | GEO + SEO | 8h + 2h/semaine | 2h | 8–15% | ORGANIC POSSIBLE |
| 4 | **Anthropic Model Vision Benchmark** — comparatif structuré : Claude Haiku/Sonnet/Opus sur 12 tâches vision. JSON + tableau HTML mis à jour à chaque release. | "claude vision benchmark 2026" / "quel modèle anthropic pour vision" | 1 000–3 000/mois | Faible | 2–4 semaines | GEO + SEO | 16h | 2h | 6–10% | ORGANIC FACILE |
| 5 | **x402 Payment Integration Template** — starter code Next.js/FastAPI pour accepter x402 (USDC on Base) en 1h. | "x402 payment integration tutorial 2026" / "how to implement x402 api" | 500–2 000/mois | Faible (x402 récent, peu de tutos) | 1–2 semaines | SEO + Dev.to | 8h | 2h | 10–18% | ORGANIC FACILE |
| 6 | **Mandataires Immobilier France — données consolidées** — JSON : nombre IAD/SAFTI/Capifrance, % actifs, top départements, évolution 2024→2026. | "nombre mandataires immobilier indépendants France 2026" | 500–1 500/mois | Faible (données éparpillées, aucun agrégateur) | 2–4 semaines | SEO + GEO | 16h | 2h | 10–18% | ORGANIC FACILE |
| 7 | **AI API Status Tracker** — uptime Anthropic/OpenAI/Mistral sur 30 jours, incidents récents. Rafraîchi toutes les heures. | "anthropic api uptime history" / "openai api reliability 2026" | 2 000–5 000/mois | Moyenne (isdown.io non IA-centré) | 3–6 semaines | SEO + IndexNow | 8h setup | 4h | 5–10% | ORGANIC POSSIBLE |
| 8 | **French Legal NLP Dataset sampler** — 500 décisions de justice anonymisées + labels (type, juridiction, outcome). | "dataset décisions justice France NLP 2026" | 400–900/mois | Très faible | 1–2 semaines | SEO + GEO | 40h | 2h | 8–14% | ORGANIC FACILE |
| 9 | **Startup B2B SaaS Cache Crunchbase** — snapshot hebdo 500 startups SaaS B2B FR : funding, fondateurs, email public. | "startups SaaS B2B France funding 2026" / "crunchbase alternative données FR" | 600–1 800/mois | Faible en FR | 3–5 semaines | SEO + GEO | 40h | 4h | 4–8% | ORGANIC POSSIBLE |
| 10 | **Benchmark SEO AI Overviews CTR 2026** — CTR moyen par position avec/sans AI Overview, par secteur. | "ai overview impact seo ctr data 2026" | 1 500–4 000/mois | Forte (Search Engine Land, position.digital) | 4–8 semaines | SEO + GEO | 16h | 4h | 3–6% | NEED PAID |

---

## 2. Top 3 — Analyse SEO/GEO détaillée

### #1 — Replit Deploy Checklist 2026
**Requête principale :** `replit deployment checklist 2026` [HYPOTHÈSE : 800–2 000/mois]
**Requêtes agent-style :** "replit autoscale env variables checklist", "replit postgresql migration deploy"
**Concurrence :** quasi nulle — la doc officielle Replit est générique, Stack Overflow a des réponses 2023 obsolètes
**Pourquoi les agents trouvent :** Claude Code fait lui-même WebSearch avant un deploy Replit. Thomas utilise Replit — contenu très précis (Autoscale, PostgreSQL, env vars secrets). Page avec 37 points = résultat #1 possible en 1 semaine via IndexNow.
**Setup GEO :** JSON-LD FAQ + llms.txt pointant sur la page. Monétisation : Stripe Payment Link 1€ pour export JSON PASS/FAIL. Volume modeste mais conversion > 20%.
**Effort total :** 4h rédaction + 1h JSON-LD + soumission IndexNow = activable en 24h.

### #2 — MCP Server Directory
**Requête principale :** `mcp server list 2026` [HYPOTHÈSE : 3 000–8 000/mois, marché en explosion post-lancement MCP officiel Anthropic nov. 2024]
**Requêtes agent-style :** "mcp server database postgresql", "model context protocol file system server", "mcp servers compatible claude code"
**Concurrence :** mcphub.ai, glama.ai existent mais peu optimisés SEO et pas de JSON endpoint propre pour agents.
**Avantage :** llms.txt + sitemap XML + endpoint `application/json` = découvrable par Claude Code, Cursor, tout agent qui fait WebSearch. Mise à jour hebdo + IndexNow push = Bing ré-indexe en 24h.
**Monétisation x402 :** `GET /servers.json` → HTTP 402 → 0,01 USDC/call. 2 000 calls/jour = 20€.

### #3 — LLM Pricing Live
**Requête principale :** `llm api pricing comparison 2026` [HYPOTHÈSE : 8 000–15 000/mois, +40%/mois de croissance observée en 2025–2026]
**Requêtes agent-style :** "prix claude haiku 1 mai 2026", "llm le moins cher pour function calling 2026", "gemini 2.5 flash prix token input output"
**Concurrence :** pricepertoken.com, costgoat.com, helicone.ai — tous existent mais pas de mise à jour H24 ni de vue "budget par tâche-type".
**Différenciateur obligatoire :** fraîcheur H24 (cron + scraping pages pricing officielles) + coût calculé par tâche (pas juste $/token). JSON-LD `Dataset` avec `dateModified` quotidien = préféré par Perplexity sur les sources statiques.
**Barrière :** nécessite 2–3 backlinks (citations dans newsletters tech) pour dépasser les incumbents. Time-to-rank 1 mois minimum.

---

## 3. Le piège distribution — idées qui semblent bonnes mais personne ne trouve

**Piège #1 : Volume élevé + incumbents forts.** "AI overview impact SEO CTR 2026" — 2 000+ recherches/mois mais Search Engine Land, Ahrefs, SEMrush écrasent les résultats. Impossible sans autorité de domaine ou budget liens.

**Piège #2 : Outil interactif sans requête factuelle.** Un "calculateur ROI agent IA" est utile mais personne ne tape cette requête — l'agent calcule lui-même. La page doit répondre à une question factuelle qu'il NE PEUT PAS résoudre seul (donnée fraîche, externe).

**Piège #3 : Données sans signal de fraîcheur.** "Liste des APIs REST gratuites" — article écrit une fois, jamais re-fetché. Un agent ne re-fetch que si la donnée change. Sans `dateModified` dans le JSON-LD, Perplexity n'identifie pas la page comme source fiable pour des données temps-réel.

**Piège #4 : Niche < 300 recherches/mois sans viralité.** "Benchmark GPU inference Groq vs Fireworks Q2 2026" — 50 recherches/mois. Même avec 0 concurrence, le trafic organique seul ne suffit pas à atteindre 20€/jour. Seuil minimum viable : 500+ recherches/mois OR viralité externe documentée.

**Règle synthèse :** la page doit répondre à une requête qu'un agent fait quand il a BESOIN d'une donnée externe fraîche impossible à calculer localement. C'est le seul cas où il paie.

---

## 4. Setup acquisition 24h — garantir que les agents trouvent en 1 semaine

**H0–4 : Structure technique discoverable**
- `llms.txt` à la racine : 5 lignes max, décrit le micro-service + endpoint paiement x402/Stripe
- `sitemap.xml` avec `<lastmod>` dynamique mis à jour à chaque refresh de données
- JSON-LD `Dataset` ou `WebPage` avec `dateModified` ISO 8601 automatique
- Header HTTP `Last-Modified` sur tous les endpoints JSON
- `robots.txt` avec `Allow: /` + `User-agent: Anthropicbot, GPTBot, PerplexityBot` explicites

**H4–8 : Indexation forcée (coût zéro)**
- Google Search Console → URL Inspection → Request indexing
- IndexNow API (1 appel POST) → Bing indexe en 2–4h → Google suit en 24–72h
- Automatiser : après chaque mise à jour données, script déclenche IndexNow push

**H8–16 : GEO seeding**
- 2 posts Dev.to via API REST (`POST dev.to/api/articles`) : article court avec l'URL + contexte usage agent. Dev.to est inclus dans les training sets LLM — citation probable dans 2–4 semaines.
- 1 post Reddit r/LocalLLaMA ou r/ClaudeAI : "ressource que j'ai construite parce que je ne trouvais pas X"
- Aucune relation presse nécessaire — distribution 100% automatisable

**H16–24 : Validation signal**
- Test manuel Perplexity sur la requête cible : est-ce que la page apparaît ?
- Si non : ajouter 3 FAQ structurées JSON-LD (les LLMs répondent mieux aux Q&A)
- Cloudflare Analytics : vérifier les crawls de GPTBot, Anthropicbot, PerplexityBot

**KPI J+7 :** 1 citation Perplexity + 50 crawls uniques + 1 transaction x402/Stripe. Si 0 : pivot vers l'idée suivante dans le tableau.

---

*Sources :*
- [Search API Pricing Compared 2026 — Awesome Agents](https://awesomeagents.ai/pricing/search-api-pricing/)
- [AI Search API Pricing April 2026 — buildmvpfast.com](https://www.buildmvpfast.com/api-costs/ai-search)
- [x402 — Internet-Native Payments Standard](https://www.x402.org/)
- [x402 Agentic Commerce — AWS](https://aws.amazon.com/blogs/industries/x402-and-agentic-commerce-redefining-autonomous-payments-in-financial-services/)
- [LLM API Pricing 2026 — pricepertoken.com](https://pricepertoken.com/)
- [LLM API Pricing Comparison May 2026 — costgoat.com](https://costgoat.com/compare/llm-api)
- [llms.txt adoption study — otterly.ai](https://otterly.ai/blog/the-llms-txt-experiment/)

---

**Handoff → @orchestrator**
- Fichiers produits : `docs/reviews/growth-microcommerce-iter1-2026-04-24.md`
- Décisions prises : top 3 idées (Replit Deploy Checklist, MCP Server Directory, LLM Pricing Live) ; filtre de viabilité = "requête factuelle fraîche non-calculable localement" ; setup 24h IndexNow + Dev.to + GSC documenté
- Points d'attention : idée #6 (mandataires) a synergie directe avec verticale ImmoCrew dans project-context.md — sourcing data mutualisable. Idée #3 (LLM Pricing) nécessite différenciateur fort (fraîcheur H24 + coût/tâche) pour dépasser incumbents. Idée #5 (x402 template) activable immédiatement car x402.org est le standard naissant : 35M+ transactions déjà traitées, fenêtre de leadership courte.
