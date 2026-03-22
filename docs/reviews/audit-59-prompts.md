# Audit exhaustif des 59 prompts — Gradient Agents Framework

**Date** : 2026-03-22
**Auditeurs** : 18 agents (creative-strategy, product-manager, copywriter, fullstack, qa, infrastructure, ux, design, ia, seo, geo, data-analyst, growth, social, legal, reviewer, elon, agent-factory)
**Perimetre** : 59 prompts de la bibliotheque index.html

---

## Methodologie

Chaque prompt est evalue par les 18 agents selon leur expertise propre, sur une echelle de 1 a 10 :
- **9-10** : Excellent, directement utilisable, best practice
- **7-8** : Bon, fonctionne bien avec des ameliorations mineures
- **5-6** : Correct mais des lacunes significatives
- **3-4** : Insuffisant, necessite une refonte partielle
- **1-2** : Defaillant, a refaire completement

Perspectives d'evaluation par agent :
- **creative-strategy** : alignement positionnement, persona, branding, differenciation
- **product-manager** : completude specs, user stories, priorisation, criteres d'acceptation
- **copywriter** : qualite redactionnelle, clarte, persuasion, ton
- **fullstack** : qualite technique, faisabilite, architecture, stack
- **qa** : testabilite, criteres validation, edge cases, couverture
- **infrastructure** : deploiement, performance, securite, monitoring
- **ux** : parcours utilisateur, conversion, accessibilite, friction
- **design** : coherence visuelle, design system, composants, tokens
- **ia** : architecture IA, modeles, pipelines, prompts
- **seo** : structure SEO, metadonnees, mots-cles, crawlabilite
- **geo** : optimisation LLM, visibilite IA generative, entites
- **data-analyst** : KPIs, tracking, mesurabilite, dashboards
- **growth** : acquisition, funnel, PLG, metriques croissance
- **social** : reseaux sociaux, contenu, engagement, calendrier
- **legal** : conformite RGPD, CGU, IP, EU AI Act
- **reviewer** : coherence inter-prompts, contradictions, qualite globale
- **elon** : vision, ambition, first principles, 10x thinking
- **agent-factory** : pattern prompt, reutilisabilite, standard, extensibilite

---

## Tableau synthetique — Notes par prompt et par agent

Legende colonnes : CS=creative-strategy, PM=product-manager, CW=copywriter, FS=fullstack, QA=qa, IN=infrastructure, UX=ux, DE=design, IA=ia, SE=seo, GE=geo, DA=data-analyst, GR=growth, SO=social, LE=legal, RE=reviewer, EL=elon, AF=agent-factory, MOY=moyenne

### Categorie : Demarrage (1 prompt)

| # | Titre | CS | PM | CW | FS | QA | IN | UX | DE | IA | SE | GE | DA | GR | SO | LE | RE | EL | AF | MOY |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Definir mon projet | 9 | 9 | 7 | 7 | 6 | 6 | 7 | 6 | 6 | 6 | 5 | 8 | 7 | 5 | 7 | 9 | 8 | 9 | 7.1 |

### Categorie : Tout-en-un (3 prompts)

| # | Titre | CS | PM | CW | FS | QA | IN | UX | DE | IA | SE | GE | DA | GR | SO | LE | RE | EL | AF | MOY |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 2 | Lancer mon projet de A a Z | 8 | 8 | 6 | 7 | 6 | 6 | 7 | 6 | 6 | 6 | 5 | 7 | 7 | 5 | 6 | 8 | 9 | 8 | 6.7 |
| 3 | Faire un check-up complet | 8 | 8 | 6 | 6 | 7 | 6 | 7 | 6 | 5 | 6 | 5 | 7 | 6 | 5 | 7 | 9 | 8 | 7 | 6.6 |
| 4 | Pivoter mon projet | 9 | 9 | 7 | 6 | 5 | 5 | 7 | 6 | 5 | 6 | 5 | 6 | 8 | 5 | 6 | 8 | 9 | 8 | 6.6 |

### Categorie : Phase 0 — Strategie & Fondations (11 prompts)

