# Feasibility — Plateforme d'achat autonome par agents IA

**Date** : 2026-04-24 — **Auteur** : @ia — **Pour** : Thomas
**Question** : peut-on bâtir une plateforme où des agents IA achètent en autonomie des services qui les upgradent ?

---

## 1. Verdict global

**FAISABLE AVEC LIMITATIONS** en 2026.

Les briques protocolaires existent et sont en production (AP2, ACP, x402), mais l'écosystème côté **vendeurs** est encore mince (6 MCP servers payants au registry en avril 2026), la **demande réelle** est faible (x402 ≈ 28k$/jour de volume on-chain réel hors tests), et les **standards d'identité agent** (DID, PoR) ne sont pas encore harmonisés. Construire est possible aujourd'hui ; bâtir un marketplace large nécessite d'accepter de servir un marché qui n'a pas encore atteint le tipping point.

---

## 2. État de l'art — protocoles 2026

| Protocole | Owner | Status avril 2026 | Adoption | Cas d'usage |
|---|---|---|---|---|
| **AP2** (Agent Payments Protocol) | Google → FIDO Alliance | v0.2.0, donné à FIDO | 100+ orgs (Mastercard, PayPal, Coinbase, Amex, Adyen…) | Mandates signés (Intent/Cart/Payment) + VC tokens, 3 déploiements publics |
| **ACP** (Agentic Commerce Protocol) | OpenAI + Stripe | Live, septembre 2025 | 25+ partenaires (Salesforce, Squarespace, PwC), Anthropic en early partner | Checkout API agent-to-merchant, intégré Stripe Agentic Commerce Suite |
| **x402** | Coinbase + Cloudflare + MS + Google + Mastercard → x402 Foundation | Production, HTTP 402 | 69k agents actifs, 165M tx, 50M$ volume cumulé. MAIS $28k/jour réel | Micropayments USDC sur Base/Solana, MCP-friendly |
| **MCP** (Model Context Protocol) | Anthropic | Standard de fait pour tool use | Massif côté tools, **6 serveurs payants** au registry | Pas de paiement natif — combinable avec x402/L402/Stripe |

**Lecture** : AP2 = standard institutionnel (cartes), ACP = standard merchant (e-commerce), x402 = standard machine-native (crypto/HTTP). Les trois coexisteront. MCP fournit le rail tools, pas le paiement.

---

## 3. Stack recommandée (build 2026)

| Couche | Choix | Justification |
|---|---|---|
| **Identité agent** | DID + Mandate humain (PoR) signé via AP2 Intent Mandate | Seul standard avec VC cryptographiques + gouvernance FIDO |
| **Paiement low-value (<5$)** | x402 sur Base (USDC) via facilitator Coinbase | Zéro frais protocole, latence HTTP-native, idéal per-token/per-call |
| **Paiement high-value + abonnements** | Stripe Agentic Commerce (ACP) | Cartes, dispute, KYC, comptable. Anthropic = early partner |
| **Tools/services vendus** | MCP servers exposant des endpoints `402 Payment Required` | Pattern x402 + MCP = standard émergent (gist Drake avril 2026) |
| **Wallet agent** | Coinbase Agentic Wallets (custody managed) | Caps de dépense par agent/session, audit log immuable, MPC |
| **Backend orchestration** | Node/TS + Vercel AI SDK + LangGraph (ou Claude Agent SDK) | Tool routing + budget tracking par agent |
| **Dashboard humain** | Next.js + Clerk Auth (humain) + table de mandates actifs | Un humain DOIT pouvoir révoquer un mandate à tout moment |

---

## 4. Use case minimal viable — Gradient Agents

**MVP** : un agent Gradient (ex : @seo) consomme un MCP server premium "SERP intelligence" facturé 0,01 USDC par requête via x402.

Flux :
1. Thomas signe un **Intent Mandate AP2** : "@seo peut dépenser jusqu'à 5$/projet sur outils SERP, plafond 50$/mois".
2. @seo, pendant un livrable, appelle le MCP server `serp-premium.example`. Réponse HTTP 402 + prix.
3. Wallet agent (Coinbase) vérifie le mandate, signe la transaction USDC, retry l'appel.
4. Audit log : input, output, prix, mandate_id, timestamp — visible dans dashboard Thomas.
5. À 80% du plafond mensuel : alerte. À 100% : refus automatique.

**Valeur démo** : une équipe de 21 agents qui s'auto-upgrade avec des knowledge bases, scrapers, et tools sectoriels sans intervention humaine pour chaque achat. Différenciation marketing forte ("agents qui investissent en eux-mêmes").

