# Revue qualite des 6 nouveaux prompts — Gradient Agents

**Date** : 2026-03-26
**Reviewer** : @ia (agent IA, role reviewer prompts)
**Methode** : evaluation sur 5 criteres /5, calibree sur les prompts de reference (Pipeline RAG ligne 1513, Disaster recovery ligne 1536, Gestion cookies ligne 1491)

---

## Prompt 1 : Vision long terme et moat (ligne 997)

**Agents** : elon, product-manager, creative-strategy
**Categorie** : Phase 0 — Strategie

### Evaluation

| Critere | Note | Justification |
|---|---|---|
| Completude | 5/5 | Les 6 dimensions du moat sont exhaustives (network effects, data, switching costs, brand, tech, vitesse). La chaine agent couvre audit → plan produit → ajustement positionnement. Rien ne manque. |
| Coherence | 5/5 | Respecte la convention : lecture de project-context.md + livrables amont, fallback si absents. Livrables dans les bons dossiers (docs/reviews/, docs/product/, docs/strategy/). Le chainage elon → product-manager → creative-strategy est logique. |
| Actionnabilite | 5/5 | Chaque dimension du moat a une grille de notation /10 avec justification. Les 3 scenarios de disruption sont demandes avec reponse produit. Les jalons mesurables sont exiges. |
| Specificite | 4/5 | Le prompt mentionne project-context.md mais ne reference pas explicitement PostgreSQL Replit ou le persona Thomas. Cependant, la nature strategique du prompt le rend legitimement generique — il s'adapte via project-context.md. Acceptable. |
| Qualite redactionnelle | 5/5 | Structure claire, instructions numerotees, le champ "quand" est precis et differencie ce prompt de l'audit first principles. Niveau equivalent aux meilleurs prompts existants. |

- **Moyenne : 4.8/5 → 9.6/10**
- Doublons/overlap : complementaire a "Audit strategique first principles" (ligne 2193) — le "quand" le precise. Pas de doublon.
- Corrections necessaires : Aucune.

---

## Prompt 2 : Design systeme de notifications (ligne 1282)

**Agents** : ux, design, fullstack
**Categorie** : Phase 1 — Conception

### Evaluation

| Critere | Note | Justification |
|---|---|---|
| Completude | 5/5 | Les 6 volets couvrent tout : taxonomie, canaux, regroupement/frequence, centre de notifications, preferences utilisateur, parcours de permission push. Le volet fullstack detaille le schema PostgreSQL, les API routes, les composants React et le real-time. |
| Coherence | 5/5 | Lecture de project-context.md, user-flows.md, functional-specs.md. Livrables dans les bons dossiers (docs/ux/, docs/design/, code dans src/). Respecte la convention de design tokens. Le chainage ux → design → fullstack est la sequence standard du framework. |
| Actionnabilite | 5/5 | Le schema PostgreSQL est specifie (colonnes exactes avec types JSONB). Les API routes sont listees avec verbes HTTP. Les composants React sont nommes. Le real-time a deux options (SSE ou polling 10s). Zero ambiguite pour @fullstack. |
| Specificite | 5/5 | Reference explicite PostgreSQL (coherent avec la stack Replit). Les composants React sont nommes selon les conventions du framework. Le cap quotidien (5 push, 3 emails) et les quiet hours (22h-8h) sont des choix calibres. |
| Qualite redactionnelle | 5/5 | Le champ "quand" est excellent : "Les notifications mal concues sont la premiere cause de desactivation — trop = spam, pas assez = utilisateur perdu." Concis, actionnable, bien structure. |

- **Moyenne : 5.0/5 → 10/10**
- Doublons/overlap : pas de prompt existant sur les notifications. Unique.
- Corrections necessaires : Aucune. Prompt exemplaire.

---

## Prompt 3 : Data pipeline et ETL (ligne 1631)

**Agents** : ia, infrastructure, fullstack
**Categorie** : Phase 2 — Developpement

### Evaluation

| Critere | Note | Justification |
|---|---|---|
| Completude | 5/5 | Les 6 volets couvrent l'ensemble du pipeline : sources/ingestion, transformation, stockage, orchestration, monitoring, idempotence. La chaine agent couvre architecture → infrastructure → implementation. |
| Coherence | 5/5 | @ia produit dans docs/ia/ (correct). @infrastructure met a jour docs/infra/infrastructure.md (correct). @fullstack code dans src/lib/pipelines/ (coherent avec la convention src/lib/ai/ elargie). Lecture des livrables amont respectee. |
| Actionnabilite | 5/5 | Le schema de stockage est precis (staging → clean → aggregated). Le retry est specifie (backoff exponentiel, 3 tentatives, dead letter queue). Le code demande est detaille : connecteurs, transformateurs, schema Prisma, route admin, tests unitaires. |
| Specificite | 5/5 | Reference explicite a PostgreSQL Replit comme destination. Partitionnement si > 1M lignes/mois (calibre pour un SaaS en croissance). Crons Replit pour le scheduling. Alternative Railway/fly.io si depassement — connaissance de l'ecosysteme. |
| Qualite redactionnelle | 5/5 | Le "quand" est precis et concret. Le prompt suit exactement la meme structure que Pipeline RAG (reference). Le niveau de detail est comparable. |

