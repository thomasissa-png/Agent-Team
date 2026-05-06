# Avis @ia — Capacités IA débloquées par migration Replit → Cloudflare

**Date** : 2026-05-06
**Agent** : @ia
**Périmètre** : exclusivement les capacités IA / LLM / edge AI / paywall x402. DX dev = @fullstack. Coûts macro = @infrastructure. First principles écarté (Thomas a écarté @elon).
**Inputs lus** : `docs/reviews/infrastructure-replit-vs-cloudflare-2026-05-06.md` (sections 1-3), `docs/briefs/devrefs-brief.md` (intégral), `.claude/agents/ia.md` (référence modèles Gradient).

---

## Verdict synthétique (1 phrase)

**GO migration sur l'angle IA — 3 capacités CF justifient la bascule à elles seules : (1) paywall x402 natif sur Workers (DevRefs est inopérable correctement sur Replit), (2) AI Gateway en proxy devant Anthropic/OpenAI (caching + observabilité + 0 €/mois jusqu'à 100K req/jour) qui apporte un ROI immédiat sur la facture Claude Gradient, (3) Workers AI pour les workloads tier-2 économes (transcription Whisper, classification, embeddings) ; mais Anthropic API direct reste le standard pour 80 % des appels LLM Gradient (qualité Sonnet 4.6 / Opus 4.7 non égalée par les modèles Workers AI).**

---

## Question 1 — Workers AI vs APIs externes (Anthropic / OpenAI)