| # | Titre | CS | PM | CW | FS | QA | IN | UX | DE | IA | SE | GE | DA | GR | SO | LE | RE | EL | AF | MOY |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | Positionnement & plateforme de marque | 10 | 8 | 8 | 5 | 5 | 4 | 7 | 7 | 5 | 7 | 6 | 7 | 7 | 6 | 6 | 8 | 8 | 9 | 6.8 |
| 6 | Vision produit & roadmap | 8 | 10 | 6 | 7 | 6 | 5 | 7 | 5 | 5 | 5 | 5 | 8 | 7 | 5 | 5 | 8 | 8 | 8 | 6.6 |
| 7 | KPIs & tracking plan | 7 | 8 | 5 | 7 | 7 | 6 | 6 | 4 | 5 | 6 | 5 | 10 | 8 | 5 | 5 | 8 | 7 | 8 | 6.5 |
| 8 | Audit juridique & conformite | 6 | 6 | 5 | 5 | 6 | 6 | 5 | 4 | 6 | 5 | 5 | 5 | 5 | 4 | 10 | 8 | 7 | 8 | 5.9 |
| 9 | Specs fonctionnelles detaillees | 7 | 10 | 6 | 9 | 8 | 6 | 8 | 6 | 6 | 5 | 5 | 7 | 6 | 4 | 5 | 8 | 7 | 8 | 6.7 |
| 10 | Valider la demande avant de construire | 10 | 9 | 7 | 5 | 5 | 4 | 7 | 4 | 5 | 7 | 6 | 8 | 10 | 6 | 5 | 9 | 10 | 9 | 6.9 |
| 11 | Structurer la proposition de valeur | 10 | 8 | 9 | 4 | 4 | 4 | 7 | 5 | 4 | 6 | 6 | 6 | 8 | 6 | 4 | 8 | 9 | 9 | 6.5 |
| 12 | Construire la messaging matrix | 10 | 7 | 10 | 4 | 4 | 3 | 7 | 5 | 4 | 7 | 6 | 6 | 8 | 8 | 4 | 8 | 8 | 9 | 6.6 |
| 13 | Definir la strategie de pricing | 8 | 10 | 6 | 6 | 5 | 5 | 7 | 5 | 4 | 5 | 5 | 8 | 10 | 5 | 6 | 8 | 9 | 8 | 6.6 |
| 14 | Definir le scope MVP | 8 | 10 | 5 | 8 | 7 | 6 | 7 | 5 | 5 | 5 | 4 | 8 | 8 | 4 | 5 | 9 | 9 | 9 | 6.8 |
| 15 | Ecrire le storytelling de fondation | 10 | 7 | 10 | 3 | 3 | 3 | 6 | 6 | 3 | 6 | 6 | 4 | 7 | 8 | 4 | 7 | 8 | 8 | 6.1 |

### Categorie : Phase 1 — Conception (8 prompts)

| # | Titre | CS | PM | CW | FS | QA | IN | UX | DE | IA | SE | GE | DA | GR | SO | LE | RE | EL | AF | MOY |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 16 | Parcours utilisateur & wireframes | 7 | 8 | 6 | 7 | 7 | 5 | 10 | 8 | 5 | 6 | 5 | 7 | 7 | 5 | 5 | 8 | 7 | 8 | 6.7 |
| 17 | Design system complet | 7 | 7 | 5 | 9 | 7 | 6 | 8 | 10 | 5 | 6 | 4 | 5 | 5 | 4 | 5 | 8 | 7 | 9 | 6.5 |
| 18 | Brand voice & guide d'ecriture | 9 | 6 | 10 | 4 | 5 | 4 | 7 | 6 | 4 | 7 | 6 | 5 | 6 | 7 | 5 | 8 | 7 | 8 | 6.3 |
| 19 | Landing page complete | 8 | 7 | 10 | 6 | 6 | 5 | 8 | 7 | 5 | 9 | 7 | 6 | 8 | 7 | 5 | 8 | 8 | 8 | 7.1 |
| 20 | Definir la direction artistique | 9 | 6 | 6 | 5 | 4 | 4 | 7 | 10 | 4 | 5 | 4 | 4 | 5 | 5 | 4 | 7 | 7 | 8 | 5.8 |
| 21 | Definir l'identite verbale | 10 | 6 | 10 | 3 | 3 | 3 | 6 | 5 | 3 | 7 | 6 | 4 | 6 | 7 | 4 | 7 | 7 | 8 | 5.8 |
| 22 | Specifier interactions et etats composants | 6 | 8 | 4 | 9 | 8 | 5 | 9 | 10 | 4 | 4 | 3 | 5 | 4 | 3 | 3 | 8 | 7 | 9 | 5.9 |
| 23 | Definir les specs responsive | 6 | 7 | 4 | 9 | 7 | 6 | 9 | 10 | 3 | 7 | 3 | 4 | 5 | 4 | 3 | 8 | 7 | 8 | 6.1 |

### Categorie : Phase 2 — Developpement (7 prompts)

| # | Titre | CS | PM | CW | FS | QA | IN | UX | DE | IA | SE | GE | DA | GR | SO | LE | RE | EL | AF | MOY |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 24 | Developper une feature | 6 | 8 | 4 | 10 | 9 | 7 | 7 | 7 | 6 | 5 | 4 | 7 | 5 | 3 | 4 | 8 | 7 | 8 | 6.4 |
| 25 | Integrer le paiement Stripe | 6 | 9 | 4 | 10 | 8 | 8 | 6 | 5 | 4 | 4 | 3 | 6 | 7 | 3 | 9 | 8 | 8 | 8 | 6.4 |
| 26 | Ajouter une feature IA (LLM) | 5 | 7 | 4 | 9 | 7 | 7 | 5 | 4 | 10 | 4 | 4 | 5 | 5 | 3 | 5 | 7 | 8 | 8 | 5.9 |
| 27 | Configurer CI/CD & deploiement | 4 | 6 | 3 | 8 | 10 | 10 | 4 | 4 | 4 | 5 | 3 | 5 | 4 | 3 | 4 | 8 | 7 | 8 | 5.6 |
| 28 | Choisir & optimiser les modeles IA | 5 | 6 | 3 | 7 | 5 | 6 | 4 | 3 | 10 | 4 | 4 | 6 | 5 | 3 | 4 | 7 | 8 | 8 | 5.4 |
| 29 | Setup initial du projet | 5 | 8 | 3 | 10 | 7 | 9 | 6 | 6 | 5 | 5 | 3 | 5 | 4 | 3 | 4 | 8 | 8 | 9 | 6.0 |
| 30 | Verifier le handoff design-code | 7 | 7 | 4 | 9 | 9 | 5 | 7 | 10 | 3 | 4 | 3 | 4 | 4 | 3 | 3 | 9 | 7 | 9 | 5.9 |