- **Moyenne : 5.0/5 → 10/10**
- Doublons/overlap : complementaire a "Pipeline RAG" (ligne 1513) qui est specifique au RAG. Ce prompt couvre les pipelines de donnees generiques. Pas de doublon.
- Corrections necessaires : Aucune. Prompt exemplaire.

---

## Prompt 4 : Fine-tuning et prompt engineering avance (ligne 1658)

**Agents** : ia, data-analyst
**Categorie** : Phase 2 — Developpement

### Evaluation

| Critere | Note | Justification |
|---|---|---|
| Completude | 5/5 | Les 7 volets couvrent tout le spectre : inventaire, strategies d'optimisation (few-shot, CoT, structured output, compression), selection de modele, prompt library, fallback chains, A/B testing, optimisation des couts. Le volet data-analyst ajoute le monitoring. |
| Coherence | 5/5 | Aligne avec le protocole @ia (grille de selection de modele, ROI, prompt caching). Livrables dans docs/ia/ (correct). La matrice Haiku/Sonnet/Opus par complexite est coherente avec la strategie de modeles de CLAUDE.md. Le data-analyst met a jour docs/analytics/tracking-plan.md (correct). |
| Actionnabilite | 5/5 | Chaque technique d'optimisation est concrete avec l'impact attendu (ex : "reduire les erreurs de parsing de >80%"). Le A/B testing framework a un seuil minimum (100 executions par variante). Les alertes ont des seuils (cout > 120%, erreur > 5%). |
| Specificite | 4/5 | Le prompt ne mentionne pas explicitement le persona ou PostgreSQL Replit, mais c'est normal pour un prompt d'optimisation IA. Il reference bien le framework Gradient Agents via la matrice Haiku/Sonnet/Opus. |
| Qualite redactionnelle | 5/5 | Le "quand" est accrocheur et pedagogique : "un prompt 2x meilleur coute souvent 3x moins cher". Les instructions sont precises sans etre verbeuses. |

- **Moyenne : 4.8/5 → 9.6/10**
- Doublons/overlap : overlap partiel avec "Choisir & optimiser les modeles IA" (ligne 1417). MAIS la differentiation est claire : ligne 1417 = choix initial de modele + architecture ; ligne 1658 = optimisation des prompts existants en production. Le "quand" le precise bien ("prompts actuels trop couteux ou inconsistants"). Overlap gere.
- Corrections necessaires : Aucune.

---

## Prompt 5 : Automatisation marketing complete (ligne 2056)

**Agents** : growth, ia, fullstack, copywriter
**Categorie** : Phase 4 — Acquisition

### Evaluation

| Critere | Note | Justification |
|---|---|---|
| Completude | 5/5 | Les 7 volets couvrent l'ensemble : audit des canaux, pipeline IA, scheduling, repurposing cross-canal, triggers comportementaux, metriques/feedback loop, garde-fous qualite. 4 agents chainent strategie → prompts IA → code → templates. |
| Coherence | 5/5 | Reference explicite la regle CLAUDE.md "Automatisation par defaut du contenu recurrent" — c'est le prompt qui materialise cette regle. Livrables dans les bons dossiers (docs/growth/, docs/ia/, docs/copy/). Le "quand" cite la regle "ne jamais recommander une strategie de contenu manuelle". |
| Actionnabilite | 5/5 | Le workflow est detaille : generation → review humain (5 min) → publication. Les API routes sont specifiees (/api/admin/content/generate, /queue, /approve). L'objectif de performance est mesurable (contenu IA ≥ 80% de la performance manuelle). Le temps de review cible est realiste (< 30 min/jour). |
| Specificite | 5/5 | Calibre pour un fondateur solo (reference explicite : "un fondateur solo ne peut pas produire 20 posts/semaine"). Reference les outils du framework (Buffer, Typefully, Resend). Le garde-fou qualite inclut la conformite RGPD. |
| Qualite redactionnelle | 5/5 | Le "quand" est le meilleur de la serie — il contextualise parfaitement le probleme et la solution. La structure suit le pattern des prompts de reference. Le rappel explicite de la regle CLAUDE.md est une bonne pratique de coherence. |

- **Moyenne : 5.0/5 → 10/10**
- Doublons/overlap : overlap delibere avec "Strategie d'emailing automation" (ligne 2031). L'emailing automation couvre le detail des sequences email ; ce prompt couvre l'ensemble des canaux avec l'email comme un sous-ensemble. Le prompt le reconnait lui-meme ("voir prompt Emailing automation pour le detail"). Cross-reference propre.
- Corrections necessaires : Aucune. Prompt exemplaire.

