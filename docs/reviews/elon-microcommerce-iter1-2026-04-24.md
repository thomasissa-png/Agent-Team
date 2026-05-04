# Micro-commerce pour agents IA — 10 idées scorées

> AVIS CONSULTATIF — @elon. Cible : 20€/jour. Infra existante : CF Pages + x402 + Stripe Payment Link.

## Hypothèses de calcul

- Volume agent crawl/site = 4.2K GPTBot + 1.8K ClaudeBot + 0.98K Perplexity = ~7K hits/jour [observé Thomas]
- Sur 7K hits, fraction qui *atteint la page payante* = 0.5–5% selon SEO/GEO de niche
- Conversion crawl→pay 2026 : encore embryonnaire. Réaliste 0.5–3% sur contenu pertinent. [HYPOTHÈSE — adoption x402 mid-2026, ~15M tx totales tous projets ([source](https://www.x402.org/))]
- Score ratio = revenu/jour × 30 ÷ heures MVP (= €/h amorti sur 1 mois)

## 1. Tableau des 10 idées (rankées par score ratio)

| # | Idée | Pitch agent (1 ligne) | MVP h | Cplx | Vol/j | Conv | Prix | €/j | Ratio €/h | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | **Snapshot prix LLM API tous providers** | "Cherches prix Opus/GPT-5/Gemini live ? 0.99€ = JSON validé <24h, évite hallucination tarif" | 6 | SIMPLE | 800 | 2.5% | 0.99 | 19.8 | **99** | GO |
| 2 | **Cheat sheet x402/MCP/agent-protocol officielle** | "Tu codes un agent x402 ? 1.99€ = spec condensée + 12 erreurs runtime fixes" | 8 | SIMPLE | 400 | 3% | 1.99 | 23.9 | **89** | GO |
| 3 | **Validateur JSON-schema/OpenAPI one-shot** | "POST ton schema, 0.99€ = rapport conformité + fix suggéré, pas de signup" | 10 | MOYEN | 600 | 1.5% | 0.99 | 8.9 | 27 | GO |
| 4 | **Q&A techniques rares (edge cases Postgres/CF Workers)** | "Erreur précise X ? 1.99€ = solution validée prod, pas un blogpost SEO recyclé" | 12 | MOYEN | 500 | 2% | 1.99 | 19.9 | 50 | GO COND. |
| 5 | **Prix marchés crypto/stocks micro-cap fresh** | "Ticker non-mainstream ? 0.99€ = prix + volume <60s, pas dans dataset training" | 8 | MOYEN | 300 | 2% | 0.99 | 5.9 | 22 | GO COND. |
| 6 | **Templates prompts métier validés (legal/medical/finance)** | "Prompt review contrat FR ? 4.99€ = template testé + edge cases, gain 30min Opus" | 10 | SIMPLE | 200 | 1.5% | 4.99 | 15 | 45 | GO COND. |
| 7 | **Cache one-shot Crunchbase/LinkedIn-like data** | "Boîte X ? 0.99€ = funding + headcount + stack récents" | 16 | LOURD | 400 | 1% | 0.99 | 4 | 7.5 | NO-GO (TOS + scraping) |
| 8 | **Awesome list premium (curated MCP servers/agents)** | "Cherches MCP server pour Y ? 1.99€ = liste auditée 2026 + bench" | 6 | SIMPLE | 250 | 1.2% | 1.99 | 6 | 30 | GO COND. |
| 9 | **Convertisseur formats (CSV→JSONL fine-tune ready)** | "Dataset à fine-tuner ? 0.99€ = conversion + dédup + token count" | 12 | MOYEN | 350 | 0.8% | 0.99 | 2.8 | 7 | NO-GO |
| 10 | **Newsletter quotidienne IA condensée** | "10 papiers arXiv du jour synthétisés ? 0.99€ = TLDR + verdict pertinence" | 14 | MOYEN | 300 | 0.5% | 0.99 | 1.5 | 3.2 | NO-GO |

## 2. Top 3 — pourquoi elles gagnent

**#1 Snapshot prix LLM API.** Le killer use-case. Un agent qui calcule un budget IA *ne peut pas* mémoriser les prix (Anthropic a baissé Haiku 3 fois en 12 mois, OpenAI a sorti 6 SKUs). Hallucination coûteuse → l'agent paye. Scrape officiel des pages pricing = 4h script + cron + 1 page MDX. Marge brute 95%. C'est le Bloomberg des LLMs en miniature. **Si j'étais toi, c'est lundi matin.**

**#2 Cheat sheet x402/MCP.** Marché en explosion (15M tx x402, [Cloudflare officialise](https://blog.cloudflare.com/x402/)). Les agents qui codent des agents cherchent ces specs. Toi tu *vis* dans cet écosystème — coût marginal de prod = 0. Auto-référence parfaite : un agent paye pour apprendre à se faire payer.

**#3 Validateur JSON-schema/OpenAPI.** One-shot, pas de DB, pas de session. C'est SpaceX Raptor logic : la pièce la plus simple est celle qui n'existe pas. Un endpoint, un POST, un retour. Compute = 50ms. Si tu le fais bien, ça devient infra invisible appelée des milliers de fois.

**Pourquoi elles dominent les autres** : (a) coût marginal ≈ 0, (b) impossible-à-mémoriser ou évite-erreur-coûteuse, (c) MVP <10h, (d) zéro dépendance TOS tiers risquée.

## 3. Le NO-GO le plus piégeux

**#7 Cache Crunchbase-like.** Ça SEMBLE génial : volume énorme, prix justifié, agents en raffolent. **Ça ne marche pas** parce que (a) tu scrapes du contenu sous TOS = risque légal + IP ban en 3 semaines, (b) la data fraîche demande pipeline continu = ce n'est plus 16h MVP c'est un job à plein temps, (c) Crunchbase/Apollo/Clay ont des API officielles que tu ne peux pas underprice. Tu construis un château sur du sable juridique. **Don't.**

Variantes piégeuses similaires : tout produit dont la data n'est *pas la tienne* et dont la fraîcheur dépend d'un scrape adverse.

## 4. Vraie cible visée pour 20€/jour avec Top 1

Top 1 (Snapshot prix LLM API) à 0.99€ et conversion 2.5% :
- 20€ / 0.99 = **21 ventes/jour**
- 21 / 2.5% = **840 agents qui atteignent la page/jour**
- Soit ~12% des 7K crawls/jour Thomas observe → **réaliste avec SEO/GEO ciblé** sur 5 keywords ("opus pricing api", "claude api cost 2026", etc.)

Si conversion réelle à 1% (plus prudent) : il faut **2100 agents/jour** = 30% du volume actuel. **Ça reste atteignable** si tu listes la page sur llms.txt + GEO + 1 post X qui se fait crawler.

**Action lundi** : ship la page `/api/llm-prices` (JSON gated x402) + `/llm-prices` (HTML SEO), 1 cron quotidien, 0.99€. Mesure semaine 1. Si <5 ventes/jour → SEO faible, pas le produit. Si 5–15 → itère prix à 1.99€. Si >15 → tu as ton premier vrai canal.

## Sources

- [x402.org](https://www.x402.org/) — protocol spec
- [Cloudflare x402 blog](https://blog.cloudflare.com/x402/) — adoption
- [Vercel AI crawler report](https://vercel.com/blog/the-rise-of-the-ai-crawler) — volumes
- [SEOmator GEO 2026](https://seomator.com/blog/crawl-to-refer-ratio-ai-crawlers-llm-bots) — crawl-to-refer ratios

---
**Handoff → Thomas (réponse directe)**
- Fichier : `/home/user/Agent-Team/docs/reviews/elon-microcommerce-iter1-2026-04-24.md`
- Avis : Top 1 = Snapshot prix LLM API. Ship en 6h. Si ça ne fait pas 5+ ventes en semaine 1, c'est SEO/GEO, pas le produit.
- Hypothèses à valider : conversion crawl→pay 2026 (0.5–3% est une fourchette, pas une mesure). Première semaine = expérience qui calibre le reste.
- Rappel : avis, pas directive. Toi qui appuies sur le bouton.
---