### Categorie : Phase 3 — Visibilite (4 prompts)

| # | Titre | CS | PM | CW | FS | QA | IN | UX | DE | IA | SE | GE | DA | GR | SO | LE | RE | EL | AF | MOY |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 31 | Strategie SEO technique & editoriale | 6 | 6 | 7 | 6 | 5 | 6 | 6 | 5 | 4 | 10 | 8 | 7 | 7 | 5 | 5 | 8 | 7 | 8 | 6.4 |
| 32 | Visibilite sur les IA generatives (GEO) | 7 | 6 | 6 | 5 | 4 | 5 | 5 | 4 | 7 | 8 | 10 | 6 | 7 | 5 | 5 | 7 | 8 | 8 | 6.3 |
| 33 | SEO + GEO combines | 7 | 6 | 6 | 5 | 5 | 5 | 5 | 4 | 6 | 10 | 10 | 7 | 7 | 5 | 5 | 8 | 8 | 8 | 6.5 |
| 34 | Strategie de contenu & calendrier editorial | 8 | 7 | 10 | 4 | 4 | 4 | 6 | 5 | 4 | 9 | 7 | 6 | 8 | 8 | 5 | 8 | 7 | 8 | 6.6 |

### Categorie : Phase 4 — Acquisition & Croissance (9 prompts)

| # | Titre | CS | PM | CW | FS | QA | IN | UX | DE | IA | SE | GE | DA | GR | SO | LE | RE | EL | AF | MOY |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 35 | Strategie d'acquisition complete | 8 | 7 | 8 | 5 | 4 | 4 | 6 | 5 | 4 | 6 | 5 | 7 | 10 | 8 | 5 | 8 | 8 | 8 | 6.4 |
| 36 | Strategie social media | 7 | 6 | 8 | 4 | 4 | 3 | 5 | 5 | 3 | 5 | 5 | 6 | 7 | 10 | 5 | 7 | 7 | 7 | 5.7 |
| 37 | Emails onboarding & conversion | 7 | 7 | 10 | 5 | 5 | 4 | 8 | 5 | 4 | 6 | 5 | 7 | 9 | 6 | 5 | 8 | 7 | 8 | 6.4 |
| 38 | Auditer le funnel existant | 7 | 8 | 5 | 5 | 5 | 5 | 7 | 4 | 4 | 5 | 4 | 9 | 10 | 5 | 5 | 8 | 8 | 8 | 6.2 |
| 39 | Plan de lancement | 9 | 8 | 8 | 5 | 4 | 5 | 6 | 5 | 4 | 6 | 5 | 7 | 10 | 9 | 5 | 8 | 10 | 9 | 6.8 |
| 40 | Concevoir un programme de referral | 7 | 8 | 6 | 8 | 6 | 5 | 7 | 5 | 4 | 5 | 4 | 7 | 10 | 6 | 6 | 8 | 9 | 8 | 6.6 |
| 41 | Reduire le churn et fideliser | 7 | 7 | 8 | 5 | 5 | 4 | 7 | 4 | 4 | 5 | 4 | 9 | 10 | 6 | 5 | 8 | 8 | 8 | 6.3 |
| 42 | Configurer une motion PLG | 7 | 9 | 6 | 6 | 5 | 5 | 8 | 5 | 4 | 5 | 4 | 7 | 10 | 5 | 5 | 8 | 9 | 8 | 6.4 |
| 43 | Diagnostiquer le product-market fit | 8 | 10 | 5 | 4 | 4 | 4 | 6 | 4 | 4 | 5 | 4 | 9 | 9 | 5 | 5 | 8 | 10 | 8 | 6.2 |

### Categorie : Phase 5 — Audit & Validation (6 prompts)

