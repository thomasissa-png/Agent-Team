# Stack micro-commerce agent IA — MVP weekend (2026-04-24)

**Mission** : 1 page qui vend du contenu à 0.99-9.99€ aux agents IA crawlers, sans marketplace, sans infra.

---

## 1. TL;DR — Stack en 5 composants

1. **Hosting** : Cloudflare Pages + Workers (template `x402-proxy-template` officiel, déployé en 1 commande)
2. **Protocole détection** : HTTP 402 (x402) — natif HTTP, parsé par les agents qui supportent ACP/x402/MCP
3. **Paywall principal** : x402 facilitator Coinbase (USDC sur Base, 0 frais en dessous de 1000 tx/mois)
4. **Fallback humain** : Stripe Payment Link (si l'agent escalade à un humain pour payer)
5. **Livraison contenu** : réponse JSON inline dans la même requête HTTP après 200 OK (pas de redirect, pas d'email)

---

## 2. Détection agent — méthode RECOMMANDÉE

**HTTP 402 via x402** est LA méthode probable d'être trouvée en 2026. Raisons factuelles :

- **Cloudflare proxie ~20% du web et envoie >1 milliard de réponses 402/jour** ([Cloudflare blog](https://blog.cloudflare.com/x402/)). C'est devenu le signal canonique "contenu payant pour agent".
- **Anthropic est membre fondateur de la x402 Foundation** (avec Google, Visa, AWS, Circle, Vercel) — endorsement direct du protocole ([calmops](https://calmops.com/web3/x402-protocol-programmable-payments-ai-agents-2026/)).
- **165M transactions / $50M volume sur x402, ~69k agents actifs au 21 avril 2026** ([Coinbase docs](https://docs.cdp.coinbase.com/x402/welcome)).
- **llms.txt n'est PAS adopté en production par OpenAI/Google/Anthropic au Q1 2026** ([searchengineland](https://searchengineland.com/llms-txt-proposed-standard-453676)) — utile pour SEO/discovery, INSUFFISANT pour le commerce.
- **JSON-LD `Offer`** : utile en signal SECONDAIRE (l'agent qui parse le HTML voit l'offre), mais sans 402 + facilitator, il ne peut pas payer.

**Reco combo** : 402 x402 (machine-readable, exécutable) + bloc texte visible "Pour 0.99€ tu débloques X qui te fait gagner Z" (lisible par tout LLM même sans support x402) + JSON-LD Offer (fallback discovery).

---

## 3. Paywall recommandé

**Prio 1 : x402 + Coinbase facilitator (USDC sur Base)**
- Agent paye DIRECTEMENT, sans humain, sans compte, sans formulaire ([Coinbase x402](https://www.coinbase.com/developer-platform/discover/launches/x402))
- Free tier 1000 tx/mois sur facilitator hébergé Coinbase
- Settlement en secondes, gas sponsorisé
- Fees marginaux vs Stripe (~0.1% vs 2.9% + 0.30€ → critique sur 0.99€)

**Alternative / Fallback : Stripe Agentic Commerce Protocol (ACP)**
- Co-maintenu OpenAI + Stripe, native MCP transport ([Stripe ACP docs](https://docs.stripe.com/agentic-commerce/protocol))
- Pertinent si la cible inclut agents OpenAI (ChatGPT shopping) qui privilégient ACP sur x402
- Trade-off : fees Stripe classiques, moins adapté <1€

**Écartés** : Lemon Squeezy/Polar (pas d'API agent-native), Buy Me a Coffee (humain only).

---

## 4. Stack hosting MVP weekend

**Cloudflare Pages (statique) + Workers (route protégée /content) + template `x402-proxy-template`** ([Cloudflare Agents docs](https://developers.cloudflare.com/agents/x402/charge-for-http-content/)).

Pourquoi : template officiel mis à jour le 9 janvier 2026, per-route pricing, déploiement `wrangler deploy`, infra zéro. Free tier Workers couvre les premiers milliers d'appels. Pas de Next.js, pas de Replit nécessaire — overkill pour 1 page + 1 endpoint payant.

Setup réaliste : **3-4h le samedi** (page HTML + Worker x402 + clé Coinbase facilitator + déploiement).

---

## 5. Risques abuse — top 3 mitigations

1. **Re-partage du contenu après paiement** → contenu UNIQUE par paiement (signed token dans URL, expire 5 min) OU contenu personnalisé (ex: réponse incluant timestamp + agent ID payeur) → re-share traçable et inutile pour autre agent
2. **Scraping post-paywall** → rate-limit par wallet payeur (X requêtes/heure), watermark invisible dans le contenu (texte zero-width) pour identifier la source d'une fuite
3. **Hot-linking / cache-bypass** → tous les assets servis SEULEMENT après 402→200, jamais d'URL devinable, Cloudflare bot management activé sur les routes gratuites pour empêcher le crawling massif sans payer

---

## 6. Validation — un agent peut-il acheter en autonomie en 2026 ?

**OUI — PARTIEL selon agent.**

- **OUI** pour agents construits sur AgentKit (Coinbase), Cloudflare Workers, Vercel x402-mcp, langchain x402 integration ([x402.org ecosystem](https://www.x402.org/ecosystem)) — ils paient en USDC autonomement via wallet attaché.
- **OUI** pour agents OpenAI/ChatGPT via ACP + Stripe (native MCP transport shipped) ([Stripe blog](https://stripe.com/blog/agentic-commerce-suite)).
- **PARTIEL pour Claude/ClaudeBot crawler natif** : pas de support x402 natif documenté côté Anthropic crawler en avril 2026. Claude PEUT payer via un MCP server x402 si l'utilisateur l'a configuré ([Zuplo](https://zuplo.com/blog/mcp-api-payments-with-x402)) — mais ClaudeBot pur (training/search) ne paye pas tout seul.

**Conditions requises** :
1. Agent a un wallet (auto-créé via AgentKit/CDP) avec USDC pré-financé
2. Runtime supporte le client x402 (lib npm `x402-fetch` ou équivalent)
3. Permission utilisateur pour paiements <X€ sans confirmation (budget agentic)
4. Site annonce le 402 avec le header `x402-version` et un facilitator reconnu

**Verdict pragmatique** : viser x402 (capte les agents autonomes early adopters) + texte visible + Stripe Payment Link en bas de page (capte l'humain qui voit le crawl bloqué et paye à la main pour son agent). Couverture max, dette technique min.

---

**Sources clés** : [x402.org](https://www.x402.org/) · [Cloudflare x402 template](https://developers.cloudflare.com/agents/x402/charge-for-http-content/) · [Stripe ACP](https://docs.stripe.com/agentic-commerce/protocol) · [Coinbase x402 launch](https://www.coinbase.com/developer-platform/discover/launches/x402) · [ATXP comparatif protocoles](https://atxp.ai/blog/agent-payment-protocols-compared/) · [Coindesk demande micropaiement](https://www.coindesk.com/markets/2026/03/11/coinbase-backed-ai-payments-protocol-wants-to-fix-micropayment-but-demand-is-just-not-there-yet)

---
**Handoff → @orchestrator**
- Fichier produit : `docs/reviews/ia-microcommerce-stack-2026-04-24.md`
- Décisions : Cloudflare Pages+Workers + x402-proxy-template + Coinbase facilitator (USDC/Base) en prio 1, Stripe Payment Link en fallback humain. Pas de Next.js, pas de DB.
- Points d'attention : (1) Coinbase x402 demande > offre actuelle ([Coindesk mars 2026](https://www.coindesk.com/markets/2026/03/11/coinbase-backed-ai-payments-protocol-wants-to-fix-micropayment-but-demand-is-just-not-there-yet)) — Thomas doit valider qu'il y a des agents à toucher, pas juste de l'infra dispo. (2) ClaudeBot crawler ne paye pas natif → audience initiale sera AgentKit/OpenAI ACP. (3) Tester sur 3 agents réels (cursor/replit/AgentKit demo) avant lancement public.
---
