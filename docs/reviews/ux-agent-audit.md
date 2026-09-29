# Audit Agent @ux -- Avis Elon x UX

> AVIS CONSULTATIF -- Ces recommandations necessitent validation avant execution.
> Date : 2026-03-28
> Auditeur : @elon (vision stratégique + benchmark marche)

## Score global : 7.2/10

Solide pour un framework 2025. Mais on est en mars 2026. Le monde UX a bouge massivement avec l'agentic AI, et notre agent UX est encore dans un paradigme 2023 : "je dessine des wireframes et je documente des flows". Il manque tout le pan *evaluation systématique*, *métriques UX*, et *paradigme agent-first*. C'est comme si on avait un bon moteur V6 quand le marche est passe au electrique.

---

## Scores par dimension

| Dimension | Score | Justification |
|---|---|---|
| A1. User research / persona validation | 4/10 | Lit le persona de project-context, mais ne fait AUCUNE recherche utilisateur. Pas d'interviews synthetiques, pas de validation d'hypothèses persona, pas de simulation de parcours par profil |
| A2. User flows | 8/10 | Bien couvert : happy path + edge cases + états d'erreur. Format de test inclus. Manque : task analysis formelle |
| A3. Wireframes | 9/10 | Excellent. Patterns layout detailles, responsive documente, règle de primaute wireframe/design. Best-in-class pour un agent IA |
| A4. Information architecture | 5/10 | Mentionne "taxonomie, navigation, hiérarchie" dans les competences mais AUCUN protocole, aucun livrable dedie (card sorting, tree testing, sitemap structurée) |
| A5. Micro-UX (empty/error/loading/success/tooltips) | 7/10 | Couvert dans les tests UX (edge cases). Mais pas de bibliothèque de patterns micro-UX. Les 5 états sont dans qa.md, pas systematises dans ux.md |
| A6. CRO / conversion | 7/10 | Mentionne "hypothèses de test, priorisation" dans les competences. Time-to-value mesure. Mais pas de framework CRO structure (funnel analysis, friction mapping, drop-off analysis) |
| A7. Onboarding | 8/10 | Bien traite : time-to-value <= 3 étapes, aha moment, progressive disclosure. Préférences fondateur incluses. Livrable dedie onboarding-flow.md |
| A8. Accessibility UX (cognitive) | 5/10 | WCAG 2.2 AA technique couvert (contrastes, clavier, screen readers). Mais Zéro sur l'accessibilité cognitive : charge mentale, lisibilite, parcours pour neuro-divergents, plain language |
| A9. Mobile UX | 4/10 | Mentionne "React Native navigation (Expo Router)" et responsive dans wireframes. Mais AUCUN pattern mobile spécifique : thumb zones, gesture patterns, bottom sheet, pull-to-refresh, touch targets au-dela du 44px |
| A10. Form UX | 2/10 | Quasi absent. Pas de progressive disclosure sur les formulaires, pas d'inline validation, pas de smart defaults, pas de patterns d'erreur de formulaire |
| A11. Navigation patterns | 4/10 | Mentionne "architecture de navigation" dans le handoff. Mais aucune bibliothèque de patterns : quand utiliser tabs vs sidebar vs bottom nav vs breadcrumbs vs command palette |
| B1. Qualité prompt / niveau expert | 7/10 | Identité bien ecrite, conviction claire. Calibration solide (lit personas, specs, brand, KPI). Mais manque de frameworks UX reconnus |
| B2. Frameworks UX reconnus | 3/10 | Zéro framework nomme : pas de JTBD, pas de HEART, pas de Nielsen 10, pas de UX Honeycomb, pas de Kano model. Un expert UX senior invoque ces frameworks par reflexe |
| B3. Préférences fondateur | 8/10 | 5 préférences concretes et actionnables. Bien fait |
| C1. Heuristic evaluation | 0/10 | Absent. Un agent UX sans Nielsen 10 heuristics, c'est un medecin sans stethoscope |
| C2. Cognitive walkthrough | 0/10 | Absent. Pas de protocole "je simule un first-time user step by step" |
| C3. Task analysis | 0/10 | Absent. Pas de decomposition formelle des tâches utilisateur |
| C4. UX metrics (SUS, NPS, HEART, task completion) | 0/10 | Zéro métrique UX. L'agent produit des wireframes mais ne mesure rien. C'est comme construire une fusee sans telemetrie |
| C5. A/B test design | 2/10 | Mentionne "hypothèses de test" dans CRO mais aucun protocole de design d'A/B test |
| C6. Usability testing protocole | 1/10 | A des "tests UX" mais c'est de la validation interne. Pas de protocole de test utilisateur (script, scénarios, métriques, recrutement, synthese) |
| C7. UX writing guidelines | 3/10 | Produit un livrable ux-writing-guide.md mentionne dans le handoff fullstack, mais aucune instruction sur le contenu (microcopy, CTAs, error messages, tone) |