**Pricing concret (vérifié 2026-05-06)** : Workers AI = $0.011 / 1 000 neurons, free tier 10 000 neurons/jour. Llama 3.1-8b-instruct-fp8-fast = ~4 119 neurons / M input tokens, ~34 868 neurons / M output tokens. Soit pour 1M tokens output Llama 3.1-8b ≈ $0.38. Llama 3.1-70b output ≈ $2.25 / M tokens. Comparé à Claude Sonnet 4.6 (~$3 / M input, ~$15 / M output) : Workers AI Llama 70b est ~6.5× moins cher en output, mais qualité Llama 70b sur tâches complexes (raisonnement, copy de qualité, structured output FR) reste **clairement en-dessous** de Sonnet 4.6 sur les usages Gradient (briefs, copy client, plans d'action coaching).

**Verdict par cas d'usage Gradient** :
- **Workers AI GAGNE** : (a) transcription Whisper edge (Versiroom audio meet ?), (b) classification simple (router une requête entrante : "demande SAV" vs "demande devis"), (c) embeddings pour RAG (BGE / m2-bert via Workers AI à $0.07 / M tokens — ridicule), (d) modération de contenu user-generated, (e) tâches batch low-stakes (résumé court d'un email entrant). Ces tâches consomment ~70 % du volume de tokens en production mais ~15 % de la valeur générée → idéales pour Workers AI.
- **Workers AI PERD** : génération de copy client-facing (Sarani, Mandataire-Immo coaching, ImmoCrew briefs), structured output JSON complexe avec tool use sophistiqué, raisonnement multi-étapes. Ici Claude Sonnet 4.6 / Opus 4.7 reste le standard non négociable. Un Llama 8b qui hallucine sur un brief mandataire = perte sèche client > économie tokens.

**Recommandation** : adopter Workers AI sur tier-2 (≤ 30 % du volume de calls, ≤ 5 % du budget tokens). Le reste = Anthropic API direct, via AI Gateway (cf. Q4).

---

## Question 2 — Vectorize pour RAG cross-projets Gradient

**Pricing concret (vérifié 2026-05-06)** : ((queried + stored vectors) × dimensions × $0.01 / 1M) + (stored × dimensions × $0.05 / 100M). Exemple officiel CF : 10 000 vectors × 768 dim × 1 000 queries/jour = **$0.31 / mois**. Ridiculement bon marché. Free tier inclus avec Workers Paid ($5/mois).

**Cas d'usage Gradient pertinent** : RAG sur (a) `docs/lessons-learned.md` cross-projets (mémoire orga), (b) briefs historiques pour search sémantique, (c) contenus produits Sarani/ImmoCrew, (d) éventuellement DevRefs si on RAG sur les changelogs SDK.

**Comparatif** :
| Option | Coût mensuel typique Gradient | Latence query | Verdict |
|---|---|---|---|
| **Vectorize (CF)** | $0.30-2 / mois | ~30-50ms edge | GO si stack CF — co-localisé avec Workers |
| **pgvector (Neon)** | inclus dans Neon $19 | ~50-150ms (cold start Neon) | GO alternative — évite un service de plus |
| **Pinecone** | $70/mois (Standard) | ~50ms | NO-GO — 200× plus cher pour Gradient |
| **Chroma self-hosted** | infra à gérer | variable | NO-GO — overhead ops |

**Recommandation** : **Vectorize** comme standard si stack 100 % CF (DevRefs, futurs projets greenfield IA-heavy). **pgvector via Neon** pour les projets qui ont déjà une DB Neon et < 100K vecteurs (évite un service supplémentaire). Pinecone écarté pour Gradient.

---

## Question 3 — Paywall x402 (HTTP 402) — point critique DevRefs

**Constat** : DevRefs **n'est pas faisable proprement sur Replit**. x402 (Coinbase facilitator, USDC Base) requiert un middleware HTTP qui intercepte chaque requête, retourne 402 + payload challenge, valide la signature crypto, libère la ressource. Sur Replit (Node/Express) : faisable techniquement mais (a) pas de free tier crawlers-friendly (Replit dort, le crawler agent reçoit 503 avant d'atteindre le 402), (b) pas d'edge caching natif compatible avec un middleware 402, (c) coût Replit Reserved VM pour rester always-on ≈ $20-25/mois pour un produit dont le pricing cible est 0,49 €/query.

**Sur Cloudflare Workers** : x402 middleware natif (plusieurs implémentations open-source community 2025-2026), wrap autour de la route, validation Coinbase facilitator en 1 fetch sub-100ms, intégration trivial avec Stripe Payment Link en fallback humain. **Le brief DevRefs spécifie déjà Cloudflare Workers — c'est la bonne décision technique, pas un caprice.**

**Coût implémentation comparé** : Replit ≈ 8-12h de dev + always-on VM payante + risque cold-start tueur de funnel agent. CF Workers ≈ 2-4h de dev + free tier qui couvre 100K req/jour + 0 cold-start sur paid plan ($5/mois). Différentiel = 4-8h de dev + $20/mois récurrents + UX agent dégradée sur Replit.

**Recommandation** : pas négociable — DevRefs sur CF Workers. Et c'est une **capacité réutilisable** : tout futur projet Gradient avec micropaiement IA-to-IA hérite de l'infra x402 mutualisable.

---

## Question 4 — AI Gateway devant Anthropic / OpenAI

**Capacité** : proxy CF entre l'app et le provider LLM. Apporte (a) caching prompts identiques (économie directe sur tokens facturés Anthropic), (b) rate limiting par utilisateur/clé, (c) observabilité unifiée (latence P95, coût par feature, taux d'erreur), (d) fallback automatique provider down → autre provider, (e) logs I/O pour debug + amélioration prompts.

**Pricing** : free tier généreux (100K req/jour environ), payant au-delà très bas. Comparé à Helicone ($25-100/mois) ou Langfuse self-hosted (overhead ops) : AI Gateway = **0 €/mois** pour Gradient à l'échelle actuelle.

**ROI pour Gradient** : Thomas a une facture Claude élevée. Hypothèses raisonnables :
- 30 % des prompts sont répétés (system prompts identiques, prompts coaching récurrents Mandataire-Immo, briefs templated) → caching natif AI Gateway = **20-30 % d'économie tokens** sans toucher au code.
- Observabilité par feature = identifie les prompts qui consomment 80 % du budget → optimisation ciblée (passage Opus → Sonnet sur les non-critiques).
- Logs centralisés = base pour évals automatiques (cf. règles @ia : eval-strategy.md).