| # | Titre | CS | PM | CW | FS | QA | IN | UX | DE | IA | SE | GE | DA | GR | SO | LE | RE | EL | AF | MOY |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 44 | Revue croisee GO/NO-GO | 7 | 8 | 6 | 6 | 7 | 6 | 7 | 6 | 5 | 6 | 5 | 7 | 6 | 5 | 7 | 10 | 8 | 8 | 6.7 |
| 45 | Revue intermediaire | 7 | 7 | 5 | 6 | 7 | 5 | 6 | 5 | 5 | 6 | 5 | 7 | 5 | 4 | 6 | 9 | 7 | 8 | 6.1 |
| 46 | Audit qualite & tests complets | 5 | 7 | 4 | 8 | 10 | 7 | 6 | 5 | 5 | 6 | 4 | 7 | 5 | 3 | 5 | 8 | 7 | 8 | 6.1 |
| 47 | Audit UX & conversion | 7 | 7 | 5 | 5 | 6 | 5 | 10 | 6 | 4 | 6 | 4 | 8 | 7 | 4 | 5 | 8 | 7 | 7 | 6.2 |
| 48 | Audit strategique first principles | 8 | 7 | 6 | 5 | 5 | 5 | 6 | 5 | 5 | 5 | 5 | 6 | 7 | 5 | 5 | 8 | 10 | 7 | 6.1 |
| 49 | Monitoring post-launch | 4 | 6 | 3 | 7 | 7 | 10 | 4 | 3 | 4 | 5 | 3 | 6 | 5 | 3 | 5 | 7 | 7 | 7 | 5.3 |

### Categorie : Raccourcis (10 prompts)

| # | Titre | CS | PM | CW | FS | QA | IN | UX | DE | IA | SE | GE | DA | GR | SO | LE | RE | EL | AF | MOY |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 50 | Refondre un site existant | 7 | 7 | 5 | 9 | 7 | 6 | 9 | 8 | 4 | 6 | 4 | 5 | 5 | 4 | 4 | 8 | 8 | 8 | 6.3 |
| 51 | Diagnostiquer un probleme de performance | 5 | 6 | 3 | 8 | 6 | 10 | 5 | 4 | 4 | 8 | 3 | 5 | 5 | 3 | 4 | 7 | 7 | 7 | 5.6 |
| 52 | Auditer la coherence visuelle | 6 | 6 | 4 | 6 | 6 | 4 | 8 | 10 | 3 | 5 | 3 | 4 | 4 | 3 | 4 | 8 | 6 | 7 | 5.4 |
| 53 | Optimiser l'onboarding | 7 | 7 | 8 | 5 | 5 | 4 | 10 | 6 | 4 | 5 | 4 | 8 | 8 | 5 | 4 | 8 | 8 | 8 | 6.3 |
| 54 | Creer un agent specialise | 7 | 6 | 5 | 5 | 5 | 5 | 5 | 4 | 6 | 4 | 4 | 4 | 4 | 4 | 4 | 7 | 8 | 10 | 5.4 |
| 55 | Migrer la stack technique | 5 | 7 | 3 | 10 | 7 | 9 | 5 | 4 | 4 | 5 | 3 | 4 | 4 | 3 | 4 | 7 | 7 | 8 | 5.4 |
| 56 | Internationaliser le produit (i18n) | 6 | 7 | 8 | 9 | 6 | 6 | 7 | 5 | 4 | 9 | 5 | 5 | 6 | 5 | 6 | 8 | 7 | 8 | 6.5 |
| 57 | Post-mortem incident production | 5 | 6 | 3 | 7 | 9 | 10 | 4 | 3 | 4 | 4 | 3 | 5 | 4 | 3 | 5 | 8 | 7 | 8 | 5.4 |
| 58 | Collecter le feedback et planifier la v2 | 7 | 10 | 6 | 5 | 5 | 4 | 8 | 5 | 4 | 5 | 4 | 8 | 7 | 5 | 5 | 8 | 8 | 8 | 6.2 |
| 59 | Structurer les A/B tests | 6 | 7 | 5 | 7 | 6 | 5 | 7 | 4 | 4 | 6 | 4 | 9 | 10 | 5 | 4 | 8 | 8 | 8 | 6.3 |

---

## Note globale de la bibliotheque

**Note globale moyenne : 6.2 / 10**

Distribution des notes moyennes par prompt :
- 7.0+ : 2 prompts (3.4%) — Excellent
- 6.5-6.9 : 16 prompts (27.1%) — Bon
- 6.0-6.4 : 22 prompts (37.3%) — Correct
- 5.5-5.9 : 13 prompts (22.0%) — A ameliorer
- <5.5 : 6 prompts (10.2%) — Prioritaire

**Verdict** : La bibliotheque est solide dans son domaine de competence principal (strategie + product), mais presente des lacunes significatives vues depuis les perspectives transversales (legal, social, geo, design pour les prompts techniques, et inversement technique pour les prompts strategiques). C'est structurel : chaque prompt est optimise pour ses agents cibles mais sous-evalue par les agents non concernes.

---

## Top 5 des meilleurs prompts

### 1. Prompt #1 — Definir mon projet (MOY: 7.1)
**Pourquoi il excelle :**
- (@creative-strategy, 9) : Couvre exhaustivement les champs strategiques (persona, positionnement, promesse, ton, concurrents)
- (@product-manager, 9) : Structure parfaite pour alimenter specs et roadmap. Champs objectif 6 mois et KPI North Star bien places
- (@reviewer, 9) : Point d'entree unique qui alimente toute la chaine. Fallback intelligent si project-context.md existe deja
- (@agent-factory, 9) : Pattern exemplaire — formulaire a trous avec exemples, fallback, verification post-creation
- (@data-analyst, 8) : Le champ KPI North Star permet de lancer le tracking des le depart
**Faiblesse identifiee** : (@geo, 5) pas de champ pour les entites de marque a pousser sur les IA generatives ; (@social, 5) pas de champ "presence reseaux sociaux existante"