---

## Prompt 6 : Evaluation des outputs IA (evals) (ligne 2286)

**Agents** : ia, qa, data-analyst
**Categorie** : Phase 5 — Audit & Validation

### Evaluation

| Critere | Note | Justification |
|---|---|---|
| Completude | 5/5 | Les 6 volets couvrent le framework complet : metriques par use case, golden dataset, LLM-as-judge, pipeline automatise, alertes de degradation, dashboard. La chaine agent couvre framework → CI/CD → tracking. Tests adversariaux inclus. |
| Coherence | 5/5 | @ia produit dans docs/ia/ (correct). @qa met a jour docs/qa/qa-strategy.md (correct). @data-analyst met a jour docs/analytics/tracking-plan.md (correct). Le LLM-as-judge recommande Claude Sonnet — coherent avec la strategie de modeles CLAUDE.md. Golden datasets dans tests/evals/ — convention de dossier coherente. |
| Actionnabilite | 5/5 | Le golden dataset a un minimum (50 cas par use case) avec format specifie (JSON avec champs nommes). La calibration du juge a un seuil (correlation > 0.8). Les seuils d'alerte sont quantifies (pertinence > 3.5/5, factualite > 95%). Le rollback automatique est prevu. |
| Specificite | 4.5/5 | Les metriques par use case sont detaillees pour chaque type (generation, RAG, classification, extraction). La reference a Claude Sonnet comme juge est specifique au framework. Leger manque : pas de reference au budget IA pour le cout des evals elles-memes (les appels LLM-as-judge coutent des tokens). |
| Qualite redactionnelle | 5/5 | Le "quand" est excellent : "Sans evals, tu navigues a l'aveugle — un changement de prompt ou de modele peut degrader silencieusement la qualite." Instructions claires, bien structurees, niveau equivalent aux meilleurs prompts. |

- **Moyenne : 4.9/5 → 9.8/10**
- Doublons/overlap : complementaire a "Fine-tuning et prompt engineering avance" (ligne 1658) qui optimise les prompts, alors que celui-ci mesure la qualite. Pas de doublon — les deux se completent (optimiser puis evaluer).
- Corrections necessaires : une amelioration mineure possible.

### Amelioration suggeree (non bloquante)

Ajouter une mention du cout des evals dans le volet 7 (absent) ou dans le volet 4 :

**Localisation** : ligne 2299, apres "pipeline d'evaluation automatise"
**Ajout suggere** : Dans la section 4, ajouter apres la derniere phrase :
> "Estimer le cout mensuel du pipeline d'evals (tokens LLM-as-judge × nombre de cas × frequence) et l'inclure dans docs/ia/ai-cost-analysis.md."

Cet ajout alignerait le prompt avec le protocole @ia qui exige un ROI pour chaque appel LLM.

---

## Synthese

### Prompts a 9/10+ (validation sans correction)

| Prompt | Score | Statut |
|---|---|---|
| Design systeme de notifications | 10/10 | Exemplaire |
| Data pipeline et ETL | 10/10 | Exemplaire |
| Automatisation marketing complete | 10/10 | Exemplaire |
| Evaluation des outputs IA (evals) | 9.8/10 | Valide (amelioration mineure suggeree) |
| Vision long terme et moat | 9.6/10 | Valide |
| Fine-tuning et prompt engineering avance | 9.6/10 | Valide |

### Prompts necessitant correction

**Aucun prompt ne necessite de correction bloquante.** Les 6 prompts sont au-dessus du seuil de 4.5/5 (9/10) exige par le framework.

### Observations transversales

1. **Qualite homogene** : les 6 prompts sont au meme niveau que les meilleurs prompts existants (Pipeline RAG, Disaster recovery). Le format (title, agents, quand, prompt) est respecte partout.

2. **Chaines d'agents logiques** : chaque prompt assigne le bon agent a la bonne tache. Aucune inversion de responsabilite detectee.

3. **Livrables bien routes** : tous les livrables pointent vers les bons dossiers (docs/ia/, docs/growth/, docs/ux/, docs/design/, docs/qa/, docs/analytics/).

4. **Criteres de validation specifiques et mesurables** : chaque prompt termine par des criteres concrets (pas de "le livrable est de qualite" mais des seuils quantifies).

5. **Pas de doublon problematique** : les overlaps identifies (Fine-tuning vs Choisir modeles, Automatisation marketing vs Emailing automation) sont geres par des "quand" differencies et des cross-references explicites.

6. **Seul point d'amelioration global** : les prompts IA (Fine-tuning, Evals) pourraient systematiquement inclure le cout des operations IA elles-memes (evals, A/B testing de prompts) dans le budget — coherent avec le protocole @ia qui exige un ROI pour chaque appel LLM.
