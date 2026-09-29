# Plan d'orchestration -- Nouveaux prompts a ajouter

## Contexte

Consolidation des 5 audits de couverture :
- @elon : `docs/reviews/elon-coverage-audit.md` (verdict 6/10, 15 prompts manquants critiques)
- @creative-strategy : `docs/strategy/prompts-coverage-creative-strategy.md` (5.5/10, 5 prompts recommandés)
- @growth : `docs/growth/prompts-coverage-growth.md` (3/10 growth global, 10 prompts recommandés)
- @product-manager : `docs/product/prompts-coverage-product.md` (9 prompts recommandés)
- @design : `docs/design/prompts-coverage-design.md` (4 prompts recommandés)

## Méthode de deduplication

Plusieurs audits recommandent les mêmes prompts sous des noms differents. Voici le mapping :

| Concept | @elon | @creative-strategy | @growth | @product-manager | @design |
|---|---|---|---|---|---|
| Validation marche / demand testing | Prompt 1 | - | Prompt 1 (fake door) | Prompt A (discovery) | - |
| Pricing & monetisation | Prompt 2 | - | Prompt 4 | Prompt I | - |
| Retention & churn | Prompt 3 | - | Prompt 5 | - | - |
| Setup initial (scaffold) | Prompt 4 | - | - | - | - |
| Content marketing | Prompt 5 | - | - | - | - |
| A/B testing | Prompt 6 | - | Prompt 10 | - | - |
| Referral / viralite | Prompt 7 | - | Prompt 3 | - | - |
| Unit economics | Prompt 8 | - | - | - | - |
| Voice of Customer / feedback | Prompt 9 | - | - | Prompt H | - |
| Scalabilite technique | Prompt 10 | - | - | - | - |
| Proposition de valeur | - | Prompt A | - | - | - |
| Messaging matrix | - | Prompt B | - | - | - |
| Identité verbale | - | Prompt C | - | - | - |
| Storytelling fondation | - | Prompt D | - | - | - |
| Naming | - | Prompt E | - | - | - |
| PMF (product-market fit) | - | - | Prompt 6 | Prompt E | - |
| Plan de lancement | - | - | Prompt 2 | - | - |
| PLG setup | - | - | Prompt 8 | - | - |
| Upsell / expansion | - | - | Prompt 9 | - | - |
| Scale 1K-10K | - | - | Prompt 7 | - | - |
| Discovery utilisateur | - | - | - | Prompt A+B | - |
| Scope MVP | - | - | - | Prompt C | - |
| Test prototype | - | - | - | Prompt D | Prompt B (specs interaction) |
| Sprint planning | - | - | - | Prompt F | - |
| Retrospective sprint | - | - | - | Prompt G | - |
| Direction artistique | - | - | - | - | Prompt A |
| Specs interaction composants | - | - | - | - | Prompt B |
| Handoff design-code | - | - | - | - | Prompt C |
| Responsive / breakpoints | - | - | - | - | Prompt D |

## Liste consolidee et dedupliquee -- 20 prompts à créer

Après deduplication, 20 prompts uniques sont nécessaires. Classes par phase et priorité.

---

### PHASE 0 -- Stratégie & Fondations (6 prompts)

#### P0-1. Valider la demande marche (DEMAND TESTING)
- **Priorité** : P0 (critique)
- **Sources** : @elon #1, @growth #1, @product-manager #A
- **Agents** : @growth, @creative-strategy, @data-analyst
- **Description** : Avant de construire, valider que le marche existe. Protocole de recherche utilisateur (interviews discovery, script, grille), test de demande (landing page waitlist, fake door), critère go/no-go chiffre.
- **Phase** : Phase 0 (tout premier prompt après le contexte)
- **Catégorie dans index.html** : Phase 0