### 2. Prompt #19 — Landing page complete (MOY: 7.1)
**Pourquoi il excelle :**
- (@copywriter, 10) : Structure complete hero/benefices/social-proof/CTA/FAQ, calibrage persona explicite
- (@seo, 9) : Enchainement natif avec optimisation meta/headings/JSON-LD
- (@ux, 8) : Sections alignees avec le parcours de conversion standard
- (@growth, 8) : Couvre l'ensemble du funnel de conversion sur une page
- (@creative-strategy, 8) : Reference explicite au brand voice et persona
**Faiblesse identifiee** : (@qa, 6) pas de criteres de test de la landing ; (@infrastructure, 5) pas de mention performance/temps de chargement cible

### 3. Prompt #10 — Valider la demande avant de construire (MOY: 6.9)
**Pourquoi il excelle :**
- (@growth, 10) : Protocole complet de demand validation (volume recherche, interviews, fake door test, go/no-go)
- (@creative-strategy, 10) : Verification d'alignement positionnement/demande reelle
- (@elon, 10) : First principles — ne pas construire sans valider. Anti-vanity metrics
- (@reviewer, 9) : Triple chainage avec verification croisee (growth → strategy → analytics)
- (@agent-factory, 9) : Pattern de prompt multi-agents exemplaire avec roles clairs
**Faiblesse identifiee** : (@design, 4) aucune dimension visuelle ; (@infrastructure, 4) hors scope

### 4. Prompt #39 — Plan de lancement (MOY: 6.8)
**Pourquoi il excelle :**
- (@growth, 10) : Plan operationnel heure par heure, plateformes specifiques (Product Hunt, HN, etc.)
- (@elon, 10) : Vision ambitieuse avec objectifs chiffres, pas de demi-mesure
- (@creative-strategy, 9) : Storytelling et assets de marque bien integres
- (@social, 9) : Planification social J-3 a J+7 integree nativement
- (@agent-factory, 9) : Triple chainage growth → copywriter → social bien orchestre
**Faiblesse identifiee** : (@qa, 4) pas de test pre-lancement mentionne ; (@infrastructure, 5) pas de plan de capacite pour le pic de trafic

### 5. Prompt #14 — Definir le scope MVP (MOY: 6.8)
**Pourquoi il excelle :**
- (@product-manager, 10) : Methode RICE, criteres de sortie, hypothese business centrale — exemplaire
- (@elon, 9) : Focus brutal sur l'essentiel, anti-feature-creep
- (@reviewer, 9) : Chaque feature justifiee contre persona + KPI = zero arbitraire
- (@agent-factory, 9) : Prompt autonome, fallback clair, critere de qualite explicite
- (@data-analyst, 8) : Lien explicite entre features et KPI North Star
**Faiblesse identifiee** : (@design, 5) pas de wireframes ou mockups dans le scope ; (@social, 4) hors scope

---

## Top 5 des prompts a ameliorer en priorite

### 1. Prompt #49 — Monitoring post-launch (MOY: 5.3)
**Problemes identifies :**
- (@creative-strategy, 4) : Aucun lien avec le positionnement de marque ou l'experience attendue
- (@copywriter, 3) : Zero dimension communication — pas d'alertes utilisateur, pas de status page copy
- (@ux, 4) : Monitoring purement technique, aucune metrique UX (temps de chargement percu, frustration)
- (@design, 3) : Aucune mention de status page design ou dashboard de monitoring
- (@geo, 3) / (@social, 3) : Hors scope total
**Ameliorations recommandees :**
1. Ajouter des metriques UX dans le monitoring (Core Web Vitals orientes utilisateur, pas juste serveur)
2. Integrer la creation d'une status page (design + copy)
3. Ajouter le monitoring des metriques business (pas juste technique) : conversion rate, signup rate
4. Mentionner le protocole de communication incident (qui prevenir, comment, quel message)

### 2. Prompt #28 — Choisir & optimiser les modeles IA (MOY: 5.4)
**Problemes identifies :**
- (@copywriter, 3) : Aucune dimension qualite de sortie textuelle des modeles
- (@design, 3) : Pas de mention de l'UX de la feature IA (temps de reponse percu, animations de chargement)
- (@ux, 4) : Choix modele deconnecte de l'experience utilisateur
- (@social, 3) / (@geo, 4) : Hors scope
- (@legal, 4) : Pas de mention conformite (RGPD sur les donnees envoyees aux modeles, data residency)
**Ameliorations recommandees :**
1. Ajouter un critere "qualite perceptible par l'utilisateur" dans le tableau comparatif (pas juste technique)
2. Mentionner les implications RGPD de l'envoi de donnees utilisateur aux modeles (data processing agreement)
3. Ajouter le critere de latence percue par l'utilisateur (avec budget animation loading)
4. Inclure le fallback UX en cas d'indisponibilite du modele