---

## Ce qui fonctionne (ne pas toucher)

1. **Wireframes avec patterns layout** : la section est exceptionnelle. Pattern explicite, responsive detaille, règle de primaute avec @design. C'est du best-in-class. Quand on a concu l'interface du Model 3 chez Tesla, on a compris que chaque millimetre d'écran devait être justifie -- cette rigueur est la.

2. **Préférences fondateur** : 5 règles concretes, pas du blabla. Modal auth, zéro duplication, LinkedIn > questionnaire. C'est exactement ce qu'un agent doit avoir -- des opinions tranchees, pas des "best practices génériques".

3. **Protocole de tests UX** : le format tableau avec critères mesurables (charge cognitive <= 3 actions, time-to-value <= 3 étapes) est solide. Les critères sont binaires et verifiables.

4. **Revue UX post-implementation** : la boucle retour vers @fullstack est bien pensee. Peu de frameworks font ca.

5. **Recommandation d'agents specialises** : la capacite a recommander des testeurs persona et des experts metier est intelligente et s'integre bien dans l'ecosysteme.

---

## Ce qui est broken (a reconsiderer)

### 1. Zéro evaluation heuristique -- Impact : CRITIQUE

L'agent UX ne fait aucune evaluation systématique contre les 10 heuristiques de Nielsen. C'est le B.A.-BA de l'UX depuis 1994, et c'est encore plus pertinent en 2026 parce qu'un agent IA peut l'automatiser sur CHAQUE écran, pas juste quand on y pense.

**Impact sur le projet** : des problèmes d'utilisabilite fondamentaux (feedback système absent, cohérence manquante, prevention d'erreur oubliee) passent a travers sans être détectés. C'est de la dette UX invisible.

**Solution** : ajouter un protocole d'audit heuristique obligatoire dans chaque livrable. L'agent evaluate chaque ecran/flow contre les 10 heuristiques. Pas en option -- en standard.

### 2. Zéro métriques UX -- Impact : CRITIQUE

Pas de HEART framework, pas de SUS, pas de task completion rate, pas de time-on-task. L'agent dessine mais ne mesure jamais. C'est comme si SpaceX lancait des fusees sans capteurs.

**Impact** : impossible de savoir si les décisions UX ameliorent reellement l'expérience. Tout est subjectif. Quand j'ai pris Tesla, j'ai insiste pour que CHAQUE changement d'interface soit mesurable. Sinon c'est de l'art, pas de l'ingenierie.

**Solution** : integrer le HEART framework (Happiness, Engagement, Adoption, Retention, Task Success) comme grille obligatoire de chaque livrable UX.

### 3. Pas de cognitive walkthrough -- Impact : HAUT

L'agent simule des personas dans les tests UX, mais n'a pas de protocole formel de cognitive walkthrough : "a chaque étape, le first-time user sait-il quoi faire ? L'action disponible est-elle visible ? Le feedback est-il clair ?"

**Impact** : les flows sont documentes mais pas stress-testes du point de vue d'un novice total.

### 4. Mobile UX superficiel -- Impact : HAUT

En 2026, 70%+ du trafic est mobile. L'agent mentionne "responsive" et "Expo Router" mais n'a AUCUN pattern mobile natif : thumb zone mapping, bottom sheet vs modal, gesture navigation, safe areas, notch handling, keyboard avoidance.

**Impact** : les wireframes desktop sont solides mais l'expérience mobile est laissee a l'improvisation de @fullstack.

### 5. Form UX inexistant -- Impact : MOYEN-HAUT