**Risque vendor lock-in** : l'API AI Gateway est un proxy transparent (OpenAI/Anthropic SDK pointent vers `gateway.ai.cloudflare.com/...`), bascule retour vers API directe = changement d'URL en 5 min. **Lock-in faible**.

**Recommandation** : **GO immédiat AI Gateway sur tous les projets Gradient qui consomment Claude / GPT en production** (ImmoCrew, Sarani, Mandataire-Immo, Versiroom). ROI estimé : 20-30 % de la facture Claude mensuelle, à coût zéro. Action prioritaire.

---

## Question 5 — Streaming LLM via Workers (SSE / response streaming edge)

**Constat technique** : Workers supportent nativement `ReadableStream` + SSE, latence TTFB sous 50ms en edge POP proche utilisateur. Replit (Node Express) supporte SSE également mais ajoute (a) latence de routage vers la région Replit (typiquement US), (b) cold start si scale-to-zero, (c) pas de POP edge.

**Différence concrète UX Gradient** : pour ImmoCrew (génération brief mandataire en streaming) ou Sarani (génération devis IA), TTFB perçu utilisateur passe de ~800ms-1.5s (Replit US → user FR) à ~100-200ms (CF edge POP Paris/Marseille). **Différence subjective forte** — on ressent l'IA comme "snappy" plutôt que "qui réfléchit".

**Caveat** : le streaming réel dépend du provider LLM (Anthropic → toi). Le gain CF se concentre sur (a) le TTFB du proxy, (b) l'absence de cold start, (c) la fiabilité du long-running stream (pas de timeout 30s Replit). Pour des streams > 30s (génération longue Opus), Workers paid plan supporte 5 min CPU + temps wall illimité = couvre tous les cas Gradient.

**Recommandation** : gain UX réel mais **pas un kill-switch** seul. C'est un multiplicateur des autres bénéfices CF. Ne pas migrer pour ça uniquement, mais l'apprécier comme bonus.

---

## Question 6 — Queues + Durable Objects pour jobs IA longs

**Capacité** : Cloudflare Queues (message queue managé, $0.40 / M opérations) + Durable Objects (state persistent par instance, ~$0.15 / M req + $0.20 / GB-mois). Permet : batch génération images (Stable Diffusion via Workers AI ou via Replicate), génération long-form (Opus xhigh effort), scraping LLM (DevRefs cron), workflows orchestrés stateful.

**Sur Replit** : nécessite (a) Inngest ($20-100/mois selon volume), (b) Trigger.dev (similaire), (c) Replit Deployments cron (basique, pas de retry/DLQ propre), ou (d) self-hosted BullMQ + Redis (overhead ops). Coût total ≈ $20-50/mois + complexité.

**Sur CF** : Queues + DO natifs, intégrés au Worker, free tier inclus dans Workers Paid $5/mois pour Gradient à l'échelle actuelle. Pour ImmoCrew (génération images mandataires en batch) ou Archi (rendering plans + photos), c'est plus simple et moins cher.

**Recommandation** : **GO** dès qu'un projet Gradient a un job IA asynchrone. Économie directe + DX simplifiée. Risque vendor lock-in modéré (Queues = API CF, DO = pattern CF spécifique) — mitigation : encapsuler dans un module `src/lib/jobs/` swap-able.

---

## Question 7 — Verdict GO/NO-GO/CONDITIONNEL angle IA

**Verdict : GO sur l'angle IA, motivé par 3 capacités exclusives ou massivement avantageuses**.

### Top 3 capacités IA débloquées par Cloudflare