### 3. Prompt #54 — Creer un agent specialise (MOY: 5.4)
**Problemes identifies :**
- (@design, 4) : Aucune mention de la qualite visuelle des livrables de l'agent
- (@ux, 5) : Pas de test du nouvel agent sur un parcours utilisateur reel
- (@data-analyst, 4) : Pas de metriques de performance de l'agent cree
- (@seo, 4) / (@geo, 4) / (@social, 4) / (@legal, 4) : Trop meta pour etre applicable
- (@growth, 4) : Pas de lien avec les objectifs business
**Ameliorations recommandees :**
1. Ajouter un protocole de test obligatoire : l'agent cree doit etre teste sur un cas concret avant validation
2. Inclure des criteres de performance mesurables pour le nouvel agent
3. Ajouter un template de "fiche agent" standardise (pas juste le .md)
4. Mentionner la documentation utilisateur du nouvel agent

### 4. Prompt #55 — Migrer la stack technique (MOY: 5.4)
**Problemes identifies :**
- (@copywriter, 3) : Aucune dimension contenu (migration du CMS, des traductions, des assets texte)
- (@ux, 5) : Pas d'evaluation de l'impact UX de la migration
- (@design, 4) : Pas de mention de la migration des design tokens / composants visuels
- (@social, 3) / (@geo, 3) : Hors scope
- (@data-analyst, 4) : Pas de plan de migration du tracking (events analytics, GTM, etc.)
**Ameliorations recommandees :**
1. Ajouter la migration du tracking/analytics comme etape explicite
2. Mentionner la migration des design tokens et du design system
3. Inclure un plan de test A/B pre/post migration (metriques identiques avant/apres)
4. Ajouter la migration du contenu (CMS, textes, assets) comme dimension

### 5. Prompt #57 — Post-mortem incident production (MOY: 5.4)
**Problemes identifies :**
- (@copywriter, 3) : Pas de template de communication incident (email aux utilisateurs, status page update)
- (@design, 3) : Pas de mention de page d'erreur / degraded mode UI
- (@ux, 4) : Pas d'evaluation de l'impact sur l'experience utilisateur
- (@creative-strategy, 5) : Pas de dimension "impact sur la confiance de marque"
- (@social, 3) : Pas de protocole de communication sur les reseaux sociaux
**Ameliorations recommandees :**
1. Ajouter un template de communication incident multi-canal (email, status page, social)
2. Integrer l'evaluation de l'impact sur la perception de marque
3. Ajouter un plan de reconquete post-incident (geste commercial, communication transparente)
4. Mentionner la review des pages d'erreur et du mode degrade de l'UI

---

## Recommandations transversales

### 1. Biais structurel : prompts hyper-specialises, sous-exploites en transversalite

La note globale de 6.2/10 revele un pattern clair : chaque prompt est excellent pour ses agents cibles (souvent 9-10) mais mediocre pour les agents non directement concernes (souvent 3-5). Ce n'est pas un defaut en soi — un prompt technique n'a pas besoin d'etre excellent en copywriting. Mais certaines dimensions transversales sont systematiquement absentes :

**Dimension legale (moyenne @legal : 5.0/10)** : seuls les prompts #8 (Audit juridique), #25 (Stripe), #1 (Definir mon projet) mentionnent la conformite. Les prompts IA (#26, #28) ne mentionnent jamais la conformite RGPD sur les donnees envoyees aux modeles. Les prompts d'acquisition (#35, #39) ne mentionnent pas le consentement marketing.

**Recommandation** : Ajouter un encart "[Conformite] Verifie que cette feature est conforme aux recommandations de docs/legal/" dans chaque prompt de developpement et d'acquisition.

### 2. Absence systematique de criteres de test dans les prompts non-QA

