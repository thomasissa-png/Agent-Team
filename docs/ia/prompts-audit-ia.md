# Audit de la bibliotheque de prompts front-end

**Agent** : @ia
**Date** : 2026-03-22
**Perimetre** : 38 prompts de la constante `PROMPTS` dans `index.html` (lignes 318-640)
**Methode** : evaluation croisee prompt <-> agent invoque (fichiers `.claude/agents/*.md`)

---

## Criteres d'evaluation (chaque critere sur 2, total /10)

| Critere | Description |
|---|---|
| **Clarte** | L'agent comprend exactement ce qu'on lui demande, sans ambiguite |
| **Autonomie** | Le prompt fonctionne sans prerequis manuels, les fichiers manquants sont geres |
| **Precision** | Les livrables, chemins de fichiers et formats sont specifies |
| **Chainage** | Ordre multi-agents correct, handoffs coherents, pas de dependance circulaire |
| **Efficacite** | Pas de redondance, pas d'instructions inutiles, densite d'information optimale |

---

## Tableau d'audit complet

### Categorie : Demarrage (1 prompt)

| # | Prompt | Note /10 | Points forts | Points faibles |
|---|---|---|---|---|
| 1 | Definir mon projet | **8/10** | Formulaire a trous exhaustif couvrant tous les champs de project-context.md. Instruction claire de confirmation des champs vides. Reference au template. | Ne precise pas le chemin du template (`templates/project-context.md`). Pas de gestion du cas "project-context.md existe deja" (ecrasement ?). Le prompt est tres long -- risque de copier-coller partiel par l'utilisateur. |

### Categorie : Tout-en-un (3 prompts)