Les formulaires sont le point de conversion critique de tout SaaS. Pas d'inline validation, pas de progressive disclosure, pas de smart defaults, pas d'auto-save, pas de multi-step form patterns.

**Impact** : chaque formulaire du projet est concu ad hoc sans patterns etablis.

---

## Ce qui manque

### Frameworks UX canoniques

L'agent ne référence AUCUN framework UX reconnu. Un senior UX de 14 ans d'expérience (comme le decrit l'identité) utiliserait ces frameworks par reflexe :

- **Nielsen 10 Heuristics** : grille d'evaluation systématique
- **HEART Framework** (Google) : métriques UX structurees
- **Jobs-to-be-Done** : chaque écran resout un "job" spécifique du persona
- **UX Honeycomb** (Peter Morville) : useful, usable, desirable, findable, accessible, credible, valuable
- **Kano Model** : distinguer must-have / performance / delight features dans l'UX
- **Fitts's Law / Hick's Law / Miller's Law** : lois cognitives qui guident le design d'interaction

### Paradigme Agent Expérience (AX)

En 2025-2026, un nouveau paradigme a emerge : l'Agent Expérience Design. Notre agent UX ne l'integre pas du tout :

- Design d'interfaces pour agents IA (structured data, APIs, logical task flows)
- Transparence/explicabilite des décisions IA dans l'UI
- Generative UI (interfaces générées dynamiquement)
- Interfaces multimodales (voice + touch + gesture)

### Protocoles d'evaluation manquants

- **Heuristic evaluation** : audit systématique contre Nielsen 10
- **Cognitive walkthrough** : simulation first-time user step-by-step
- **Task analysis** : decomposition hierarchique des tâches (HTA)
- **Usability test protocol** : script, scénarios, métriques, synthese
- **A/B test design** : formulation d'hypothèse, variantes, métriques de succès, taille d'échantillon

### Patterns UX manquants

- **Navigation patterns** : quand utiliser tabs / sidebar / bottom nav / command palette / breadcrumbs
- **Form patterns** : inline validation, progressive disclosure, smart defaults, auto-save, error recovery
- **Mobile patterns** : thumb zones, bottom sheets, gesture navigation, pull-to-refresh, swipe actions
- **Micro-interactions** : animations fonctionnelles (loading skeletons, success animations, transition states)
- **Search & filter patterns** : faceted search, type-ahead, filter chips, empty search states

---

## Recommandations par priorité

| # | Action | Impact | Effort | Correction concrete |
|---|---|---|---|---|
| 1 | Ajouter evaluation heuristique Nielsen 10 | CRITIQUE | ~40 lignes | Nouvelle section "Audit heuristique obligatoire" avec grille des 10 heuristiques + protocole d'application sur chaque flow |
| 2 | Integrer HEART framework comme métriques UX | CRITIQUE | ~30 lignes | Nouvelle section "Métriques UX" avec HEART + GSM (Goals-Signals-Metrics) + integration dans le format de livrable |
| 3 | Ajouter cognitive walkthrough | HAUT | ~25 lignes | Nouveau protocole dans la section tests : 4 questions par étape (but visible ? action disponible ? lien but-action ? feedback ?) |
| 4 | Enrichir mobile UX | HAUT | ~35 lignes | Nouvelle section "Patterns mobile obligatoires" : thumb zones, bottom sheet vs modal, gesture nav, safe areas, keyboard avoidance |
| 5 | Ajouter form UX patterns | HAUT | ~25 lignes | Nouvelle section "Patterns formulaires" : inline validation, progressive disclosure, smart defaults, multi-step, error states |
| 6 | Ajouter navigation patterns | MOYEN | ~20 lignes | Nouvelle section "Patterns navigation" : quand utiliser chaque pattern, avec décision tree |
| 7 | Integrer frameworks UX dans l'identité | MOYEN | ~15 lignes | Ajouter JTBD, Kano, UX Honeycomb, lois cognitives dans les competences |
| 8 | Ajouter task analysis | MOYEN | ~15 lignes | Protocole HTA (Hierarchical Task Analysis) dans la calibration |
| 9 | Protocole A/B test | MOYEN | ~20 lignes | Format : hypothèse, variantes, métrique primaire, seuil de significance, duree estimée |
| 10 | Ajouter usability test protocol | MOYEN | ~20 lignes | Script template : intro, scénarios, think-aloud, métriques (task completion, time-on-task, error rate), synthese |
| 11 | Integrer paradigme AX (Agent Expérience) | BAS (futur) | ~15 lignes | Section "UX pour produits IA" : transparence, explicabilite, generative UI, multimodal |
| 12 | Ajouter information architecture livrables | MOYEN | ~15 lignes | Ajout livrable sitemap.md, card-sort protocol, tree test protocol |

---

## Vision 10x

Si je devais multiplier l'impact de cet agent par 10 :

1. **L'agent UX ne dessine plus, il MESURE**. Chaque flow produit a des métriques predefinies (HEART). Chaque écran est score contre Nielsen 10. Le livrable n'est plus "voici le wireframe" mais "voici le wireframe, score heuristique 8.7/10, métriques HEART definies, cognitive walkthrough passe".

2. **L'agent UX fait de la recherche utilisateur synthetique**. Il simule 5 profils d'utilisateurs differents qui parcourent le flow et identifient les frictions. Pas besoin de vrais utilisateurs pour une première passe -- les agents testeurs-persona font ce job, mais @ux devrait orchestrer la demande.

3. **L'agent UX produit des protocoles de test utilisateur**. Même sans vrais utilisateurs aujourd'hui, les protocoles sont prêts pour quand le fondateur voudra valider avec de vrais humains. Script, scénarios, métriques, grille d'analyse.

4. **L'agent UX est mobile-first, pas desktop-first avec responsive**. En 2026, le wireframe mobile est le wireframe principal. Le desktop est l'adaptation.

---

## Hypothèses à valider

- [Hypothèse : le persona principal de la plupart des projets utilise majoritairement le mobile] -- à confirmer projet par projet via project-context.md
- [Hypothèse : les frameworks UX canoniques (HEART, Nielsen) sont connus des utilisateurs du framework] -- si non, ajouter des explications courtes

## Dimensions non auditees (données manquantes)

- Performance réelle de l'agent en production (pas de données de projets complets avec @ux)
- Qualité des livrables produits (pas de wireframes.md ou user-flows.md existants a auditer dans ce repo)
- Integration réelle avec @design et @fullstack (theorie vs pratique)

---

**Handoff -> @orchestrator**
- Fichiers produits : `docs/reviews/ux-agent-audit.md`
- Avis donnes : score 7.2/10, 5 problèmes critiques (heuristic eval, métriques UX, cognitive walkthrough, mobile UX, form UX), 12 recommandations priorisees
- Points d'attention : les recommandations 1-5 sont les plus impactantes. Implementer dans cet ordre. L'effort total est d'environ 225 lignes a ajouter dans ux.md. Recommander l'invocation de @agent-factory si des modifications sont validees, ou edition directe par l'utilisateur.
- Rappel : ces recommandations sont des AVIS, pas des directives. L'utilisateur decide.

---

Sources de recherche :
- [Nielsen's 10 Usability Heuristics - NN/g](https://www.nngroup.com/articles/ten-usability-heuristics/)
- [HEART Framework - Google](https://www.heartframework.com/)
- [10 UX Design Shifts 2026 - UX Collective](https://uxdesign.cc/10-ux-design-shifts-you-cant-ignore-in-2026-8f0da1c6741d)
- [AI UX 2025: Rise of AX - Mobisoft](https://mobisoftinfotech.com/resources/blog/ui-ux-design/ai-ux-2025-rise-of-ax)
- [UX Design for Agents - Microsoft Design](https://microsoft.design/articles/ux-design-for-agents/)
- [AI Tools for UX Research - Userology](https://www.userology.co/blogs/10-ai-ux-research-tools-to-try-in-2025)
- [Top AI Tools for Usability Testing - UXArmy](https://uxarmy.com/blog/top-ai-tools-for-usability-testing/)
- [7 New Rules of AI in UX Design 2026 - Millipixels](https://millipixels.com/blog/ai-in-ux-design)
- [Heuristic Analysis Ultimate Guide - CXL](https://cxl.com/blog/heuristic-analysis/)
- [How to Use HEART Framework - Dovetail](https://dovetail.com/ux/heart-framework/)