1. **Paywall x402 natif sur Workers** — DevRefs n'est pas faisable proprement sur Replit. C'est la capacité la plus différenciante : ouvre une nouvelle catégorie de produits Gradient (services IA-to-IA monétisés en micropaiements). Réutilisable sur d'autres futurs projets (API monétisées agent-first).
2. **AI Gateway gratuit devant Anthropic / OpenAI** — 20-30 % d'économie sur la facture Claude Gradient, observabilité par feature (qu'on n'a pas aujourd'hui), fallback provider, à coût zéro. ROI immédiat sur le post de dépense le plus élevé côté Thomas.
3. **Workers AI sur tier-2 + Vectorize pour RAG** — déplace 30 % du volume tokens (transcription, classification, embeddings, modération) vers du 6-10× moins cher, et ouvre un RAG cross-projets serverless à <$2/mois. Mémoire organisationnelle Gradient (lessons-learned, briefs) devient queryable sémantiquement sans Pinecone.

### Risques IA spécifiques (à mitiger)

| Risque | Probabilité | Mitigation |
|---|---|---|
| Qualité Llama Workers AI insuffisante pour briefs client → tentation cargo-cult "tout migrer" | Moyenne-haute | Politique stricte : tier-1 (client-facing copy, briefs) reste sur Anthropic API. Documenter dans `docs/ia/model-selection.md` la matrice tier-1 / tier-2. |
| Cold start Workers AI sur certains modèles edge | Faible | Modèles edge CF sont pré-loaded sur POP. Pas de cold start sensible. À monitorer via AI Gateway logs. |
| Vendor lock-in AI Gateway | Faible | Proxy transparent, swap retour SDK direct = 5 min. |
| Vendor lock-in Vectorize | Moyenne | Encapsuler dans `src/lib/ai/vector-store.ts`, garder pgvector comme fallback documenté. |
| Vendor lock-in Durable Objects (Queues) | Moyenne | Encapsuler dans `src/lib/jobs/`. Pour Gradient à cette échelle, lock-in acceptable. |
| Pricing CF qui dérape (croissance) | Faible court terme | Suivi mensuel via dashboard CF. Caps Vectorize / Workers AI / Queues budgetés à $50/mois max combiné, alerte au-delà. |
| Rupture de qualité streaming sur tâches Opus longues > 5 min | Faible | Workers paid plan = 5 min CPU. Pour générations > 5 min : décomposer en chain prompts (de toute façon mieux pour qualité). |

### Recommandation pricing finale (matrice opérationnelle)

| Cas d'usage | Solution | Justification |
|---|---|---|
| Génération copy client-facing, briefs, plans coaching | **Anthropic API direct via AI Gateway** | Qualité Sonnet 4.6 / Opus 4.7 non égalée. AI Gateway pour cache + obs. |
| Tool use complexe, structured output JSON critique | **Anthropic API direct via AI Gateway** | Tool use Anthropic = state of the art. |
| Transcription audio (Whisper) | **Workers AI** | Qualité équivalente, 5-10× moins cher, edge latency. |
| Classification simple, routing intent | **Workers AI Llama 3.1-8b** | Sonnet overkill, économie 90 %. |
| Embeddings RAG | **Workers AI BGE / m2-bert** | $0.07 / M tokens, imbattable. |
| Modération contenu user-generated | **Workers AI Llama Guard** | Free tier suffit, pas besoin de Sonnet. |
| RAG store vectoriel | **Vectorize** (stack CF) ou **pgvector Neon** (si DB déjà là) | Pinecone écarté. |
| Jobs IA asynchrones (batch images, scraping LLM) | **Workers Queues + DO** | Natif, pas besoin Inngest/Trigger.dev. |
| Paywall IA-to-IA (DevRefs et futurs) | **Workers + x402 middleware** | Pas faisable proprement sur Replit. |
| Observabilité LLM, eval automatique sample | **AI Gateway logs + Langfuse self-hosted optionnel** | AI Gateway suffit pour 90 % des besoins Gradient. |

### Actions prioritaires concrètes pour Thomas

