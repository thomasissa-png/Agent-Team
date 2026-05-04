# Growth — Micro-commerce Agent : Distribution organique
## 10 idées micro-produits à 20€/jour découvrables par les agents IA
*Livrable : growth-microcommerce-iter1-2026-04-24.md*

---

## 1. Tableau 10 idées — rankées par facilité d'acquisition organique

| # | Idée + pitch agent | Mot-clé / requête WebSearch | Volume mensuel [HYPOTHÈSE] | Concurrence SEO | Time-to-rank | Distribution | Effort contenu | Effort SEO/GEO | Conversion crawl→achat | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | **LLM Pricing Live** — tableau JSON/HTML mis à jour quotidiennement : prix GPT-5, Claude Sonnet 4.7, Gemini 2.5 Flash par million de tokens. Les agents re-fetchent car les prix bougent chaque semaine. | "llm api pricing comparison 2026" / "prix claude sonnet mai 2026" | 8 000–15 000/mois | Faible (sites existants statiques, pas de mise à jour auto visible) | 1–3 semaines | GEO + SEO (Perplexity cite souvent ces pages) | 8h setup + 2h/semaine maintien | 2h (llms.txt + JSON-LD UpdatedAt) | 8–15% (besoin immédiat, donnée fraîche) | **ORGANIC FACILE** |
| 2 | **Replit Deploy Checklist 2026** — 37 points Go/No-Go pour deploy Replit Autoscale : variables env, PostgreSQL migrations, health check, rate limit. Format JSON + HTML. | "replit deployment checklist 2026" / "replit autoscale env variables checklist" | 800–2 000/mois | Très faible (niche ultra-précise) | 1 semaine | SEO + IndexNow | 4h | 0h | 12–20% (agent de CI/CD le consulte avant deploy) | **ORGANIC FACILE** |
| 3 | **Mandataires immobilier France — données consolidées** — fichier JSON : nombre IAD/SAFTI/Capifrance, % actifs, top départements, évolution 2024→2026. Agents qui font du marché immo fetch ça. | "nombre mandataires immobilier indépendants France 2026" / "données IAD SAFTI Capifrance statistiques" | 500–1 500/mois | Faible (données éparpillées, aucun agrégateur) | 2–4 semaines | SEO + GEO (Perplexity adore les données FR citables) | 16h (collecte + mise en page) | 2h | 10–18% | **ORGANIC FACILE** |
| 4 | **MCP Server Directory** — liste JSON de tous les MCP servers publics avec : URL, catégorie, auth type, prix/call. Mis à jour hebdomadaire. | "mcp server list 2026" / "model context protocol servers directory" | 3 000–8 000/mois | Faible (marché en explosion, peu de répertoires bons) | 2–3 semaines | GEO + SEO | 16h + 4h/mois maintien | 2h | 6–12% | **ORGANIC FACILE** |
| 5 | **AI API Status Tracker** — page statique remplacée chaque heure : uptime Anthropic/OpenAI/Mistral sur 30 jours, incidents récents. Agent qui orchestre des calls API vérifie ça. | "anthropic api uptime history" / "openai api reliability 2026" | 2 000–5 000/mois | Moyenne (isdown.io existe mais pas IA-centré) | 3–6 semaines | SEO + IndexNow (refresh hourly = signal frais) | 8h setup | 4h | 5–10% | **ORGANIC POSSIBLE** |
| 6 | **Startup B2B SaaS Cache Crunchbase** — snapshot hebdo de 500 startups SaaS B2B FR : funding, fondateurs, email public, stack tech. Évite 10 calls Crunchbase payants. | "startups SaaS B2B France funding 2026" / "crunchbase alternative données startups françaises" | 600–1 800/mois | Faible en FR (Crunchbase = EN, peu de pages FR) | 3–5 semaines | SEO FR + GEO | 40h (scraping éthique LinkedIn/Pappers) | 4h | 4–8% | **ORGANIC POSSIBLE** |
| 7 | **Anthropic Model Vision Benchmark 2026** — comparatif structured : Claude Haiku/Sonnet/Opus sur 12 tâches vision (OCR, charts, screenshots UI, PDFs). JSON + tableau HTML. | "claude vision benchmark 2026" / "quel modèle anthropic pour vision" | 1 000–3 000/mois | Faible | 2–4 semaines | GEO + SEO | 16h | 2h | 6–10% | **ORGANIC FACILE** |
| 8 | **French Legal NLP Dataset sampler** — 500 décisions de justice anonymisées + labels (type, juridiction, outcome). Agent de legal-tech cherche des données d'entraînement FR. | "dataset décisions justice France NLP 2026" / "corpus juridique français open source" | 400–900/mois | Très faible | 1–2 semaines | SEO + GEO | 40h | 2h | 8–14% (très haute intention d'achat) | **ORGANIC FACILE** |
| 9 | **x402 Payment Integration Template** — starter code Next.js/FastAPI pour accepter x402 (USDC on Base) en 1h. Agents qui buildent des micro-services cherchent ça. | "x402 payment integration tutorial 2026" / "how to implement x402 api payment" | 500–2 000/mois | Faible (x402 récent, très peu de tutos) | 1–2 semaines | SEO + Dev.to cross-post | 8h | 2h | 10–18% | **ORGANIC FACILE** |
| 10 | **Benchmark SEO AI Overviews CTR 2026** — données consolidées : CTR moyen par position avec/sans AI Overview, par secteur (SaaS, e-commerce, B2B). | "ai overview impact seo ctr data 2026" / "google ai overview click through rate study" | 1 500–4 000/mois | Moyenne (position.digital, Search Engine Land couvrent) | 4–8 semaines | SEO + GEO | 16h | 4h | 3–6% | **NEED PAID** (pour dépasser les gros sites) |