#### P0-2. Proposition de valeur structurée
- **Priorité** : P0 (critique)
- **Sources** : @creative-strategy #A
- **Agents** : @creative-strategy
- **Description** : Traduit le positionnement en proposition de valeur opérationnelle : problème quantifie, solution différenciante, preuve, résultat concret, pour qui, pourquoi maintenant.
- **Phase** : Phase 0 (après brand-platform)
- **Catégorie dans index.html** : Phase 0

#### P0-3. Messaging matrix
- **Priorité** : P1 (important)
- **Sources** : @creative-strategy #B
- **Agents** : @creative-strategy, @copywriter
- **Description** : Grille persona x canal x étape funnel x message clé x objection. Input du copywriter pour tous les contenus.
- **Phase** : Phase 0 (après proposition de valeur)
- **Catégorie dans index.html** : Phase 0

#### P0-4. Pricing & packaging
- **Priorité** : P0 (critique)
- **Sources** : @elon #2, @growth #4, @product-manager #I
- **Agents** : @product-manager, @growth
- **Description** : Benchmark concurrents, willingness-to-pay par persona, tiers, feature gating, modèle (freemium/trial/paywall), grille tarifaire prête a implementer.
- **Phase** : Phase 0 (après roadmap, avant dev)
- **Catégorie dans index.html** : Phase 0

#### P0-5. Scope MVP (definition explicite)
- **Priorité** : P1 (important)
- **Sources** : @product-manager #C
- **Agents** : @product-manager
- **Description** : Features in/out avec justification RICE, critères de sortie MVP, hypothèse business centrale à valider.
- **Phase** : Phase 0 (après roadmap)
- **Catégorie dans index.html** : Phase 0

#### P0-6. Storytelling de fondation
- **Priorité** : P2 (nice-to-have)
- **Sources** : @creative-strategy #D
- **Agents** : @creative-strategy, @copywriter
- **Description** : Histoire d'origine, tension narrative, vision 3-5 ans, manifeste. Alimente page About, pitchs, contenu social.
- **Phase** : Phase 0-1
- **Catégorie dans index.html** : Phase 0

---

### PHASE 1 -- Conception (4 prompts)

#### P1-1. Direction artistique & moodboard
- **Priorité** : P0 (critique)
- **Sources** : @design #A
- **Agents** : @design, @creative-strategy
- **Description** : 2-3 directions artistiques (brief visuel textuel, palette candidate, typo candidate). Validation alignement marque avant de figer les tokens.
- **Phase** : Phase 1 (avant design system)
- **Catégorie dans index.html** : Phase 1

#### P1-2. Identité verbale
- **Priorité** : P1 (important)
- **Sources** : @creative-strategy #C
- **Agents** : @creative-strategy, @copywriter
- **Description** : Lexique propriétaire, formulations bannies, phrases signature, métaphores fondatrices. Equivalent verbal du design system.
- **Phase** : Phase 1 (après brand voice)
- **Catégorie dans index.html** : Phase 1

#### P1-3. Specs d'interaction & états composants
- **Priorité** : P1 (important)
- **Sources** : @design #B, @product-manager #D (partiellement)
- **Agents** : @design, @ux
- **Description** : Chaque composant prioritaire : default, hover, focus, active, disabled, loading, error, success, empty state. Format tableau.
- **Phase** : Phase 1 (après design system)
- **Catégorie dans index.html** : Phase 1

#### P1-4. Specs responsive & breakpoints
- **Priorité** : P1 (important)
- **Sources** : @design #D
- **Agents** : @design, @ux
- **Description** : Composants critiques x breakpoints Tailwind. Adaptations typo, règles de densité d'information.
- **Phase** : Phase 1 (complement du design system)
- **Catégorie dans index.html** : Phase 1

---

### PHASE 2 -- Développement (2 prompts)

#### P2-1. Setup initial du projet (scaffold + DB + auth)
- **Priorité** : P0 (critique)
- **Sources** : @elon #4
- **Agents** : @fullstack, @infrastructure
- **Description** : Scaffolder le projet complet : structure fichiers, schema DB, config auth, env vars, middleware, layout de base.
- **Phase** : Phase 2 (premier prompt de dev)
- **Catégorie dans index.html** : Phase 2