---

## 5. Risques techniques majeurs

| Risque | Sévérité | Mitigation |
|---|---|---|
| **Prompt injection → achat malveillant** | Critique | Mandates AP2 cap-bornés (montant + catégorie + durée), validation Zod côté wallet, jamais d'achat sans mandate explicite signé humain |
| **Hallucination du prix/service** | Élevé | Cart Mandate AP2 obligatoire avant paiement (le merchant signe le panier, l'agent re-signe = double consentement) |
| **Marché sellers vide** | Élevé | Démarrer en self-supply (Gradient vend ses propres MCP servers à ses propres agents) avant d'ouvrir |
| **Disputes/recours crypto** | Moyen | High-value sur ACP/Stripe (chargeback possible), x402 réservé aux montants <5$ acceptables en perte sèche |
| **Identité agent non standardisée** | Moyen | S'aligner sur AP2 Mandates (FIDO) — éviter les DID custom non interopérables |
| **Régulation (PSD3, MiCA, AMLD)** | Moyen | Handoff @legal — un agent qui paie = "instrument de paiement" potentiellement réglementé selon l'UE |

---

## 6. Ce qui n'est PAS encore mature (différer)

- **Disputes agent-to-agent automatisées** : aucun standard pour qu'un agent conteste une transaction. Aujourd'hui : escalade humain obligatoire.
- **Réputation cross-platform des agents** : pas de registre fiable. Un agent malveillant peut renaître sous un autre DID.
- **Pricing dynamique négocié agent-to-agent** : techniquement possible mais aucun protocole standardisé. Reste expérimental.
- **MCP marketplace généraliste payant** : 6 serveurs payants au registry MCP en avril 2026 = inventaire trop fin pour un marketplace pur.
- **Convergence AP2 / ACP / x402** : les 3 protocoles coexistent, pas de winner. Bâtir multi-rail OBLIGATOIRE, ce qui complexifie le build.
- **Insurance / SLA agentic** : aucun acteur ne couvre encore le risque d'achat agent erroné. À auto-assurer.

---

## Sources

- [Google Cloud — AP2 announcement](https://cloud.google.com/blog/products/ai-machine-learning/announcing-agents-to-payments-ap2-protocol)
- [Google blog — AP2 → FIDO Alliance](https://blog.google/products-and-platforms/platforms/google-pay/agent-payments-protocol-fido-alliance/)
- [AP2 Specification](https://ap2-protocol.org/specification/)
- [Stripe — Agentic Commerce Suite](https://stripe.com/blog/agentic-commerce-suite)
- [Stripe — NRF 2026 trends](https://stripe.com/blog/three-agentic-commerce-trends-nrf-2026)
- [ACP GitHub (OpenAI + Stripe)](https://github.com/agentic-commerce-protocol/agentic-commerce-protocol)
- [Coinbase — x402 launch](https://www.coinbase.com/developer-platform/discover/launches/x402)
- [Cloudflare — x402 Foundation](https://blog.cloudflare.com/x402/)
- [CoinDesk — x402 demand reality (mars 2026)](https://www.coindesk.com/markets/2026/03/11/coinbase-backed-ai-payments-protocol-wants-to-fix-micropayment-but-demand-is-just-not-there-yet)
- [CoinDesk — Pollak on agent payments (avril 2026)](https://www.coindesk.com/tech/2026/04/25/coinbase-s-jesse-pollak-says-ai-agents-are-the-next-big-wave-for-crypto-payments)
- [Coinbase — Agentic Wallets](https://www.coinbase.com/developer-platform/discover/launches/agentic-wallets)
- [MCP Server Monetization comparison — Drake gist (avril 2026)](https://gist.github.com/ThomsenDrake/bd5ef7f13329d6feb48e3945a23f413a)
- [Stripe MCP docs](https://docs.stripe.com/mcp)

---

**Handoff → Thomas (et @orchestrator si build décidé)**
- Fichier produit : `docs/reviews/ia-agent-marketplace-feasibility-2026-04-24.md`
- Décision attendue : GO POC self-supply (Gradient vend à ses agents) / GO marketplace ouvert / NO-GO / WAIT 6 mois
- Si GO POC : invoquer @product-manager pour specs MVP, @legal pour cadre PSD3/MiCA, @fullstack pour intégration Coinbase Agentic Wallets + 1 MCP server x402-enabled
- Points d'attention : marché vendeurs encore mince (différer marketplace pur), ne PAS construire sur un seul rail (AP2 + x402 + ACP en parallèle), mandates humains révocables OBLIGATOIRES
