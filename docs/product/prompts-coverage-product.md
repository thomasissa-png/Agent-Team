# Analyse couverture produit — Bibliothèque de 39 prompts
**Agent** : @product-manager
**Date** : 2026-03-22
**Scope** : Audit du cycle produit complet — de la vision initiale au succès post-lancement

---

## Méthode d'analyse

Le cycle produit complet suit cette boucle : Vision → Discovery → Definition → Build → Measure → Learn → Iterate. J'ai évalué chaque étape contre les 39 prompts existants, en recherchant les trous qui font échouer les produits en conditions réelles.

---

## Ce qui est bien couvert

### Vision & positionnement (Phase 0)
Les prompts "Positionnement & plateforme de marque" et "Vision produit & roadmap" couvrent correctement la fondation stratégique. Le chaînage creative-strategy → product-manager est logique et les livrables (brand-platform, product-vision, roadmap, backlog) sont les bons artefacts de départ.

### Specs fonctionnelles (Phase 0)
Le prompt "Specs fonctionnelles détaillées" existe et demande explicitement les user stories, critères d'acceptation et cas limites. C'est solide.

### Build & déploiement (Phase 2)
La couverture technique est bonne : feature development, Stripe, IA/LLM, CI/CD. L'agent @qa est bien intégré en parallèle du développement.

### Mesure (Phase 0 + Phase 5)
Le tracking plan + KPI framework sont définis avant le dev (bonne pratique). L'audit funnel en Phase 4 complète la boucle de mesure.

### Validation croisée (Phase 5)
Les prompts reviewer (GO/NO-GO, mid-projet) et l'audit Elon couvrent la dimension validation finale. C'est un point fort du framework.

---

## Ce qui manque — analyse par étape critique

### 1. Discovery utilisateur — TROU MAJEUR

**Ce qui manque** : il n'existe aucun prompt dédié à la recherche utilisateur avant de définir les specs. Le framework passe directement de la plateforme de marque aux specs fonctionnelles.

**Impact sur le succès** : c'est la cause n°1 d'échec produit. Construire les specs sans valider les hypothèses avec de vrais utilisateurs conduit à coder les mauvaises features. Le "positionnement" par @creative-strategy est une hypothèse, pas une validation.

**Prompts manquants** :
- Plan de recherche utilisateur (interviews discovery, protocole, grille de questions)
- Synthèse d'insights (matrice hypothèses/validations, patterns identifiés)

---

### 2. Définition du MVP — TROU IMPORTANT

**Ce qui manque** : aucun prompt ne force la définition explicite du MVP avec ce qui est dedans et ce qui est dehors. Le prompt "Vision produit & roadmap" produit un backlog priorisé, mais ne produit pas un document de définition MVP défendable avec justification de chaque exclusion.

**Impact sur le succès** : sans définition MVP formalisée, le scope creep est systématique. Chaque stakeholder y ajoute "juste une feature de plus". La roadmap et le backlog ne suffisent pas — il faut un document qui dit explicitement "MVP = X features, pas Y ni Z, parce que..."

**Prompt manquant** :
- Définir le scope MVP (liste des features in/out avec justification, critères de sortie MVP)

---

### 3. Prototypage et validation avant développement — TROU MAJEUR

**Ce qui manque** : le framework passe des wireframes UX directement au développement. Il n'y a aucune étape de prototype cliquable + test utilisateur avant de coder.

**Impact sur le succès** : corriger une erreur de conception sur un wireframe coûte 1h. La corriger sur du code coûte 5 jours. Le trou entre Phase 1 (Conception) et Phase 2 (Développement) est le plus coûteux du cycle.