#### P2-2. Audit handoff design-code
- **Priorité** : P1 (important)
- **Sources** : @design #C
- **Agents** : @design, @qa
- **Description** : Audit du code produit contre design-tokens.json. Vérification tokens utilises, contrastes WCAG, états implémentés. Rapport d'écarts.
- **Phase** : Phase 2 (après implementation composants)
- **Catégorie dans index.html** : Phase 2

---

### PHASE 3 -- Visibilité (1 prompt)

#### P3-1. Stratégie de contenu & calendrier editorial
- **Priorité** : P1 (important)
- **Sources** : @elon #5
- **Agents** : @copywriter, @seo
- **Description** : Piliers thematiques, types de contenu, calendrier de publication, distribution. Redaction des 3 premiers articles piliers SEO.
- **Phase** : Phase 3 (après SEO)
- **Catégorie dans index.html** : Phase 3

---

### PHASE 4 -- Acquisition & Croissance (5 prompts)

#### P4-1. Plan de lancement (0 -> premiers utilisateurs)
- **Priorité** : P1 (important)
- **Sources** : @growth #2
- **Agents** : @growth, @copywriter, @social
- **Description** : Plan 48h : choix plateforme (Product Hunt, HN, BetaList), assets, social proof J1, objectif trafic/signups.
- **Phase** : Phase 4 (pre-lancement)
- **Catégorie dans index.html** : Phase 4

#### P4-2. Programme de referral & viralite
- **Priorité** : P1 (important)
- **Sources** : @elon #7, @growth #3
- **Agents** : @growth, @product-manager, @fullstack
- **Description** : Mécanique referral (double-sided, incentive, flow technique, tracking, viral coefficient K).
- **Phase** : Phase 4
- **Catégorie dans index.html** : Phase 4

#### P4-3. Stratégie de retention & anti-churn
- **Priorité** : P0 (critique)
- **Sources** : @elon #3, @growth #5
- **Agents** : @growth, @data-analyst, @copywriter
- **Description** : Signaux de churn précoces, segmentation comportementale, playbook reengagement, campagnes win-back.
- **Phase** : Phase 4+
- **Catégorie dans index.html** : Phase 4

#### P4-4. PLG (Product-Led Growth) setup
- **Priorité** : P1 (important)
- **Sources** : @growth #8
- **Agents** : @growth, @product-manager, @ux
- **Description** : Free tier, feature gating, triggers d'upgrade, in-app upgrade prompts, time-to-value du free tier.
- **Phase** : Phase 4
- **Catégorie dans index.html** : Phase 4

#### P4-5. Mesurer le Product-Market Fit
- **Priorité** : P0 (critique)
- **Sources** : @elon (implicite), @growth #6, @product-manager #E
- **Agents** : @product-manager, @growth, @data-analyst
- **Description** : Sondage Sean Ellis, retention curve J7/J30, engagement depth, NPS. Verdict go/no-go pour scaler l'acquisition.
- **Phase** : Phase 4 (après 50+ utilisateurs actifs)
- **Catégorie dans index.html** : Phase 4

---

### RACCOURCIS (2 prompts)

#### R-1. Feedback utilisateur & roadmap v2
- **Priorité** : P1 (important)
- **Sources** : @elon #9, @product-manager #H
- **Agents** : @product-manager, @data-analyst, @ux
- **Description** : Collecte systématique de feedback (in-app, NPS, interviews, feature requests), priorisation RICE, roadmap v2.
- **Phase** : Raccourci (post-lancement continu)
- **Catégorie dans index.html** : Raccourcis

#### R-2. A/B testing & experimentation
- **Priorité** : P1 (important)
- **Sources** : @elon #6, @growth #10
- **Agents** : @growth, @data-analyst, @fullstack
- **Description** : Backlog d'hypothèses priorisees, protocole de test, taille échantillon, implementation feature flags.
- **Phase** : Raccourci (produit avec trafic)
- **Catégorie dans index.html** : Raccourcis