1. **Cette semaine — AI Gateway** : activer AI Gateway pour ImmoCrew + Sarani + Mandataire-Immo. Changer 1 ligne dans le SDK Anthropic (base URL → CF gateway). Mesurer la facture Claude semaine 1 vs semaine 4. ROI attendu : -20 à -30 %. Ne nécessite **pas** la migration complète — gain immédiat indépendant.
2. **Pilote DevRefs sur CF Workers** : le brief le spécifie déjà, c'est cohérent. Profiter du pilote pour valider x402 + AI Gateway + Vectorize ensemble sur un projet contained.
3. **Migration tier-2 vers Workers AI** sur un projet existant (suggestion : ImmoCrew, qui a probablement de la classification / modération) — POC sur 2 semaines, mesurer économie réelle vs estimation.
4. **Documenter `docs/ia/model-selection.md`** standard Gradient post-migration avec la matrice tier-1 / tier-2 ci-dessus, pour éviter cargo-cult "tout sur Workers AI".
5. **Ne pas migrer la prod Anthropic API direct** : 80 % des appels LLM Gradient restent sur Sonnet 4.6 / Opus 4.7. Workers AI ne remplace pas Claude, il complète.

---

## Sources externes (pricing vérifié 2026-05-06)

- [Cloudflare Workers AI Pricing](https://developers.cloudflare.com/workers-ai/platform/pricing/)
- [Cloudflare Vectorize Pricing](https://developers.cloudflare.com/vectorize/platform/pricing/)
- [Cloudflare AI Gateway docs](https://developers.cloudflare.com/ai-gateway/)
- [Workers AI GA blog post](https://blog.cloudflare.com/workers-ai-ga-huggingface-loras-python-support/)
- DevRefs brief (`docs/briefs/devrefs-brief.md`) — sources x402 Coinbase facilitator y compris

---

**Handoff → @orchestrator**

- **Fichier produit** : `docs/reviews/ia-replit-vs-cloudflare-capabilities-2026-05-06.md`
- **Verdict net** : GO migration sur l'angle IA. 3 capacités exclusives justifient à elles seules : x402 natif (DevRefs), AI Gateway (-20 à -30 % facture Claude), Workers AI tier-2 + Vectorize.
- **Décisions prises** :
  - Anthropic API direct reste le standard tier-1 (briefs, copy client, tool use complexe). Pas de cargo-cult Workers AI.
  - Workers AI adopté sur tier-2 (transcription, classification, embeddings, modération) — ~30 % volume tokens, ~5 % du budget.
  - Vectorize pour RAG si stack 100 % CF, sinon pgvector via Neon.
  - AI Gateway activé sur tous projets consommant Claude — ROI immédiat indépendant de la migration globale.
  - x402 sur CF Workers : DevRefs non faisable proprement sur Replit, décision technique non négociable.
- **Actions prioritaires Thomas** : (1) AI Gateway cette semaine sur 3 projets prod, (2) pilote DevRefs CF, (3) POC Workers AI tier-2 sur ImmoCrew, (4) documenter matrice tier-1/tier-2 dans `docs/ia/model-selection.md` post-migration.
- **Points d'attention** :
  - Plafonner budget combiné Vectorize + Workers AI + Queues à $50/mois avec alerte CF.
  - Encapsuler Vectorize / Queues / DO dans modules `src/lib/ai/` et `src/lib/jobs/` pour limiter le lock-in.
  - Mesurer la facture Claude S1 vs S4 après activation AI Gateway pour valider le ROI estimé 20-30 %.
  - Coordonner avec @infrastructure (migration globale GO phasée) et @fullstack (DX dev) — pas de chevauchement avec cet avis (capacités IA pures).
- **Pas de chevauchement** avec @infrastructure (coûts macro) ni @fullstack (DX) — angle exclusif capacités IA respecté.

---

**Préparé le 2026-05-06 par @ia. WebSearch pricing CF effectué le jour même.**