**Prompts manquants** :
- Prototype cliquable (instructions pour créer un prototype Figma/Framer depuis les wireframes, puis tester avec 5 utilisateurs)
- Test utilisateur rapide (protocole de test de prototype, grille d'observation, critères de validation avant de passer au dev)

---

### 4. Sprint planning et gestion de backlog itérative — TROU MODÉRÉ

**Ce qui manque** : le prompt "Vision produit & roadmap" crée un backlog initial, mais aucun prompt ne couvre la gestion itérative : découpage en sprints, cérémonies agiles (planning, retro), vélocité, ajustement du backlog au fil des sprints.

**Impact sur le succès** : un backlog créé une fois et jamais revu devient obsolète en 3 semaines. Sans prompt de sprint planning, les équipes improvident leur organisation.

**Prompts manquants** :
- Sprint planning (découpage du backlog en sprints, estimation, critères de définition of done)
- Rétrospective sprint (analyse vélocité, friction points, ajustements du backlog)

---

### 5. Mesure du Product-Market Fit — TROU IMPORTANT

**Ce qui manque** : le framework a un bon dispositif de tracking et d'audit funnel, mais aucun prompt ne demande explicitement de mesurer si le PMF est atteint. Le prompt "Auditer le funnel existant" traite la conversion, pas le PMF.

**Impact sur le succès** : sans protocole PMF explicite, les équipes ne savent pas quand arrêter d'itérer sur le MVP et quand passer à la croissance. Scaler sans PMF = brûler du budget acquisition sur un produit qui n'est pas prêt.

**Prompts manquants** :
- Mesure du PMF (enquête Sean Ellis, analyse rétention cohortes J1/J7/J30, NPS, signal "must-have")

---

### 6. Itérations post-lancement — TROU MODÉRÉ

**Ce qui manque** : après le lancement, le framework propose un audit funnel et un monitoring infra, mais pas de boucle structurée pour collecter le feedback utilisateur, le prioriser et alimenter le backlog suivant.

**Impact sur le succès** : le lancement n'est pas la fin du travail produit — c'est le début. Sans boucle feedback formalisée, les insights utilisateurs post-lancement ne sont pas capturés systématiquement.

**Prompts manquants** :
- Collecte et priorisation du feedback post-lancement (in-app, NPS, interviews, feature requests → backlog)
- Définir la roadmap v2 (après PMF, priorisation RICE de la prochaine itération)

---

### 7. Pricing et packaging — TROU MINEUR

**Ce qui manque** : le prompt Stripe intègre les "plans tarifaires" comme prérequis mais suppose qu'ils existent déjà dans les specs. Aucun prompt ne guide la définition du pricing (tiers, feature gating, stratégie freemium vs trial, benchmarks sectoriels).

**Impact sur le succès** : le pricing est souvent décidé intuitivement. Un prompt dédié éviterait les erreurs classiques (sous-tarification, mauvais feature gating, absence de plan d'upgrade).

**Prompt manquant** :
- Définir le modèle de pricing (tiers, feature gating, benchmark concurrents, stratégie de migration)

---

## Récapitulatif des gaps par priorité

| Priorité | Gap identifié | Impact | Prompt recommandé |
|---|---|---|---|
| P0 — Critique | Discovery utilisateur | Construit les mauvaises features | Plan de recherche utilisateur + synthèse insights |
| P0 — Critique | Prototype + test avant dev | Corrections coûteuses en dev | Prototype cliquable + test utilisateur |
| P1 — Important | Définition MVP explicite | Scope creep systématique | Scope MVP (in/out avec justification) |
| P1 — Important | Mesure PMF | Scale sans signal produit | Mesure PMF (Sean Ellis + rétention cohortes) |
| P2 — Modéré | Sprint planning itératif | Backlog obsolète | Sprint planning + rétrospective |
| P2 — Modéré | Feedback post-lancement | Insights perdus | Collecte feedback + roadmap v2 |
| P3 — Mineur | Pricing et packaging | Sous-tarification | Modèle de pricing |

---

## Prompts recommandés — descriptions détaillées

### Prompt A : Recherche utilisateur (Discovery)
**Titre** : Valider mes hypothèses avec de vrais utilisateurs
**Agents** : @product-manager
**Phase** : Phase 0 — avant les specs
**Description** : Produit un plan de recherche utilisateur complet : hypothèses critiques à tester, script d'interview discovery (questions ouvertes, jobs-to-be-done, pains), protocole de recrutement (5-8 profils cibles), grille d'observation, et matrice de synthèse hypothèses/validations. Livrable : `docs/product/user-research-plan.md`

---

### Prompt B : Synthèse insights discovery
**Titre** : Analyser les interviews et mettre à jour les specs
**Agents** : @product-manager
**Phase** : Phase 0 — après les interviews
**Description** : À partir des notes d'interviews fournies par l'utilisateur, extrait les patterns (pains récurrents, jobs prioritaires, objections), valide ou invalide les hypothèses initiales, et met à jour le backlog en conséquence. Livrable : `docs/product/research-insights.md` + `docs/product/backlog.md` mis à jour

---

### Prompt C : Définir le scope MVP
**Titre** : Définir le périmètre exact du MVP (ce qui est dedans, ce qui attend)
**Agents** : @product-manager
**Phase** : Phase 0 — après roadmap, avant dev
**Description** : Produit la définition MVP formalisée : features retenues (avec justification RICE), features explicitement exclues (avec raison), critères de sortie MVP (métriques à atteindre avant de passer à la v2), et hypothèse business centrale à valider. Livrable : `docs/product/mvp-scope.md`

---

### Prompt D : Test utilisateur du prototype
**Titre** : Tester le prototype avant de coder
**Agents** : @ux, @product-manager
**Phase** : Phase 1 — entre wireframes et développement
**Description** : À partir des wireframes produits par @ux, définit le protocole de test utilisateur : tâches à observer, critères de réussite/échec, grille d'observation, seuil de décision (passer au dev ou retravailler les wireframes). Livrable : `docs/ux/prototype-test-plan.md`

---

### Prompt E : Mesurer le Product-Market Fit
**Titre** : Diagnostiquer si le PMF est atteint
**Agents** : @product-manager, @data-analyst
**Phase** : Post-lancement (après 4-6 semaines de production)
**Description** : Combine l'enquête Sean Ellis ("très déçu" >40% = signal PMF), l'analyse de rétention par cohorte (J1/J7/J30 avec seuils cibles), le NPS, et les signaux qualitatifs (feature requests, churn reasons). Produit un verdict binaire PMF atteint/non-atteint avec les leviers prioritaires à actionner. Livrable : `docs/product/pmf-measurement.md`

---

### Prompt F : Sprint planning
**Titre** : Planifier le prochain sprint
**Agents** : @product-manager
**Phase** : Phase 2 — début de chaque sprint
**Description** : Découpe le backlog priorisé en sprint de 1-2 semaines : stories sélectionnées selon la vélocité estimée, définition of done pour chaque story, dépendances identifiées, objectif du sprint formulé en une phrase. Livrable : `docs/product/sprint-plan.md`

---

### Prompt G : Rétrospective et mise à jour du backlog
**Titre** : Analyser le sprint écoulé et mettre à jour les priorités
**Agents** : @product-manager
**Phase** : Phase 2 — fin de chaque sprint
**Description** : Analyse la vélocité réelle vs estimée, identifie les blockers récurrents, met à jour le backlog (nouvelles stories issues des retours utilisateurs, re-priorisation RICE), et prépare l'objectif du sprint suivant. Livrable : mise à jour de `docs/product/backlog.md` + `docs/product/sprint-retrospective.md`

---

### Prompt H : Collecter et prioriser le feedback post-lancement
**Titre** : Transformer le feedback utilisateur en backlog v2
**Agents** : @product-manager, @data-analyst
**Phase** : Post-lancement continu
**Description** : Structure la collecte de feedback multi-canal (in-app widget, NPS, interviews ciblées sur les churners), agrège les feature requests, les priorise au score RICE contre les métriques actuelles, et produit le backlog de la prochaine itération. Livrable : `docs/product/feedback-backlog.md`

---

### Prompt I : Définir le modèle de pricing
**Titre** : Structurer les plans tarifaires et le feature gating
**Agents** : @product-manager
**Phase** : Phase 0 — avant l'intégration Stripe
**Description** : Benchmark des pricing concurrents (WebSearch), définition des tiers (Free/Pro/Business ou équivalent), feature gating par plan justifié par la valeur perçue, stratégie d'upgrade (freemium vs trial vs demo), estimation de l'ARPU cible. Livrable : `docs/product/pricing-model.md`

---

## Synthèse : le cycle produit actuel vs le cycle complet

```
CYCLE ACTUEL (39 prompts)
Vision → Specs → Build → Measure → [trou] → Acquisition

CYCLE COMPLET RECOMMANDÉ
Vision → Discovery → Hypothèses → MVP Scope → Wireframes → Test Proto
→ Build → Sprint Planning → QA → Launch → Mesure PMF → Feedback
→ Retro → Roadmap v2 → [recommencer]
```

Les 39 prompts couvrent bien la ligne droite vision-build-launch. Ils couvrent mal la boucle d'apprentissage qui transforme un lancement en succès durable. Les 3 gaps les plus critiques à combler : discovery utilisateur, test prototype avant dev, et mesure PMF post-lancement.

---

## Hypothèses à valider

[HYPOTHÈSE : certains utilisateurs du framework ont déjà leurs propres processus de discovery et test utilisateur hors de l'outil — auquel cas les prompts A, B et D seraient des doublons. À confirmer avec les utilisateurs réels du framework avant d'implémenter.]

---

**Handoff → @orchestrator**
- Fichiers produits : `/home/user/Agent-Team/docs/product/prompts-coverage-product.md`
- Décisions prises : identification de 9 prompts manquants, priorisation P0/P1/P2/P3, description des livrables cibles
- Points d'attention : les gaps P0 (discovery + test prototype) sont les plus critiques — un produit construit sans validation utilisateur avant le dev cumule les risques. Si le framework veut se positionner comme un outil de product management rigoureux, ces deux prompts sont non-négociables. Le gap PMF (Prompt E) est le deuxième chantier prioritaire pour transformer un lancement en croissance pérenne.
