# Analyse de couverture Growth — Bibliothèque de 39 prompts
**Agent** : @growth
**Date** : 2026-03-22
**Scope** : Audit des 39 prompts sous l'angle acquisition, rétention, monétisation, funnel AARRR, PLG, boucles virales, unit economics

---

## 1. Inventaire des prompts à dimension growth

Sur 39 prompts, voici ceux qui touchent directement ou indirectement au domaine growth :

| Prompt | Phase | Agents | Dimension growth couverte |
|---|---|---|---|
| KPIs & tracking plan | Phase 0 | data-analyst | Définition KPIs AARRR, North Star Metric |
| Vision produit & roadmap | Phase 0 | product-manager | Objectifs, modèle économique |
| Intégrer le paiement Stripe | Phase 2 | fullstack, legal, infra | Revenue : infrastructure monétisation |
| Stratégie SEO technique & éditoriale | Phase 3 | seo | Acquisition organique |
| Visibilité sur les IA génératives (GEO) | Phase 3 | geo | Acquisition via LLM |
| SEO + GEO combinés | Phase 3 | seo, geo | Acquisition organique combinée |
| **Stratégie d'acquisition complète** | Phase 4 | growth, social, copywriter | Acquisition multi-canal, CAC/LTV |
| **Stratégie social media** | Phase 4 | social, copywriter | Acquisition organique réseaux |
| **Emails onboarding & conversion** | Phase 4 | copywriter, growth | Activation + Rétention early |
| **Auditer le funnel existant** | Phase 4 | growth, data-analyst | AARRR diagnostic, cohortes |
| Optimiser l'onboarding | Raccourcis | ux, copywriter, data-analyst | Activation, time-to-value |
| Audit UX & conversion | Phase 5 | ux, data-analyst | Conversion, rétention |

**Total : 12 prompts sur 39 ont une dimension growth.** Les 4 prompts estampillés @growth représentent ~10% de la bibliothèque.

---

## 2. Couverture du funnel AARRR — état des lieux

### Acquisition — Couverture : 60%

Ce qui existe :
- Stratégie d'acquisition complète (canaux, CAC/LTV, modélisation)
- SEO et GEO comme canaux organiques dédiés
- Social media avec calendrier éditorial

Ce qui manque :
- Aucun prompt dédié paid acquisition (Google Ads, Meta Ads) — le prompt "acquisition complète" mentionne les canaux mais ne produit pas de plan paid opérationnel
- Aucun prompt outreach / cold email / partenariats
- Aucun prompt pour aller de 1 000 à 10 000 utilisateurs (scale des canaux qui marchent)
- Pas de prompt Product Hunt / launch strategy pour le moment 0→1

### Activation — Couverture : 70%