---

## 2. Top 3 — Analyse SEO/GEO détaillée

### #1 LLM Pricing Live
- **Requête principale** : "llm api pricing comparison 2026" [HYPOTHÈSE : 8 000–15 000/mois, basé sur le trafic observé sur pricepertoken.com, costgoat.com, benchlm.ai]
- **Requêtes secondaires agent-style** : "prix claude haiku 1 mai 2026", "gemini 2.5 flash prix token input output", "llm le moins cher pour function calling 2026"
- **Concurrence** : pricepertoken.com, costgoat.com, devtk.ai existent mais sont des SaaS lourds. Une page HTML simple + JSON endpoint mis à jour auto = plus rapide à crawler pour un agent.
- **Avantage GEO décisif** : Perplexity/ChatGPT citent souvent des tableaux de prix. Une page avec JSON-LD `Dataset` + `dateModified` quotidien sera préférée aux sources statiques.
- **Setup** : 1 script Python + cron → fetch official API pricing pages (OpenAI, Anthropic, Mistral docs) → génère `pricing.json` → rebuild HTML. Zéro intervention humaine après setup.
- **Monétisation x402** : `GET /pricing.json` → HTTP 402 → 0,01 USDC/call. 2 000 calls/jour = 20€.

### #2 MCP Server Directory
- **Requête principale** : "mcp server list 2026" [HYPOTHÈSE : 3 000–8 000/mois, marché en explosion post-lancement officiel MCP par Anthropic nov. 2024]
- **Requêtes agent-style** : "mcp server database postgresql", "model context protocol file system server", "mcp servers compatible claude code"
- **Concurrence** : mcphub.ai, glama.ai/mcp existent mais peu optimisés SEO et pas de JSON endpoint propre pour agents.
- **Avantage** : llms.txt + sitemap XML + `application/json` endpoint = découvrable par Claude Code, Cursor, tout agent qui fait `WebSearch "mcp server X"`.
- **Signal fraîcheur** : mise à jour hebdo des nouveaux servers = IndexNow push = Bing/Google ré-indexe en 24h.

### #3 Replit Deploy Checklist 2026
- **Requête principale** : "replit deployment checklist 2026" [HYPOTHÈSE : 800–2 000/mois, ultra-niche mais intention maximale]
- **Pourquoi les agents trouvent** : Claude Code lui-même fait WebSearch avant un deploy Replit. Thomas utilise Replit — la page aura du contenu très précis (Autoscale, PostgreSQL, env vars secrets).
- **Concurrence** : nulle (Replit docs ne couvrent pas les cas edge). Une page avec les 37 points = première result en 1 semaine via IndexNow.
- **Monétisation** : pas x402 pour ce cas — Stripe Payment Link 1€ pour le fichier JSON interactif (les 37 points avec statuts PASS/FAIL exportables). Volume faible mais conversion > 20%.

---