---

## Prompts NON retenus (et pourquoi)

| Prompt propose | Source | Raison du rejet |
|---|---|---|
| Naming | @creative-strategy #E | Trop niche (stade Idee uniquement), integrable dans brand-platform existant |
| Unit economics | @elon #8 | Fusionne avec P0-4 (Pricing) qui inclut la modélisation financière |
| Scalabilite technique | @elon #10 | Fusionne avec le prompt existant "Diagnostiquer un problème de performance" + monitoring post-launch |
| Sprint planning | @product-manager #F | Trop opérationnel pour une bibliothèque de prompts stratégiques -- releve du workflow quotidien |
| Retrospective sprint | @product-manager #G | Idem |
| Upsell / expansion revenue | @growth #9 | Fusionne avec P4-4 (PLG) qui couvre les upgrade triggers |
| Scale 1K-10K | @growth #7 | Fusionne avec P4-5 (PMF) -- le scale ne se planifie qu'après PMF valide |
| Prototype interactif | @product-manager #D, @design | Le prompt P1-3 (specs interaction) couvre le besoin sans necessiter d'outil externe |

---

## Plan d'execution

### Passe 1 : Phase 0 -- Stratégie (6 prompts)
- @creative-strategy : P0-1 (demand testing), P0-2 (proposition de valeur), P0-3 (messaging matrix), P0-6 (storytelling)
- @product-manager : P0-4 (pricing), P0-5 (scope MVP)

### Passe 2 : Phase 1 -- Conception (4 prompts)
- @design : P1-1 (direction artistique), P1-3 (specs interaction), P1-4 (responsive)
- @creative-strategy : P1-2 (identité verbale)

### Passe 3 : Phase 2+3 (3 prompts)
- @fullstack/infra : P2-1 (setup initial)
- @design : P2-2 (audit handoff)
- @copywriter : P3-1 (content marketing)

### Passe 4 : Phase 4 + Raccourcis (7 prompts)
- @growth : P4-1 (lancement), P4-2 (referral), P4-3 (retention), P4-4 (PLG), P4-5 (PMF)
- @product-manager : R-1 (feedback/roadmap v2)
- @growth : R-2 (A/B testing)

### Validation finale
- @ia valide chaque prompt pour la qualité technique et le standard 9/10

---

## Statut

| ID | Titre | Agent redacteur | Statut |
|---|---|---|---|
| P0-1 | Valider la demande marche | @growth | TERMINE |
| P0-2 | Proposition de valeur | @creative-strategy | TERMINE |
| P0-3 | Messaging matrix | @creative-strategy | TERMINE |
| P0-4 | Pricing & packaging | @product-manager | TERMINE |
| P0-5 | Scope MVP | @product-manager | TERMINE |
| P0-6 | Storytelling de fondation | @creative-strategy | TERMINE |
| P1-1 | Direction artistique | @design | TERMINE |
| P1-2 | Identité verbale | @creative-strategy | TERMINE |
| P1-3 | Specs interaction composants | @design | TERMINE |
| P1-4 | Specs responsive | @design | TERMINE |
| P2-1 | Setup initial projet | @fullstack | TERMINE |
| P2-2 | Audit handoff design-code | @design | TERMINE |
| P3-1 | Stratégie de contenu | @copywriter | TERMINE |
| P4-1 | Plan de lancement | @growth | TERMINE |
| P4-2 | Programme de referral | @growth | TERMINE |
| P4-3 | Retention & anti-churn | @growth | TERMINE |
| P4-4 | PLG setup | @growth | TERMINE |
| P4-5 | Mesurer le PMF | @product-manager | TERMINE |
| R-1 | Feedback & roadmap v2 | @product-manager | TERMINE |
| R-2 | A/B testing | @growth | TERMINE |

Tous les 20 prompts ont été inseres dans `index.html` le 2026-03-22. Compteur mis à jour de 39 a 59.