**Dimension QA (moyenne @qa : 5.8/10)** : seuls les prompts explicitement QA (#24, #27, #30, #46) incluent des criteres de test. Les prompts de conception (#16-23) et de strategie (#5-15) ne mentionnent jamais "comment verifier que ce livrable est correct".

**Recommandation** : Ajouter une section "Criteres de validation" dans chaque prompt — meme strategique. Exemple pour le prompt #5 (Positionnement) : "Critere : le positionnement est validable si le persona reconnaît son probleme dans la formulation et si aucun concurrent ne fait la meme promesse."

### 3. Pas de mention de performance / temps de chargement dans les prompts copy et design

Les prompts #19 (Landing page), #17 (Design system), #20 (Direction artistique) ne mentionnent jamais les contraintes de performance. Un design system avec des animations lourdes ou une landing page avec 15 images non optimisees ruinera le SEO et l'UX.

**Recommandation** : Ajouter dans les prompts design/copy une contrainte : "Performance : les choix visuels doivent etre compatibles avec un LCP < 2.5s. Signaler les elements potentiellement lourds (images, animations, videos)."

### 4. Faible couverture GEO (moyenne @geo : 4.7/10)

La perspective GEO (visibilite sur les IA generatives) est la plus sous-representee. Seuls les prompts #32 et #33 la couvrent explicitement. Or, dans un contexte 2026, la visibilite sur ChatGPT/Claude/Gemini/Perplexity est aussi strategique que le SEO classique.

**Recommandation** : Ajouter dans les prompts de contenu (#18, #19, #34) une mention : "Structurer le contenu pour etre citable par les LLM : claims verifiables, entites nommees, format FAQ."

### 5. Chainages multi-agents parfois trop ambitieux

Les prompts avec triple chainage (#25 Stripe, #35 Acquisition, #37 Emails, #53 Onboarding) risquent le timeout. Les mentions "si timeout, relancer l'agent manquant separement" sont un bon palliatif, mais le vrai probleme est que 3 agents en sequence dans un seul prompt est fragile.

**Recommandation** : Pour les prompts a 3+ agents, proposer une version "decomposee" avec 3 prompts individuels en alternative. Ou mieux : indiquer dans le "quand" que ces prompts sont a lancer via @orchestrator qui gerera le sequencement.

### 6. Placeholders non remplaces = erreur silencieuse

Les prompts #24 (Developper une feature), #26 (Feature IA), #54 (Creer un agent), #55 (Migrer la stack) contiennent des placeholders `[nom de la feature]`, `[decrire la feature]`, `[domaine]`, `[stack actuelle]`. Si l'utilisateur oublie de les remplacer, l'agent recevra un placeholder brut.

**Recommandation** : Ajouter un pre-check dans les prompts avec placeholders : "Si ce prompt contient encore des crochets `[...]`, signale-le a l'utilisateur et demande les informations manquantes avant de continuer."

### 7. Fallback "pose-moi les questions" : robuste mais verbeux

Quasiment tous les prompts (90%+) incluent le pattern "S'il n'existe pas, pose-moi les questions pour le creer et genere-le avant de continuer." C'est excellent pour la robustesse (aucun prompt ne bloque), mais cela alourdit chaque prompt de 20-30 mots repetitifs.

**Recommandation** : Deplacer ce pattern dans le protocole de base des agents (`_base-agent-protocol.md`) comme regle par defaut : "Si un livrable amont reference dans ta mission n'existe pas, demande a l'utilisateur les informations necessaires pour le creer avant de continuer." Cela allegerait chaque prompt de ~30 mots tout en conservant le comportement.

### 8. Manque de metriques de succes dans les prompts strategiques

Les prompts Phase 0 (#5, #6, #11, #15) produisent des livrables strategiques mais ne definissent pas comment mesurer leur succes. Un positionnement est-il "bon" ? Comment le savoir sans critere ?

**Recommandation** : Ajouter des "criteres de succes du livrable" dans chaque prompt strategique. Exemple pour #5 : "Le positionnement est reussi si : (a) le persona principal s'y reconnait, (b) aucun concurrent direct n'occupe le meme creneau, (c) il est formulable en <20 mots."

---

## Analyse par agent — Notes moyennes et observations

### Notes moyennes par agent (sur l'ensemble des 59 prompts)

| Agent | Note moyenne | Observation cle |
|---|---|---|
| @agent-factory | 8.1 | Note la plus haute — les prompts suivent un bon pattern standard |
| @reviewer | 7.9 | Coherence globale solide, peu de contradictions inter-prompts |
| @elon | 7.8 | Vision et ambition presentes, first principles respectes |
| @creative-strategy | 7.0 | Bien represente en Phase 0-1, absent des phases techniques |
| @product-manager | 7.3 | Bonne couverture specs/roadmap, present dans la majorite des prompts |
| @copywriter | 5.7 | Fort sur ses prompts propres, invisible dans les prompts techniques |
| @fullstack | 6.3 | Bien couvert en Phase 2, pertinence limitee en Phase 0/4 |
| @qa | 5.8 | Sous-represente — criteres de test absents de la majorite des prompts |
| @infrastructure | 5.3 | Pertinence limitee aux prompts techniques, note basse sur le reste |
| @ux | 6.5 | Bonne couverture Phase 1/5, dimension UX absente des prompts techniques |
| @design | 5.3 | Fort sur ses prompts propres, invisible en Phase 0/2/4 |
| @ia | 4.5 | Seuls 2-3 prompts concernent directement l'IA |
| @seo | 5.8 | Bien couvert en Phase 3, absent des autres phases |
| @geo | 4.7 | Note la plus basse — visibilite IA quasi absente de la bibliotheque |
| @data-analyst | 6.2 | Present en Phase 0/4/5 mais absent de Phase 1/2 |
| @growth | 6.5 | Bien couvert en Phase 4, pertinence limitee ailleurs |
| @social | 4.9 | Faiblement represente — peu de prompts social media |
| @legal | 5.0 | Quasi absent hors prompt #8, dimension conformite negligee |

### Observations croisees

1. **Les agents "meta" (reviewer, elon, agent-factory) donnent les meilleures notes** car ils evaluent la qualite du pattern/prompt lui-meme, pas le contenu metier. Les prompts sont bien structures.

2. **Les agents de niche (geo, ia, legal) donnent les notes les plus basses** car ils ne trouvent pas leur domaine dans la majorite des prompts. C'est normal mais revele un axe d'amelioration : ajouter des dimensions transversales.

3. **L'ecart type entre notes est eleve (~2.5 points)** pour chaque prompt, confirmant que les prompts sont specialises plutot que transversaux.

---

## Prompts manquants identifies par les agents

### Identifies par @legal
1. **Audit accessibilite RGAA/WCAG** : pas de prompt dedie a la conformite accessibilite numerique (obligation legale en France depuis 2025 pour de nombreux sites)
2. **Gestion des cookies et consent** : pas de prompt pour configurer un bandeau cookie conforme (TCF v2, CNIL)
3. **Protection de la propriete intellectuelle** : le prompt #8 le mentionne, mais pas de prompt dedie au depot de marque et a la veille IP

### Identifies par @social
4. **Community management et moderation** : pas de prompt pour gerer une communaute active (Discord, Slack, forum)
5. **Strategie d'influence / partenariats** : pas de prompt pour identifier et contacter des micro-influenceurs ou partenaires strategiques

### Identifies par @data-analyst
6. **Data pipeline et ETL** : pas de prompt pour configurer la collecte, le nettoyage et l'agregation des donnees
7. **Dashboard de reporting investisseurs** : pas de prompt pour les metriques orientees investisseurs (MRR, churn, CAC, LTV, runway)

### Identifies par @ia
8. **RAG (Retrieval-Augmented Generation)** : pas de prompt dedie a la construction d'un pipeline RAG (indexation, embeddings, retrieval, generation)
9. **Evaluation des outputs IA (evals)** : pas de prompt pour mesurer systematiquement la qualite des sorties IA en production
10. **Fine-tuning et prompt engineering avance** : pas de prompt pour l'optimisation de prompts en production

### Identifies par @infrastructure
11. **Disaster recovery / backup** : pas de prompt pour la strategie de sauvegarde et le plan de reprise d'activite
12. **Securite offensive (pentest)** : pas de prompt pour l'audit de securite applicative

### Identifies par @ux
13. **User research en continu** : pas de prompt pour la mise en place d'un programme de recherche utilisateur permanent (panels, interviews recurrentes)
14. **Design d'un systeme de notifications** : pas de prompt specifique pour concevoir les notifications in-app, email, push

### Identifies par @growth
15. **Strategie de partenariats / co-marketing** : pas de prompt pour identifier et structurer des partenariats d'acquisition
16. **Automatisation marketing (sequences conditionnelles)** : pas de prompt pour les workflows marketing automatises au-dela des emails lineaires

### Identifies par @elon
17. **Vision a long terme et moat** : pas de prompt pour definir l'avantage concurrentiel durable (network effects, data moat, switching costs)
18. **Culture et organisation d'equipe** : pas de prompt pour structurer la culture, les rituels, le recrutement

---

## Metriques d'orchestration

- Agents mobilises : 18/19 (orchestrator exclu — il coordonne)
- Prompts evalues : 59
- Evaluations individuelles : 1062 (59 x 18)
- Note globale bibliotheque : 6.2/10
- Prompts > 7.0 : 2 (3.4%)
- Prompts < 5.5 : 6 (10.2%)
- Agent le plus satisfait : @agent-factory (8.1/10)
- Agent le moins satisfait : @ia (4.5/10)
- Prompts manquants identifies : 18
- Recommandations transversales : 8

---

## Conclusion

La bibliotheque de 59 prompts est une base solide (6.2/10) avec des points forts clairs :

**Forces** :
- Pattern de prompt standardise et robuste (fallback systematique, chainage inter-agents)
- Couverture exhaustive du cycle de vie projet (Phase 0 a 5 + raccourcis)
- Les prompts les mieux notes (#1, #19, #10, #39, #14) sont ceux que les utilisateurs lanceront en premier — bon signal
- Le "quand" de chaque prompt aide a la decision

**Faiblesses** :
- Dimensions transversales negligees (legal, GEO, performance, tests)
- Prompts techniques deconnectes des preoccupations business
- Prompts strategiques deconnectes des contraintes techniques
- 18 prompts manquants identifies par les agents

**Priorites d'amelioration** :
1. Ajouter les dimensions legale et conformite dans les prompts d'acquisition et de developpement
2. Integrer des criteres de validation dans TOUS les prompts (pas juste les prompts QA)
3. Developper les prompts GEO transversaux (visibilite IA dans le contenu)
4. Ajouter les 5-6 prompts manquants les plus critiques (accessibilite, RAG, community management, backup)
5. Refactoriser le pattern fallback en regle de base pour alleger les prompts

---

**Handoff → utilisateur**
- Fichier produit : `docs/reviews/audit-59-prompts.md`
- Agents mobilises : 18 perspectives d'evaluation appliquees
- Decisions prises : notation sur 10 de chaque prompt par chaque agent, identification des forces/faiblesses/manques
- Points d'attention : les 6 prompts sous 5.5/10 meritent une refonte ; les 18 prompts manquants sont a prioriser
- Prochaines etapes recommandees : (1) corriger les 5 prompts les plus faibles, (2) ajouter les 5-6 prompts manquants les plus critiques, (3) integrer les 8 recommandations transversales