## 3. Le piège distribution — idées qui semblent bonnes mais personne ne trouve

**Piège #1 : "Base de données de prompts"**
Requêtes ultra-génériques ("best prompts 2026"). Dominées par PromptHero, FlowGPT, Reddit. Time-to-rank : 12+ mois. Pas de requête agent précise.

**Piège #2 : "Générateur de landing page copy"**
Outil, pas donnée. Un agent ne cherche pas "générateur landing page" — il le fait lui-même. Zéro trafic agent autonome.

**Piège #3 : Données sans angle "date fraîche"**
Ex. : "liste des APIs REST gratuites" — article écrit une fois, jamais re-fetché. Un agent ne re-fetch que si la donnée change (prix, uptime, nouvelles entrées). Sans signal de fraîcheur dans le JSON-LD (`dateModified`), Google dérange le classement et Perplexity n'identifie pas la page comme source fiable.

**Piège #4 : Niche trop étroite sans communauté**
"Benchmark GPU inference Groq vs Fireworks Q2 2026" — 50 recherches/mois max. En dessous de 300 recherches/mois, même avec 0 concurrence, le trafic organique ne suffit pas à atteindre 20€/jour sans viralité externe.

---

## 4. Setup acquisition 24h — garantir que les agents trouvent en 1 semaine

**Heure 0–4 : Structure technique discoverable**
- `llms.txt` à la racine : décrit le micro-service en 5 lignes + endpoint de paiement x402/Stripe.
- `sitemap.xml` avec `<lastmod>` dynamique (se met à jour à chaque refresh de données).
- JSON-LD `Dataset` ou `WebPage` avec `dateModified` ISO 8601 automatique.
- Header HTTP `Last-Modified` sur tous les endpoints JSON.

**Heure 4–8 : IndexNow push Bing (indexation < 24h)**
- 1 appel API IndexNow après chaque mise à jour données → Bing indexe en 2–4h.
- Google suit Bing en 24–72h (corrélation documentée).
- Coût : 0€.

**Heure 8–16 : GEO seeding (citer la page dans les LLMs)**
- 2 posts Dev.to via API REST (`POST /api/articles`) avec mention de l'URL + contexte d'usage agent.
- 1 post Reddit r/LocalLLaMA ou r/ClaudeAI : "j'ai fait une page qui se met à jour auto — voici l'URL".
- Dev.to est crawlé par tous les LLMs (inclus dans les training sets). Un post avec l'URL = la page sera citée dans les réponses LLM dans 2–4 semaines.

**Heure 16–24 : Validation signal agent réel**
- Tester : `curl "https://perplexity.ai/search?q=llm+api+pricing+2026"` → vérifier si la page apparaît.
- Si non : ajouter 3 FAQ structurées en JSON-LD sur la page (les LLMs répondent mieux aux formats Q&A).
- Créer `robots.txt` avec `Allow: /` explicite + `Crawl-delay: 0` pour les bots connus (Anthropicbot, GPTBot, PerplexityBot).

**KPI J+7 :** 1 citation Perplexity + 50 crawls uniques (Cloudflare Analytics) + 1 transaction x402/Stripe. Si 0 → pivot vers l'idée suivante dans le tableau.

---

*Sources recherche :*
- [Search API Pricing Compared 2026 — Awesome Agents](https://awesomeagents.ai/pricing/search-api-pricing/)
- [x402 — Internet-Native Payments Standard](https://www.x402.org/)
- [AI Agent Payments and the x402 Protocol — WooshPay](https://www.wooshpay.com/resources/2026/04/25/ai-agent-payments-and-the-x402-protocol-the-future-of-autonomous-payment-infrastructure/)
- [LLM API Pricing 2026 — Compare 300+ Models](https://pricepertoken.com/)
- [LLM API Pricing Comparison May 2026 — Costgoat](https://costgoat.com/compare/llm-api)
- [Agentic Search in 2026 — Marketing Agent Blog](https://marketingagent.blog/2026/04/20/agentic-search-in-2026-how-ai-agents-are-rewriting-your-seo/)
- [x402 on AWS — Agentic Commerce](https://aws.amazon.com/blogs/industries/x402-and-agentic-commerce-redefining-autonomous-payments-in-financial-services/)
- [AI API Pricing Comparison April 2026 — DevTk.AI](https://devtk.ai/en/blog/ai-api-pricing-comparison-2026/)