Ce qui existe :
- "Optimiser l'onboarding" (time-to-value, microcopy)
- "Emails onboarding & conversion" (séquence J+0 à J+14)
- "Parcours utilisateur & wireframes" (flux d'onboarding)

Ce qui manque :
- Aucun prompt dédié PLG (Product-Led Growth) : setup du free tier, feature gating, triggers d'upgrade
- Pas de prompt "activation checklist" mesurant le moment où l'utilisateur a compris la valeur
- Pas de prompt A/B testing pour optimiser les taux d'activation

### Rétention — Couverture : 30%

C'est le trou le plus critique. Ce qui existe :
- La séquence email J+14 "réengagement" dans le prompt onboarding/conversion
- Le dashboard cohortes dans "Audit UX & conversion"

Ce qui manque :
- Aucun prompt dédié rétention / churn reduction
- Pas de prompt analyse de cohortes comportementale
- Pas de prompt win-back campaign
- Pas de prompt alertes churn précoces (usage signals)
- Pas de prompt customer success playbook
- Pas de prompt segmentation comportementale (utilisateurs à risque vs champions)

### Referral — Couverture : 5%

Pratiquement absent. Ce qui existe :
- Zéro prompt dédié referral / viral loops

Ce qui manque :
- Aucun prompt programme de referral (mécanique, incentives, tracking)
- Pas de prompt boucles virales produit (partage natif, invite flows)
- Pas de prompt Net Promoter Score / satisfaction → conversion referral
- Pas de prompt ambassadeurs / communauté

### Revenue — Couverture : 40%

Ce qui existe :
- "Intégrer le paiement Stripe" (infrastructure)
- La roadmap inclut le modèle économique

Ce qui manque :
- Aucun prompt pricing strategy (benchmarking concurrents, willingness-to-pay, tiers)
- Pas de prompt upsell / expansion revenue
- Pas de prompt upgrade triggers (usage signals → proposition d'upgrade)
- Pas de prompt analyse payback period / unit economics détaillés

---

## 3. Trou critique : l'intervalle 0→1000 et 1000→10 000 utilisateurs

La bibliothèque actuelle couvre bien la construction du produit (phases 0→2) et la visibilité organique (phase 3). Mais elle laisse deux intervalles entièrement sans support :

**Intervalle 0→1000 utilisateurs (validation demand-gen)**
Il n'existe aucun prompt pour :
- Tester la demande avant de construire (fake door test, landing page waitlist)
- Orchestrer un lancement Product Hunt / BetaList / Hacker News
- Structurer les premiers entretiens utilisateurs pour identifier le channel-fit
- Construire une liste d'attente et la convertir en premiers payants

**Intervalle 1000→10 000 utilisateurs (scale sélectif)**
Il n'existe aucun prompt pour :
- Identifier quel canal a prouvé son ROI et mérite d'être scalé
- Modéliser le payback period par canal avant d'augmenter le budget
- Passer d'une croissance organique à une croissance paid maîtrisée
- Structurer les premières campagnes paid avec des hypothèses de CAC cible

---

## 4. Trou critique : espace entre "lancer le produit" et "product-market fit"

La bibliothèque saute directement de "produit déployé" (phase 2) à "acquérir des utilisateurs" (phase 4) sans traiter la question centrale : comment sait-on qu'on a un product-market fit ?

Il manque :
- Un prompt pour mesurer le PMF (sondage Sean Ellis, retention curve, engagement depth)
- Un prompt pour itérer sur le positionnement en fonction des signaux early users
- Un prompt pour construire la boucle feedback → produit → rétention → acquisition

Sans PMF validé, scaler l'acquisition revient à remplir un seau percé.

---

## 5. Prompts recommandés à ajouter (10 prompts)

### Prompt 1 — Tester la demande avant de lancer
**Titre** : Valider la demande (fake door test / waitlist)
**Agents** : @growth, @copywriter, @ux
**Phase** : Phase 0 (avant développement)
**Description** : Crée une landing page de test avec CTA d'inscription, mesure le taux de conversion comme proxy de la demande réelle. Produit : landing page minimaliste + objectif de conversion + critère de go/no-go chiffré. Documente le résultat dans project-context.md avant d'engager le développement.

---

### Prompt 2 — Stratégie de lancement (0→premiers utilisateurs)
**Titre** : Plan de lancement Product Hunt / Hacker News / communautés
**Agents** : @growth, @copywriter, @social
**Phase** : Phase 4 (pré-lancement)
**Description** : Construit le plan de lancement pour les 48 premières heures : choix de la plateforme (Product Hunt, HN Show, BetaList, Reddit communities), préparation des assets, orchestration de la day-1 social proof, objectif de trafic et de sign-ups J0. Livrable : docs/growth/launch-plan.md

---

### Prompt 3 — Programme de referral
**Titre** : Concevoir un programme de referral
**Agents** : @growth, @product-manager, @copywriter
**Phase** : Phase 4
**Description** : Conçoit la mécanique de referral : double-sided vs one-sided, incentive (crédit, cash, feature), flow technique (lien unique, tracking, attribution), copy des emails d'invitation, KPIs (viral coefficient K, payback). Livrable : docs/growth/referral-program-specs.md

---

### Prompt 4 — Pricing strategy
**Titre** : Définir la stratégie de pricing
**Agents** : @growth, @product-manager
**Phase** : Phase 0 ou Phase 4
**Description** : Benchmark des prix de 3-5 concurrents directs via WebSearch, estimation de la willingness-to-pay par persona, recommandation sur la structure des tiers (Free/Pro/Business), feature gating, prix d'entrée. Inclut la modélisation de l'impact sur le MRR selon le taux de conversion par tier. Livrable : docs/growth/pricing-strategy.md

---

### Prompt 5 — Stratégie de rétention & réduction du churn
**Titre** : Réduire le churn et fidéliser les utilisateurs
**Agents** : @growth, @data-analyst, @copywriter
**Phase** : Phase 4 (ou dès la production)
**Description** : Analyse des signaux de churn précoces (usage drops, features non utilisées), segmentation comportementale (at-risk vs champions), playbook de réengagement, campagnes win-back. Définit les seuils d'alerte et les actions automatisées par segment. Livrable : docs/growth/retention-playbook.md

---

### Prompt 6 — Mesurer le Product-Market Fit
**Titre** : Diagnostiquer le product-market fit
**Agents** : @growth, @data-analyst, @product-manager
**Phase** : Phase 4 (après 50+ utilisateurs actifs)
**Description** : Produit le protocole de mesure du PMF : sondage Sean Ellis ("déçu si disparaît"), retention curve à J7/J30, engagement depth (features utilisées par session), NPS. Définit le seuil de go/no-go pour scaler l'acquisition. Livrable : docs/growth/pmf-diagnostic.md

---

### Prompt 7 — Plan de scale (1000→10 000 utilisateurs)
**Titre** : Passer de 1 000 à 10 000 utilisateurs
**Agents** : @growth, @data-analyst
**Phase** : Phase 4 (croissance)
**Description** : Analyse les canaux ayant prouvé leur ROI, calcule le payback period par canal, modélise le budget nécessaire pour le scale (CAC × volume cible), identifie le canal à doubler en priorité vs ceux à couper. Livrable : docs/growth/scale-plan.md avec projections sur 3 mois.

---

### Prompt 8 — PLG (Product-Led Growth) setup
**Titre** : Configurer une motion PLG
**Agents** : @growth, @product-manager, @ux
**Phase** : Phase 2 ou Phase 4
**Description** : Conçoit la mécanique PLG : définition du free tier (features incluses vs gated), triggers d'upgrade (usage limits, collaboration features, analytics), in-app upgrade prompts, time-to-value du free tier. Distingue freemium (permanent) vs free trial (limité dans le temps). Livrable : docs/growth/plg-strategy.md

---

### Prompt 9 — Upsell & expansion revenue
**Titre** : Maximiser l'expansion revenue
**Agents** : @growth, @product-manager, @copywriter
**Phase** : Phase 4 (utilisateurs payants existants)
**Description** : Identifie les signaux d'usage déclenchant un upsell (volume, features avancées, membres d'équipe), conçoit les upgrade flows in-app, rédige les emails de montée en tier, modélise le Net Revenue Retention cible. Livrable : docs/growth/expansion-revenue.md

---

### Prompt 10 — A/B testing & optimisation conversion
**Titre** : Structurer les A/B tests de conversion
**Agents** : @growth, @data-analyst, @ux
**Phase** : Phase 4 (avec trafic suffisant)
**Description** : Définit le backlog de tests priorisés par impact/effort (landing page hero, CTA, onboarding step 1, pricing page), calcule la taille d'échantillon nécessaire par test, documente le protocole (hypothèse, variante, KPI primaire, durée, critère de victoire). Livrable : docs/growth/ab-testing-plan.md

---

## 6. Synthèse — score de couverture par dimension AARRR

| Dimension | Score actuel | Score avec 10 nouveaux prompts |
|---|---|---|
| Acquisition (0→1000) | 3/10 | 7/10 |
| Acquisition (1000→10 000) | 1/10 | 7/10 |
| Activation / PLG | 5/10 | 8/10 |
| Rétention / Churn | 2/10 | 8/10 |
| Referral / Viral | 1/10 | 7/10 |
| Revenue / Pricing | 3/10 | 8/10 |
| **Global growth** | **3/10** | **7.5/10** |

---

## 7. Priorisation des 10 prompts recommandés

**Priorité 1 — Impact immédiat sur le succès du projet :**
1. Pricing strategy (sans prix justes, tout le reste est mal calibré)
2. Mesurer le PMF (scaler sans PMF = gaspillage)
3. Stratégie de rétention & churn (la rétention est le multiplicateur de l'acquisition)

**Priorité 2 — Comblent les trous du funnel :**
4. Programme de referral (canal à coût quasi nul une fois construit)
5. PLG setup (moteur de croissance self-serve)
6. Plan de lancement 0→premiers utilisateurs

**Priorité 3 — Scale et optimisation :**
7. Plan de scale 1000→10 000
8. Upsell & expansion revenue
9. A/B testing & optimisation conversion
10. Valider la demande (fake door — utile surtout en phase pré-développement)

---

## Hypothèses à valider

Aucune donnée inventée dans cette analyse. Les scores de couverture sont des estimations qualitatives basées sur l'inventaire exhaustif des 39 prompts. Ils n'ont pas de valeur statistique et doivent être interprétés comme des ordres de grandeur, pas des métriques précises.

---

*Livrable produit par @growth — 2026-03-22*
