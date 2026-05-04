# Brief projet — DevRefs (working name)

> **Préparé pour @orchestrator**. Ce brief sert de base pour `project-context.md` du nouveau repo. Thomas valide/ajuste avant lancement, puis colle dans le projet et lance le prompt "Lancer le projet de A à Z" ou "Définir mon projet".

---

## Identité

- **Nom du projet** : DevRefs (working name — Thomas tranche le naming définitif. Alternatives : FreshRefs, AgentDevRefs, RefStream, AgentSource)
- **Secteur** : Outil dev / Référentiel technique pour agents IA (B2A — Business to Agent)
- **Stade** : Idée → V1 complète → Production (cycle Gradient standard, pas de "MVP")
- **Type** : Funnel (paywall x402 + Stripe), pas vitrine. Variable 1c orchestrator = FUNNEL confirmé.

## Cible

- **Persona principal** : **Un agent IA autonome** qui code, orchestre des LLM ou consomme des APIs (Claude Code, Cursor agent, AgentKit, Mastra, MCP-host). Caractéristiques : (a) effectue des `WebSearch` ou crawl pour valider des données techniques avant action, (b) supporte ou apprend à supporter HTTP 402 / x402 pour micro-paiements autonomes, (c) optimise pour anti-hallucination plus que pour économie de tokens (un retry coûte plus que 0.49€).
- **Persona secondaire** : **Le développeur humain qui supervise l'agent**. Achète l'abonnement "unlimited 4.99€/jour" en Stripe Payment Link quand l'agent paie trop souvent en x402.
- **Problème principal** : les agents qui codent en 2026 hallucinent à 15% sur des APIs/SDKs ([arxiv 2407.09726](https://arxiv.org/abs/2407.09726v1)) car (a) leur cutoff training est dépassé, (b) les prix LLM API bougent par semaine, (c) les schemas OpenAPI changent sans notification.
- **Alternative actuelle** : `WebSearch` Google + scrape de 5 sites différents → réponse incomplète + 30s+ + plus de tokens. OU sites SaaS lourds (pricepertoken.com, costgoat.com) pas conçus pour consommation agent.

## Positionnement

- **Promesse unique** : **Le référentiel technique fresh que ton agent achète à 0,49 € pour ne pas se tromper**. JSON natif x402, JSON-LD `dateModified` quotidien, llms.txt explicite, page < 50 KB.
- **Ton de marque** : Direct, technique, agent-first. Le copy parle aux deux audiences (agent qui crawle ET humain qui supervise) sans condescendance pour aucun des deux.
- **3 mots** : Fresh — Atomic — Verifiable
- **Concurrent principal** : pricepertoken.com, costgoat.com, devtk.ai (LLM pricing) — tous statiques, lourds, pas optimisés agent. Différenciation = endpoint x402-natif + signal fraîcheur structuré + page atomique.

## Objectifs

- **Objectif principal à 6 mois** : revenu net mensuel stable >= 600 € (= 20 €/jour Thomas) sur le bundle LLM Pricing + SDK Status, payé majoritairement en x402 (USDC Base). Démontrer qu'un agent achète en autonomie un service IA-to-IA en France.
- **KPI North Star** : **Revenu net mensuel x402 + Stripe** (cible 600 €/mois). Mesuré sur dashboard Cloudflare Analytics + Coinbase facilitator + Stripe.
- **KPI secondaires** : (a) nombre de paiements x402 autonomes/jour, (b) ratio crawl→paiement, (c) nombre de citations Perplexity/Claude/ChatGPT sur les pages de référence.

## Stack technique

- **Frontend** : HTML statique + 1 page TypeScript Cloudflare Pages (single page application légère, < 50 KB total avec CSS minimal)
- **Backend** : Cloudflare Workers (1 Worker pour endpoints API, 1 Worker cron pour scrape sources)
- **Base de données** : Cloudflare KV (cache JSON pour pricing et SDK status, TTL 6h-24h selon endpoint)
- **Hébergement** : Cloudflare Pages (gratuit jusqu'à 500 builds/mois) + Workers (free tier 100 000 req/jour)
- **IA utilisée** : aucune dans le runtime du produit. Génération de contenu humain et templates uniquement.
- **Paiement** : x402 facilitator Coinbase (USDC Base, free tier 1000 tx/mois, fees ~0,1%) en primaire. Stripe Payment Link en fallback humain (4,99 €/jour unlimited).
- **Monitoring** : Cloudflare Analytics (gratuit) + Coinbase facilitator dashboard + Stripe dashboard.

## Modèle économique

- **Type** : Pay-per-query micro-paiement (x402) + abonnement journalier humain (Stripe)
- **Pricing** : 0,49 €/query par endpoint · 4,99 €/jour unlimited cross-endpoints (JWT 24h signé)
- **Pays** : International (USDC Base = sans frontière). Domiciliation entreprise FR si besoin (Auto-entreprise, BNC Crypto via Pappers + déclaration impôt).
- **Données sensibles** : Non. Aucune donnée personnelle utilisateur stockée. Wallet x402 anonyme. Stripe pour humains uniquement (PCI géré par Stripe).

## Budget & Contraintes

- **Budget infra mensuel** : 0 € (free tier Cloudflare + free tier Coinbase x402 + Stripe à la transaction)
- **Budget acquisition mensuel** : 0 € (acquisition 100 % organique : SEO + GEO + IndexNow + 2 posts Dev.to + 1 post Reddit)
- **Timeline** : V1 complète en **1 weekend** (samedi-dimanche, ~13-15h estimées) + 5 jours de mesure et tuning. Production stable visée semaine 4.
- **Contraintes spécifiques** :
  - Légalité paiement : x402 USDC = paiement crypto, déclaration BNC obligatoire France. Handoff @legal en Phase 5.
  - TOS scraping : sources officielles uniquement (npm registry, GitHub releases publiques, Anthropic/OpenAI/Google/Mistral pricing pages publiques). **NO-GO Crunchbase / SimilarWeb / autres APIs avec TOS restrictives.**
  - Anti-fraude : watermark invisible sur les payloads JSON + rate-limit par wallet + token signé HMAC traçable.

## Notes libres

### Brief stratégique (issu Round 1+2 audits @elon × @growth × @ia)

**Concept validé à 88 % de certitude consensus** sur 4 agents :
- Bundle 2-en-1 : `/api/llm-prices` (lead, volume haut) + `/api/sdk-status` (upsell, niche défendable 6-12 mois)
- Page commune `/api/dev-refs` avec landing publique `/llm-prices` SEO/GEO
- Différenciation vs concurrents statiques : x402-natif + JSON-LD `dateModified` + llms.txt + page atomique

**Standard qualité non négociable (préférences fondateur)** :
- Pas de "MVP" — V1 complète qui marche, ou rien
- 9-10/10 minimum sur chaque livrable (pas 7-8)
- Automatisation par défaut : tout contenu (pricing, sdk status) regénéré par cron, zero intervention manuelle après J1
- Cohérence obsessionnelle : prix affichés sur la landing == prix dans `/api/llm-prices` JSON (cron unique, source unique)
- Anti-vendor lock-in : Cloudflare Pages + Workers (open standards), pas Vercel proprio. USDC Base + Stripe (pas un seul provider).
- Validation par preuve : screenshots des pages live + payloads JSON réels + log de 3 paiements réussis avant clôture V1.
- Zéro fausse promesse : on ne promet RIEN sur la landing qui n'est pas implémenté. Si l'agent voit "12 modèles couverts", il y en a 12, pas 8.

**Bonus fraîcheur** : Opus 4.7 inflate son tokenizer de +35 % silencieusement ([source Finout](https://www.finout.io/blog/claude-opus-4.7-pricing-the-real-cost-story-behind-the-unchanged-price-tag)) — à intégrer dans le payload pricing comme champ `effective_cost_factor`. Différenciation immédiate vs pricepertoken.

### Plan d'exécution (V1 complète, calibré IA pas humain)

**Phase 0 — Fondations (4h, sam matin)** : @creative-strategy + @copywriter + @design en parallèle.
- Brand platform compact (3 mots, ton, voice agent-first)
- Copy landing publique `/llm-prices` (titre, sous-titre, CTA, FAQ JSON-LD)
- Design tokens minimaliste (mono noir/jaune ou similar — palette à trancher)

**Phase 1 — V1 complète (samedi, 8h)** : @fullstack en mode pipeline serré.
- Cloudflare Worker `/api/llm-prices` avec scrape officiel 12 modèles + KV cache + cron 6h
- Cloudflare Worker `/api/sdk-status` avec npm + GitHub releases + parser CHANGELOG sur 50 SDKs
- Middleware x402 sur les 2 endpoints (Coinbase facilitator)
- Stripe Payment Link 4,99 €/jour + JWT validation
- Page HTML statique `/llm-prices` avec JSON-LD `Dataset` + `dateModified` + llms.txt + sitemap.xml + robots.txt explicite

**Phase 2 — Acquisition 24h (dimanche matin, 3h)** : @growth + @seo en parallèle.
- IndexNow push Bing après chaque mise à jour
- 2 posts Dev.to via API REST avec mention URL endpoints
- 1 post Reddit r/ClaudeAI ou r/LocalLLaMA
- Validation : `curl perplexity.ai/search?q=llm+pricing+2026` après 24h

**Phase 3 — QA + Reviewer (dimanche aprèm, 2h)** : @qa + @reviewer.
- Test live avec 3 agents réels : Claude Code (MCP server x402), Cursor agent, AgentKit
- Verdict gates : 32/32 G1-G32 PASS + GP1-GP10 (testeur-persona-agent) + GC1-GC10 (testeur-client-du-persona = humain qui paye unlimited)
- Walkthrough post-code reviewer obligatoire
- Convergence protocol si score < 9/10

**Phase 4 — Mesure 5 jours** : @data-analyst + @growth.
- Dashboard live (CF Analytics + Coinbase + Stripe consolidé en 1 page)
- Plan d'action selon résultats J7 :
  - Si < 5 ventes : diagnostic SEO/GEO (pas le produit)
  - Si 5-15 ventes : bump 0,49 € → 0,99 € + ajout 5 keywords secondaires
  - Si > 15 ventes : push agressif SDK Status upsell + élargir à 100 SDKs

**Phase 5 — Conformité (semaine 2)** : @legal.
- Déclaration BNC crypto auto-entrepreneur si revenus dépassent 200 €
- CGV + mentions légales sur la landing
- Politique confidentialité (très courte : aucune donnée perso stockée)

### Recommandation d'agents spécialisés projet

**À créer via @agent-factory si pertinent** :
- `@testeur-agent-ia` : simule un vrai agent IA (Claude Code/Cursor/AgentKit) qui crawle, parse `llms.txt`, détecte `HTTP 402`, exécute le paiement x402, valide le payload reçu. Différent du testeur-persona standard qui simule un humain.
- `@testeur-developpeur-superviseur` : simule l'humain qui supervise un agent et achète Stripe Link 4,99 €/jour. Vérifie que le funnel humain marche (landing → CTA → Stripe → JWT).

### Risques identifiés et mitigations

| Risque | Probabilité | Mitigation |
|---|---|---|
| Volume 8-15K rech/mois est [HYPOTHÈSE] non-mesurée | Moyenne | KPI J7 = test binaire. Si 0 crawl, pivot mot-clé. |
| Concurrence pricepertoken/costgoat | Confirmée forte | Différenciation stricte : x402-natif + atomique + dateModified. Refuser la course aux features. |
| Demande micropaiement agent encore embryonnaire (Coindesk mars 2026 = 28k$/jour réel x402) | Moyenne | Stripe Link humain en fallback assure un revenu même si agents pas mature. |
| Régulation crypto FR (PSD3, MiCA) | Faible court terme | Handoff @legal Phase 5. Auto-entreprise + déclaration BNC. |
| Anthropic / OpenAI lance le même produit gratuit | Faible | Niche trop petite pour eux. On a 12-18 mois d'avance estimés. |

## Historique des interventions agents

(Vide à l'initialisation — sera rempli par @orchestrator au cours du projet)

| Agent | Date | Fichiers | Décisions clés | Pourquoi |
|---|---|---|---|---|

---

## Comment Thomas lance ce projet

1. Créer un nouveau repo (ex: `devrefs` ou autre nom retenu)
2. `bash install.sh` (script Gradient Agents installé)
3. Coller ce brief dans `project-context.md` à la racine, ajuster nom + persona si besoin
4. Lancer dans Claude Code : prompt **"Lancer le projet de A à Z"** (ou autopilot complet) → @orchestrator prend le relais
5. Phase 0b : @orchestrator vérifie les caps anti-dérive systématiques (cmd n°8) puis lance @agent-factory pour créer les 2 agents custom recommandés (testeur-agent-ia + testeur-developpeur-superviseur)
6. Le projet roule en autopilot avec validation utilisateur entre les phases majeures

---

**Préparé le 2026-04-24 par @orchestrator. Source consensus 88 % : Round 1 (@elon + @growth + @ia) + Round 2 (@reviewer). Brief 144 lignes.**