| # | Prompt | Note /10 | Points forts | Points faibles |
|---|---|---|---|---|
| 2 | Lancer mon projet de A a Z | **7/10** | Concis, clair, enchaine les phases 0-5. Mentionne orchestration-plan.md. | Ne gere pas le cas project-context.md absent (l'agent le fera, mais le prompt devrait le rappeler). Pas de mention des livrables attendus en sortie. Aucune indication sur le temps estimable ou le nombre de sous-agents. |
| 3 | Faire un check-up complet | **6/10** | Bonne idee de combiner @reviewer + @elon. Double perspective (coherence + strategie). | Le chainage est implicite ("Ensuite @elon") sans specification de l'ordre de lecture des livrables @reviewer par @elon. Pas de chemin de livrable specifie pour @elon. Pas de gestion du cas "aucun livrable dans docs/". |
| 4 | Pivoter mon projet | **7/10** | Bonne gestion du scenario pivot. Demande a l'orchestrateur de trier ce qui est a garder vs reprendre. | Presuppose que project-context.md a ete "mis a jour" -- mais par qui ? Pas de prompt pour guider cette mise a jour. Pas de chemin livrable pour le plan de re-sequencement. |

### Categorie : Phase 0 -- Strategie & Fondations (4 prompts)

| # | Prompt | Note /10 | Points forts | Points faibles |
|---|---|---|---|---|
| 5 | Positionnement & plateforme de marque | **6/10** | Clair sur les livrables (positionnement, personas, benchmark, brief). | Aucun chemin de fichier en sortie specifie. Pas de pattern "pose-moi les questions si manquant" alors que l'agent @creative-strategy a des champs critiques (Secteur, Persona, Probleme, Alternative). Ne gere pas l'absence de project-context.md au niveau du prompt. |
| 6 | Vision produit & roadmap | **9/10** | Excellent pattern autonomie : "S'il n'existe pas, pose-moi les questions pour le creer et genere-le". Livrables avec chemins complets. Horizon temporel parametrable. Format user stories specifie. | Leger : le placeholder "[horizon temporel, par defaut 6 mois]" pourrait etre auto-rempli depuis project-context.md. |
| 7 | KPIs & tracking plan | **5/10** | Mentionne AARRR et North Star Metric. | Tres vague : pas de chemins de livrables, pas de references aux fichiers amont (personas, roadmap). Pas de gestion des fichiers manquants. Pas de pattern "pose-moi les questions". L'agent @data-analyst a besoin de KPI North Star et Objectif a 6 mois -- le prompt ne les reference pas. |
| 8 | Audit juridique & conformite | **9/10** | Tres detaille : RGPD, CGU, IP, EU AI Act. Chemins de fichiers precis. Note anti-timeout. Critere de qualite explicite ("pas un template generique"). | L'instruction "un fichier a la fois" est bonne pour l'anti-timeout mais pourrait etre plus explicite sur l'ordre de priorite. |

### Categorie : Phase 1 -- Conception (4 prompts)

| # | Prompt | Note /10 | Points forts | Points faibles |
|---|---|---|---|---|
| 9 | Parcours utilisateur & wireframes | **9/10** | Pattern autonomie complet. Livrables avec chemins. Format specifie (schema par parcours). Couvre onboarding, activation, conversion, retention. | Rien de significatif a signaler. |
| 10 | Design system complet | **9/10** | Pattern autonomie sur les deux fichiers prerequis. Chainage @design -> @fullstack explicite. Livrables avec chemins. Note anti-timeout. | La partie @fullstack est assez vague ("implemente les tokens"). Pourrait specifier la structure de fichiers attendue dans `src/`. |
| 11 | Brand voice & guide d'ecriture | **8/10** | Pattern autonomie present. Demande le guide UX writing en plus du brand voice. | Pas de chemin de livrable explicite (l'agent @copywriter les connait, mais le prompt devrait les mentionner pour l'utilisateur). |
| 12 | Landing page complete | **9/10** | Excellent chainage @copywriter -> @seo. Pattern autonomie sur deux fichiers prerequis. Questions specifiques pour chaque fichier manquant. Chemin livrable precise pour les deux agents. | Le prompt est long -- mais justifie par la complexite. |

### Categorie : Phase 2 -- Developpement (5 prompts)

| # | Prompt | Note /10 | Points forts | Points faibles |
|---|---|---|---|---|
| 13 | Developper une feature | **8/10** | Pattern autonomie present. Chainage @fullstack -> @qa. Placeholder contextuel pour le nom de feature. Cible de couverture explicite (>80%). | La reference a docs/analytics/tracking-plan.md et docs/design/design-system.md est conditionnelle ("s'ils existent") mais pas de fallback si absents. |
| 14 | Integrer Stripe | **4/10** | Identifie les 3 agents necessaires. | Tres sous-developpe : pas de pattern autonomie, pas de chemins de livrables, pas de references amont. Le prompt @legal et @infrastructure sont a une ligne chacun. Pas de gestion des fichiers manquants. Le plus faible de la bibliotheque pour un prompt multi-agents. |
| 15 | Ajouter une feature IA | **9/10** | Excellent pattern autonomie. Tableau comparatif obligatoire mentionne. Placeholder contextuel detaille. Chainage @ia -> @fullstack explicite avec reference au livrable. | Parfaitement aligne avec le protocole de l'agent @ia (grille de selection, ROI). |
| 16 | Configurer CI/CD | **5/10** | Identifie les deux agents. | Tres telegraphique. Pas de chemins de livrables. Pas de reference aux fichiers amont. Pas de pattern autonomie. @qa et @infrastructure ont des protocoles detailles ignores ici. |
| 17 | Choisir & optimiser modeles IA | **9/10** | Pattern autonomie present. Reference au protocole @ia (tableau comparatif obligatoire). Calcul ROI mentionne. Objectif d'optimisation tokens quantifie (20%+). Chemin livrable precise. | Rien de significatif. |

### Categorie : Phase 3 -- Visibilite (3 prompts)

| # | Prompt | Note /10 | Points forts | Points faibles |
|---|---|---|---|---|
| 18 | Strategie SEO technique & editoriale | **8/10** | Livrables avec chemins complets. Critere de qualite explicite (actionnable + priorite). Mentionne Core Web Vitals. | Pas de pattern autonomie si project-context.md ou landing-page-copy.md sont absents. Pas de gestion fichier manquant. |
| 19 | Visibilite IA generatives (GEO) | **5/10** | Sujet bien identifie. | Pas de chemins de livrables. Pas de references aux fichiers amont (@seo, brand-platform). Pas de pattern autonomie. Prompt trop vague pour un agent qui a un protocole de calibration detaille. |
| 20 | SEO + GEO combines | **9/10** | Excellent chainage explicite @seo -> @geo. Livrables avec chemins. Section synergie demandee. Cross-reference des pages cibles. | Modele a suivre pour les prompts multi-agents. |

### Categorie : Phase 4 -- Acquisition & Croissance (4 prompts)

| # | Prompt | Note /10 | Points forts | Points faibles |
|---|---|---|---|---|
| 21 | Strategie acquisition complete | **9/10** | Triple chainage @growth -> @social -> @copywriter. Pattern autonomie sur chaque prerequis. Livrables avec chemins. CAC/LTV mentionne. | Long mais justifie. |
| 22 | Strategie social media | **9/10** | Chainage @social -> @copywriter. Pattern autonomie generalise ("pour chaque fichier manquant"). Livrables precis. KPIs par plateforme demandes. | Rien de significatif. |
| 23 | Emails onboarding & conversion | **9/10** | Pattern autonomie avec questions specifiques par fichier. Format detaille (objet + preview + corps + CTA). Sequence 5 emails avec timing. Chainage @copywriter -> @growth avec triggers et segmentation. | Modele d'excellence. |
| 24 | Auditer le funnel existant | **8/10** | Pattern autonomie present. Chainage @growth -> @data-analyst. Demande diagnostique AARRR avec leviers priorises. | La mention "donnees analytics fournies" dans le prompt est bonne mais le "quand" precise "fournir les donnees dans project-context.md ou en piece jointe" -- ce n'est pas un format standardise. |

### Categorie : Phase 5 -- Audit & Validation (6 prompts)

| # | Prompt | Note /10 | Points forts | Points faibles |
|---|---|---|---|---|
| 25 | Revue croisee GO/NO-GO | **7/10** | Liste les axes de coherence a verifier. Demande un verdict GO/NO-GO avec blockers. | Pas de chemin de livrable specifie. Pas de gestion du cas "peu de livrables". Le prompt de la "Revue intermediaire" (#26) est meilleur. |
| 26 | Revue intermediaire | **9/10** | Axes de coherence precis avec chemins de fichiers. Format livrable detaille (statut OK/Warning/Blocker). Chemin de sortie specifie. | Excellent prompt de reference. |
| 27 | Audit qualite & tests | **6/10** | Couvre Vitest, Playwright, tracking, Lighthouse. | Pas de chemins de livrables precis. Pas de reference aux fichiers prerequis (functional-specs, tracking-plan). Pas de pattern autonomie. |
| 28 | Audit UX & conversion | **9/10** | Pattern autonomie present. Chainage @ux -> @data-analyst. Quick wins priorises. Livrables avec chemins. | Rien de significatif. |
| 29 | Audit strategique first principles | **7/10** | Bon cadrage : dimensions a noter, verdict sans filtre. | Pas de chemin livrable. Pas de reference aux livrables existants a auditer. @elon a un protocole detaille (lecture de tous les docs/) qui n'est pas rappele dans le prompt. |
| 30 | Monitoring post-launch | **6/10** | Outils specifiques mentionnes (Sentry, UptimeRobot). Alertes Slack. | Pas de chemin livrable. Pas de reference au fichier infrastructure.md existant. Pas de pattern autonomie. Prompt trop telegraphique vs la richesse du protocole @infrastructure. |

### Categorie : Raccourcis (8 prompts)

| # | Prompt | Note /10 | Points forts | Points faibles |
|---|---|---|---|---|
| 31 | Refondre un site existant | **8/10** | Triple chainage @ux -> @design -> @fullstack clair. Livrables avec chemins. Recommandation migration progressive vs big bang. | Bon prompt. La partie @fullstack pourrait mentionner le pattern autonomie pour functional-specs. |
| 32 | Diagnostiquer performance | **8/10** | Outils specifiques (Lighthouse CI, WebPageTest, webpack-bundle-analyzer). Classification par impact. Chainage @infrastructure -> @seo. | Bien construit. |
| 33 | Auditer coherence visuelle | **9/10** | Pattern autonomie present. Chainage @design -> @ux. Questions specifiques pour chaque prerequis manquant. Livrables avec chemins. WCAG 2.2 AA mentionne. | Rien de significatif. |
| 34 | Optimiser l'onboarding | **9/10** | Triple chainage @ux -> @copywriter -> @data-analyst. Pattern autonomie generalise. Objectif quantifie (time-to-value <3 min). Seuil d'alerte specifie (drops >20%). | Modele d'excellence. |
| 35 | Creer un agent specialise | **8/10** | Placeholder contextuel avec exemples. Verification des doublons. Liste des livrables (@agent-factory). Mise a jour de CLAUDE.md et orchestrator.md. | Pourrait mentionner la coordination avec @orchestrator pour l'insertion dans le pipeline. |
| 36 | Migrer la stack technique | **9/10** | Pattern autonomie present. Placeholders contextuels avec exemples. Chainage @fullstack -> @infrastructure. Livrables avec chemins. Recommandation progressive explicite. | Rien de significatif. |
| 37 | Internationaliser (i18n) | **8/10** | Chainage @fullstack -> @copywriter. Livrables specifies. Choix technique mentionne (librairie i18n). | Pattern autonomie present pour brand-voice mais absent pour les fichiers source i18n. Pourrait mentionner @seo pour hreflang. |
| 38 | Post-mortem incident | **8/10** | Chainage @infrastructure -> @qa. Timeline detaillee demandee. Tests de non-regression en sortie. | Presuppose que Sentry et UptimeRobot sont configures -- pas de fallback si non. Le prompt pourrait mentionner le chemin docs/qa/qa-strategy.md plus tot. |

---

## Note globale de la bibliotheque

**7.6 / 10**

Distribution des notes :
- 9/10 : 13 prompts (34%) -- excellent
- 8/10 : 9 prompts (24%) -- bon
- 7/10 : 4 prompts (11%) -- correct
- 6/10 : 3 prompts (8%) -- insuffisant
- 5/10 : 3 prompts (8%) -- faible
- 4/10 : 1 prompt (3%) -- mauvais

La bibliotheque est globalement bien construite. Les prompts recents (post-audit) sont nettement meilleurs que les prompts originaux non revisites. Le pattern "pose-moi les questions pour creer le fichier manquant" est le principal facteur de qualite.

---

## Les 5 prompts les plus faibles -- corrections a appliquer

### 1. Prompt #14 -- Integrer le paiement Stripe (4/10)

**Probleme** : le prompt le plus faible de la bibliotheque. Trois agents invoques en une ligne chacun, sans chemins de livrables, sans references amont, sans gestion des fichiers manquants.

**Correction exacte a appliquer** :

```
AVANT :
"@fullstack Integre Stripe Checkout : webhook /api/stripe/webhook, gestion des
abonnements, portail client. @legal Verifie la conformite CGV. @infrastructure
Configure les variables d'environnement et le monitoring des paiements."

APRES :
"@fullstack Lis docs/product/functional-specs.md (plans tarifaires, pricing). S'il
n'existe pas, pose-moi les questions pour specifier les plans (nombre de tiers, prix,
features par tier, essai gratuit oui/non) et genere les specs avant de coder. Integre
Stripe Checkout : route API /api/stripe/webhook (signature verification), gestion des
abonnements (creation, upgrade, downgrade, annulation), portail client Stripe.
Livrables : code dans src/app/api/stripe/. Puis @legal : lis
docs/product/functional-specs.md et verifie la conformite des CGV avec le modele
d'abonnement implemente. Mets a jour docs/legal/cgu-draft.md (section paiements,
remboursements, resiliation). Puis @infrastructure : liste les variables
d'environnement Stripe a configurer dans Replit Secrets (STRIPE_SECRET_KEY,
STRIPE_WEBHOOK_SECRET, STRIPE_PRICE_ID_*). Ajoute le monitoring webhook (alertes si
taux d'echec >1%). Mets a jour docs/infra/infrastructure.md."
```

### 2. Prompt #7 -- KPIs & tracking plan (5/10)

**Probleme** : prompt vague sans chemins, sans references amont, sans gestion des fichiers manquants. L'agent @data-analyst a un protocole riche qui n'est pas exploite.

**Correction exacte a appliquer** :

```
AVANT :
"@data-analyst Definis la North Star Metric et les KPIs AARRR. Produis le tracking
plan complet : chaque event, sa source, son trigger. Specs de dashboard pretes pour
l'outil analytics choisi."

APRES :
"@data-analyst Lis docs/product/product-vision.md et docs/product/roadmap.md (objectif,
KPI North Star, features planifiees). S'ils n'existent pas, pose-moi les questions pour
les creer (objectif a 6 mois, KPI North Star, features MVP, modele economique) et
genere-les avant de continuer. Definis la North Star Metric avec sa formule de calcul.
Produis les KPIs AARRR avec valeurs cibles par etape. Produis le tracking plan
complet : chaque event (nom, trigger, proprietes, type), naming convention, outil
analytics recommande selon le budget. Specs de dashboard prets a implementer.
Livrables : docs/analytics/kpi-framework.md + docs/analytics/tracking-plan.md +
docs/analytics/dashboard-specs.md."
```

### 3. Prompt #19 -- Visibilite IA generatives GEO (5/10)

**Probleme** : prompt trop vague pour un agent qui a un protocole de calibration detaille. Pas de chemins, pas de references amont, pas d'autonomie.

**Correction exacte a appliquer** :

```
AVANT :
"@geo Analyse notre visibilite actuelle sur les IA generatives. Propose le plan GEO :
entites nommees, claims verifiables, FAQ optimisee pour les citations IA,
restructuration du contenu pour le format LLM-friendly."

APRES :
"@geo Lis docs/seo/seo-strategy.md et docs/seo/keyword-map.md (strategie SEO, pages
cibles). S'ils n'existent pas, pose-moi les questions pour les creer (mots-cles
principaux, pages existantes, objectif de visibilite) et genere-les avant de continuer.
Lis aussi docs/strategy/brand-platform.md (entites de marque). Analyse la visibilite
actuelle sur ChatGPT, Claude, Gemini, Perplexity (via WebSearch). Propose le plan
GEO : entites nommees a pousser, claims verifiables avec sources, FAQ optimisee pour
les citations IA, restructuration du contenu existant en format LLM-friendly.
Livrable : docs/geo/geo-strategy.md + docs/geo/content-restructuring.md."
```

### 4. Prompt #16 -- Configurer CI/CD & deploiement (5/10)

**Probleme** : trop telegraphique, ignore les protocoles riches des agents @qa et @infrastructure.

**Correction exacte a appliquer** :

```
AVANT :
"@qa Ecris le workflow GitHub Actions : lint, type-check, Vitest, Playwright.
@infrastructure Configure le deploiement (Replit/.replit + replit.nix), health check
/api/health, monitoring Sentry + UptimeRobot."

APRES :
"@qa Lis le code dans src/ et docs/qa/qa-strategy.md s'il existe. Ecris le workflow
GitHub Actions (.github/workflows/ci.yml) : lint (ESLint), type-check (tsc --noEmit),
tests unitaires Vitest, tests E2E Playwright. Definis les seuils bloquants (couverture
>80%, Lighthouse scores). Livrable : .github/workflows/ci.yml +
docs/qa/qa-strategy.md mis a jour. Puis @infrastructure : lis
docs/infra/infrastructure.md s'il existe. Configure la compatibilite Replit (.replit +
replit.nix). Cree la route /api/health (status, version, uptime). Configure Sentry
(Next.js, source maps) + UptimeRobot (endpoint /api/health, intervalle 5min). Documente
les variables d'environnement a configurer dans Replit Secrets. Livrable :
docs/infra/infrastructure.md + code dans src/app/api/health/."
```

### 5. Prompt #5 -- Positionnement & plateforme de marque (6/10)

**Probleme** : pas de chemins de livrables en sortie. Pas de pattern autonomie alors que l'agent a des champs critiques. Prompt trop court pour un agent fondamental.

**Correction exacte a appliquer** :

```
AVANT :
"@creative-strategy Analyse project-context.md et produis la plateforme de marque
complete : positionnement, personas detailles avec jobs-to-be-done, benchmark
concurrentiel, et brief creatif."

APRES :
"@creative-strategy Analyse project-context.md. Si les champs Secteur, Persona
principal, Probleme principal ou Alternative actuelle sont insuffisants, pose-moi les
questions pour les completer avant de continuer. Benchmark 3-5 concurrents via
WebSearch. Produis la plateforme de marque complete : positionnement (territoire,
promesse, preuve, ton), personas detailles avec jobs-to-be-done et objections,
benchmark concurrentiel (espaces occupes vs libres), et brief creatif. Livrables :
docs/strategy/brand-platform.md + docs/strategy/personas.md +
docs/strategy/competitive-benchmark.md + docs/strategy/creative-brief.md."
```

---

## Les 5 prompts les mieux rediges (modeles de reference)

### 1. Prompt #23 -- Emails onboarding & conversion (9/10)

**Pourquoi c'est un modele** :
- Pattern autonomie avec questions specifiques par prerequis ("brand-voice : ton, registre, vocabulaire ; onboarding : etapes cles, premier moment de valeur")
- Format de sortie ultra-precis (objet + preview text + corps + CTA)
- Sequence temporelle explicite (J+0, J+1, J+3, J+7, J+14)
- Chainage @copywriter -> @growth avec handoff explicite (triggers, KPIs, segmentation)
- Chemin livrable pour chaque agent

### 2. Prompt #34 -- Optimiser l'onboarding (9/10)

**Pourquoi c'est un modele** :
- Triple chainage @ux -> @copywriter -> @data-analyst avec dependances claires
- Pattern autonomie generalise ("pour chaque fichier manquant")
- Objectif quantifie mesurable (time-to-value <3 min)
- Seuil d'alerte specifique (drops >20%)
- Couvre le cycle complet : conception -> redaction -> mesure

### 3. Prompt #20 -- SEO + GEO combines (9/10)

**Pourquoi c'est un modele** :
- Chainage explicite @seo -> @geo avec livrable intermediaire nomme
- Demande une section "Synergies SEO<->GEO" -- force la coordination
- Reutilisation des memes pages cibles entre agents -- zero travail redondant
- Chemins de livrables pour les deux agents

### 4. Prompt #6 -- Vision produit & roadmap (9/10)

**Pourquoi c'est un modele** :
- Pattern autonomie avec questions specifiques si fichier amont absent
- Trois livrables avec chemins complets
- Format user stories specifie avec template exact
- Horizon temporel parametrable avec defaut intelligent

### 5. Prompt #26 -- Revue intermediaire (9/10)

**Pourquoi c'est un modele** :
- Axes de coherence precis avec chemins de fichiers source et cible
- Format de sortie structure (statut OK/Warning/Blocker par axe)
- Chemin livrable specifique (docs/reviews/mid-review.md)
- Scope clairement intermediaire -- pas de pretention a l'exhaustivite

---

## Recommandations transversales

### Patterns a generaliser (presents dans les bons prompts, absents dans les faibles)

1. **Pattern autonomie obligatoire** : "Lis [fichier]. S'il n'existe pas, pose-moi les questions necessaires pour le creer et genere-le avant de continuer."
   - **Present dans** : 15/38 prompts (39%)
   - **Devrait etre dans** : au moins 30/38 prompts (79%)
   - **Manquant dans** : #2, #3, #4, #5, #7, #14, #16, #18, #19, #25, #27, #29, #30

2. **Chemins de livrables explicites** : specifier le chemin complet du fichier de sortie
   - **Present dans** : 25/38 prompts (66%)
   - **Manquant dans** : #2, #3, #4, #5, #7, #11, #14, #16, #19, #25, #27, #29, #30

3. **References amont explicites** : mentionner les fichiers a lire avec leur chemin
   - **Present dans** : 28/38 prompts (74%)
   - **Manquant dans** : #2, #7, #14, #16, #19, #25, #27, #29, #30

### Anti-patterns a supprimer

1. **Prompt telegraphique multi-agents** : invoquer 2-3 agents en une ligne chacun sans specification. Probleme : chaque agent a un protocole riche qui n'est pas exploite.
   - **Exemples** : #14 (Stripe), #16 (CI/CD)
   - **Correction** : chaque agent invoque doit avoir au minimum : fichier amont a lire, livrable avec chemin, et pattern autonomie si prerequis potentiellement absent

2. **Absence de gestion du cas "aucun livrable"** : certains prompts d'audit/revue ne gerent pas le cas ou il n'y a rien a auditer.
   - **Exemples** : #3, #25, #27
   - **Correction** : ajouter une condition "Si aucun [livrable] n'existe, signale-le et propose les etapes pour le creer"

3. **References conditionnelles sans fallback** : "Lis X s'il existe" sans dire quoi faire s'il n'existe pas.
   - **Exemples** : #13, #18
   - **Correction** : transformer en pattern autonomie complet ou specifier le comportement de fallback

### Evaluation du pattern "pose-moi les questions pour creer le fichier manquant"

Ce pattern est le differenciateur principal entre les prompts notes 9/10 et ceux notes 5-6/10.

| Statut | Nombre | Pourcentage |
|---|---|---|
| Pattern present et bien implemente | 15 | 39% |
| Pattern present mais incomplet (questions non specifiques) | 3 | 8% |
| Pattern absent alors qu'il devrait etre present | 13 | 34% |
| Pattern non necessaire (agent sans prerequis fichier) | 7 | 18% |

**Verdict** : le pattern est present dans moins de la moitie des prompts eligibles. C'est le principal axe d'amelioration.

**Prompts prioritaires pour l'ajout du pattern** (impact eleve car agents fondamentaux) :
1. #5 -- Positionnement (agent fondamental, tous les autres en dependent)
2. #7 -- KPIs & tracking (prerequis pour la mesure de tout le projet)
3. #14 -- Stripe (integration critique, specs souvent manquantes)
4. #19 -- GEO (agent sous-utilise faute de prompt adequat)
5. #16 -- CI/CD (prerequis pour la qualite du projet)

---

## Verdict final et plan d'action priorise

### Diagnostic

La bibliotheque de prompts est **fonctionnelle et bien structuree** dans son organisation par phases. Les prompts recents (post-audit precedent) sont nettement superieurs aux prompts non revisites. La qualite est bimodale : soit le prompt est excellent (9/10), soit il est sous-developpe (4-6/10). Il n'y a presque pas de prompts "moyens" -- ce qui suggere que l'application du pattern autonomie est un facteur binaire de qualite.

### Plan d'action (par priorite)

**P0 -- Corrections critiques (a faire immediatement)**

1. Reecrire le prompt #14 (Stripe) selon la correction proposee ci-dessus
2. Reecrire le prompt #7 (KPIs) selon la correction proposee ci-dessus
3. Reecrire le prompt #16 (CI/CD) selon la correction proposee ci-dessus

**P1 -- Ajout du pattern autonomie (a faire cette semaine)**

4. Ajouter le pattern "pose-moi les questions" aux prompts #5, #18, #19, #25, #27, #29, #30
5. Ajouter les chemins de livrables manquants aux prompts #2, #3, #4, #11, #25, #29, #30
6. Reecrire le prompt #19 (GEO) selon la correction proposee ci-dessus

**P2 -- Ameliorations de confort (a faire au prochain sprint)**

7. Ajouter la gestion du cas "project-context.md existe deja" au prompt #1 (Demarrage)
8. Ajouter des references amont aux prompts #27 (QA) et #29 (Elon)
9. Standardiser les prompts "Tout-en-un" avec des livrables de sortie explicites
10. Ajouter une mention @seo au prompt #37 (i18n) pour le hreflang

**P3 -- Evolution structurelle (backlog)**

11. Creer un prompt de "mise a jour de project-context.md" (necessaire pour le prompt #4 Pivoter)
12. Standardiser un format de prerequis pour les prompts d'audit (donnees analytics a fournir)
13. Envisager un systeme de "prompt builder" qui pre-remplit les placeholders depuis project-context.md

---

**Handoff -> @orchestrator**
- Fichiers produits : `/home/user/Agent-Team/docs/ia/prompts-audit-ia.md`
- Decisions prises : 38 prompts audites, note globale 7.6/10, 5 corrections textuelles exactes fournies pour les prompts les plus faibles
- Points d'attention : 13 prompts manquent du pattern autonomie -- c'est le principal axe d'amelioration. Les 3 corrections P0 (Stripe, KPIs, CI/CD) sont a appliquer en priorite dans `index.html`. Le prompt #14 (Stripe) est le plus critique a 4/10.
