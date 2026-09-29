# Revue qualité des 6 nouveaux prompts — Gradient Agents

**Date** : 2026-03-26
**Reviewer** : @ia (agent IA, rôle reviewer prompts)
**Méthode** : evaluation sur 5 critères /5, calibree sur les prompts de référence (Pipeline RAG ligne 1513, Disaster recovery ligne 1536, Gestion cookies ligne 1491)

---

## Prompt 1 : Vision long terme et moat (ligne 997)

**Agents** : elon, product-manager, creative-strategy
**Catégorie** : Phase 0 — Stratégie

### Evaluation

| Critère | Note | Justification |
|---|---|---|
| Completude | 5/5 | Les 6 dimensions du moat sont exhaustives (network effects, data, switching costs, brand, tech, vitesse). La chaîne agent couvre audit → plan produit → ajustement positionnement. Rien ne manque. |
| Cohérence | 5/5 | Respecte la convention : lecture de project-context.md + livrables amont, fallback si absents. Livrables dans les bons dossiers (docs/reviews/, docs/product/, docs/strategy/). Le chainage elon → product-manager → creative-strategy est logique. |
| Actionnabilite | 5/5 | Chaque dimension du moat a une grille de notation /10 avec justification. Les 3 scénarios de disruption sont demandes avec réponse produit. Les jalons mesurables sont exiges. |
| Specificite | 4/5 | Le prompt mentionne project-context.md mais ne référence pas explicitement PostgreSQL Replit ou le persona Thomas. Cependant, la nature stratégique du prompt le rend legitimement générique — il s'adapte via project-context.md. Acceptable. |
| Qualité redactionnelle | 5/5 | Structure claire, instructions numerotees, le champ "quand" est précis et differencie ce prompt de l'audit first principles. Niveau equivalent aux meilleurs prompts existants. |

- **Moyenne : 4.8/5 → 9.6/10**
- Doublons/overlap : complementaire a "Audit stratégique first principles" (ligne 2193) — le "quand" le précise. Pas de doublon.
- Corrections nécessaires : Aucune.

---

## Prompt 2 : Design système de notifications (ligne 1282)

**Agents** : ux, design, fullstack
**Catégorie** : Phase 1 — Conception

### Evaluation

| Critère | Note | Justification |
|---|---|---|
| Completude | 5/5 | Les 6 volets couvrent tout : taxonomie, canaux, regroupement/frequence, centre de notifications, préférences utilisateur, parcours de permission push. Le volet fullstack detaille le schema PostgreSQL, les API routes, les composants React et le real-time. |
| Cohérence | 5/5 | Lecture de project-context.md, user-flows.md, functional-specs.md. Livrables dans les bons dossiers (docs/ux/, docs/design/, code dans src/). Respecte la convention de design tokens. Le chainage ux → design → fullstack est la sequence standard du framework. |
| Actionnabilite | 5/5 | Le schema PostgreSQL est specifie (colonnes exactes avec types JSONB). Les API routes sont listees avec verbes HTTP. Les composants React sont nommes. Le real-time a deux options (SSE ou polling 10s). Zéro ambiguite pour @fullstack. |
| Specificite | 5/5 | Référence explicite PostgreSQL (cohérent avec la stack Replit). Les composants React sont nommes selon les conventions du framework. Le cap quotidien (5 push, 3 emails) et les quiet hours (22h-8h) sont des choix calibres. |
| Qualité redactionnelle | 5/5 | Le champ "quand" est excellent : "Les notifications mal concues sont la première cause de desactivation — trop = spam, pas assez = utilisateur perdu." Concis, actionnable, bien structure. |

- **Moyenne : 5.0/5 → 10/10**
- Doublons/overlap : pas de prompt existant sur les notifications. Unique.
- Corrections nécessaires : Aucune. Prompt exemplaire.

---

## Prompt 3 : Data pipeline et ETL (ligne 1631)

**Agents** : ia, infrastructure, fullstack
**Catégorie** : Phase 2 — Développement

### Evaluation

| Critère | Note | Justification |
|---|---|---|
| Completude | 5/5 | Les 6 volets couvrent l'ensemble du pipeline : sources/ingestion, transformation, stockage, orchestration, monitoring, idempotence. La chaîne agent couvre architecture → infrastructure → implementation. |
| Cohérence | 5/5 | @ia produit dans docs/ia/ (correct). @infrastructure met à jour docs/infra/infrastructure.md (correct). @fullstack code dans src/lib/pipelines/ (cohérent avec la convention src/lib/ai/ elargie). Lecture des livrables amont respectee. |
| Actionnabilite | 5/5 | Le schema de stockage est précis (staging → clean → aggregated). Le retry est specifie (backoff exponentiel, 3 tentatives, dead letter queue). Le code demande est detaille : connecteurs, transformateurs, schema Prisma, route admin, tests unitaires. |
| Specificite | 5/5 | Référence explicite a PostgreSQL Replit comme destination. Partitionnement si > 1M lignes/mois (calibre pour un SaaS en croissance). Crons Replit pour le scheduling. Alternative Railway/fly.io si depassement — connaissance de l'ecosysteme. |
| Qualité redactionnelle | 5/5 | Le "quand" est précis et concret. Le prompt suit exactement la même structure que Pipeline RAG (référence). Le niveau de detail est comparable. |

- **Moyenne : 5.0/5 → 10/10**
- Doublons/overlap : complementaire a "Pipeline RAG" (ligne 1513) qui est spécifique au RAG. Ce prompt couvre les pipelines de données génériques. Pas de doublon.
- Corrections nécessaires : Aucune. Prompt exemplaire.

---

## Prompt 4 : Fine-tuning et prompt engineering avance (ligne 1658)

**Agents** : ia, data-analyst
**Catégorie** : Phase 2 — Développement

### Evaluation

| Critère | Note | Justification |
|---|---|---|
| Completude | 5/5 | Les 7 volets couvrent tout le spectre : inventaire, stratégies d'optimisation (few-shot, CoT, structured output, compression), selection de modèle, prompt library, fallback chains, A/B testing, optimisation des coûts. Le volet data-analyst ajoute le monitoring. |
| Cohérence | 5/5 | Aligne avec le protocole @ia (grille de selection de modèle, ROI, prompt caching). Livrables dans docs/ia/ (correct). La matrice Haiku/Sonnet/Opus par complexité est cohérente avec la stratégie de modèles de CLAUDE.md. Le data-analyst met à jour docs/analytics/tracking-plan.md (correct). |
| Actionnabilite | 5/5 | Chaque technique d'optimisation est concrete avec l'impact attendu (ex : "réduire les erreurs de parsing de >80%"). Le A/B testing framework a un seuil minimum (100 executions par variante). Les alertes ont des seuils (coût > 120%, erreur > 5%). |
| Specificite | 4/5 | Le prompt ne mentionne pas explicitement le persona ou PostgreSQL Replit, mais c'est normal pour un prompt d'optimisation IA. Il référence bien le framework Gradient Agents via la matrice Haiku/Sonnet/Opus. |
| Qualité redactionnelle | 5/5 | Le "quand" est accrocheur et pedagogique : "un prompt 2x meilleur coute souvent 3x moins cher". Les instructions sont precises sans être verbeuses. |

- **Moyenne : 4.8/5 → 9.6/10**
- Doublons/overlap : overlap partiel avec "Choisir & optimiser les modèles IA" (ligne 1417). MAIS la differentiation est claire : ligne 1417 = choix initial de modèle + architecture ; ligne 1658 = optimisation des prompts existants en production. Le "quand" le précise bien ("prompts actuels trop couteux ou inconsistants"). Overlap gere.
- Corrections nécessaires : Aucune.

---

## Prompt 5 : Automatisation marketing complete (ligne 2056)

**Agents** : growth, ia, fullstack, copywriter
**Catégorie** : Phase 4 — Acquisition

### Evaluation

| Critère | Note | Justification |
|---|---|---|
| Completude | 5/5 | Les 7 volets couvrent l'ensemble : audit des canaux, pipeline IA, scheduling, repurposing cross-canal, triggers comportementaux, metriques/feedback loop, garde-fous qualité. 4 agents chainent stratégie → prompts IA → code → templates. |
| Cohérence | 5/5 | Référence explicite la règle CLAUDE.md "Automatisation par défaut du contenu récurrent" — c'est le prompt qui materialise cette règle. Livrables dans les bons dossiers (docs/growth/, docs/ia/, docs/copy/). Le "quand" cite la règle "ne jamais recommander une stratégie de contenu manuelle". |
| Actionnabilite | 5/5 | Le workflow est detaille : génération → review humain (5 min) → publication. Les API routes sont specifiees (/api/admin/content/generate, /queue, /approve). L'objectif de performance est mesurable (contenu IA ≥ 80% de la performance manuelle). Le temps de review cible est realiste (< 30 min/jour). |
| Specificite | 5/5 | Calibre pour un fondateur solo (référence explicite : "un fondateur solo ne peut pas produire 20 posts/semaine"). Référence les outils du framework (Buffer, Typefully, Resend). Le garde-fou qualité inclut la conformite RGPD. |
| Qualité redactionnelle | 5/5 | Le "quand" est le meilleur de la serie — il contextualise parfaitement le problème et la solution. La structure suit le pattern des prompts de référence. Le rappel explicite de la règle CLAUDE.md est une bonne pratique de cohérence. |

- **Moyenne : 5.0/5 → 10/10**
- Doublons/overlap : overlap delibere avec "Stratégie d'emailing automation" (ligne 2031). L'emailing automation couvre le detail des sequences email ; ce prompt couvre l'ensemble des canaux avec l'email comme un sous-ensemble. Le prompt le reconnait lui-meme ("voir prompt Emailing automation pour le detail"). Cross-reference propre.
- Corrections nécessaires : Aucune. Prompt exemplaire.

---

## Prompt 6 : Evaluation des outputs IA (evals) (ligne 2286)

**Agents** : ia, qa, data-analyst
**Catégorie** : Phase 5 — Audit & Validation

### Evaluation

| Critère | Note | Justification |
|---|---|---|
| Completude | 5/5 | Les 6 volets couvrent le framework complet : métriques par use case, golden dataset, LLM-as-judge, pipeline automatise, alertes de degradation, dashboard. La chaîne agent couvre framework → CI/CD → tracking. Tests adversariaux inclus. |
| Cohérence | 5/5 | @ia produit dans docs/ia/ (correct). @qa met à jour docs/qa/qa-strategy.md (correct). @data-analyst met à jour docs/analytics/tracking-plan.md (correct). Le LLM-as-judge recommande Claude Sonnet — cohérent avec la stratégie de modèles CLAUDE.md. Golden datasets dans tests/evals/ — convention de dossier cohérente. |
| Actionnabilite | 5/5 | Le golden dataset a un minimum (50 cas par use case) avec format specifie (JSON avec champs nommes). La calibration du juge a un seuil (correlation > 0.8). Les seuils d'alerte sont quantifies (pertinence > 3.5/5, factualite > 95%). Le rollback automatique est prévu. |
| Specificite | 4.5/5 | Les métriques par use case sont detaillees pour chaque type (génération, RAG, classification, extraction). La référence a Claude Sonnet comme juge est spécifique au framework. Léger manque : pas de référence au budget IA pour le coût des evals elles-memes (les appels LLM-as-judge coutent des tokens). |
| Qualité redactionnelle | 5/5 | Le "quand" est excellent : "Sans evals, tu navigues a l'aveugle — un changement de prompt ou de modèle peut degrader silencieusement la qualité." Instructions claires, bien structurees, niveau equivalent aux meilleurs prompts. |

- **Moyenne : 4.9/5 → 9.8/10**
- Doublons/overlap : complementaire a "Fine-tuning et prompt engineering avance" (ligne 1658) qui optimise les prompts, alors que celui-ci mesure la qualité. Pas de doublon — les deux se completent (optimiser puis evaluer).
- Corrections nécessaires : une amélioration mineure possible.

### Amélioration suggeree (non bloquante)

Ajouter une mention du coût des evals dans le volet 7 (absent) ou dans le volet 4 :

**Localisation** : ligne 2299, après "pipeline d'evaluation automatise"
**Ajout suggere** : Dans la section 4, ajouter après la dernière phrase :
> "Estimer le coût mensuel du pipeline d'evals (tokens LLM-as-judge × nombre de cas × fréquence) et l'inclure dans docs/ia/ai-cost-analysis.md."

Cet ajout alignerait le prompt avec le protocole @ia qui exige un ROI pour chaque appel LLM.

---

## Synthese

### Prompts a 9/10+ (validation sans correction)

| Prompt | Score | Statut |
|---|---|---|
| Design système de notifications | 10/10 | Exemplaire |
| Data pipeline et ETL | 10/10 | Exemplaire |
| Automatisation marketing complete | 10/10 | Exemplaire |
| Evaluation des outputs IA (evals) | 9.8/10 | Valide (amélioration mineure suggeree) |
| Vision long terme et moat | 9.6/10 | Valide |
| Fine-tuning et prompt engineering avance | 9.6/10 | Valide |

### Prompts necessitant correction

**Aucun prompt ne necessite de correction bloquante.** Les 6 prompts sont au-dessus du seuil de 4.5/5 (9/10) exige par le framework.

### Observations transversales

1. **Qualité homogene** : les 6 prompts sont au même niveau que les meilleurs prompts existants (Pipeline RAG, Disaster recovery). Le format (title, agents, quand, prompt) est respecte partout.

2. **Chaines d'agents logiques** : chaque prompt assigne le bon agent a la bonne tâche. Aucune inversion de responsabilite détectée.

3. **Livrables bien routes** : tous les livrables pointent vers les bons dossiers (docs/ia/, docs/growth/, docs/ux/, docs/design/, docs/qa/, docs/analytics/).

4. **Critères de validation spécifiques et mesurables** : chaque prompt termine par des critères concrets (pas de "le livrable est de qualité" mais des seuils quantifies).

5. **Pas de doublon problematique** : les overlaps identifies (Fine-tuning vs Choisir modèles, Automatisation marketing vs Emailing automation) sont geres par des "quand" differencies et des cross-references explicites.

6. **Seul point d'amélioration global** : les prompts IA (Fine-tuning, Evals) pourraient systématiquement inclure le coût des operations IA elles-memes (evals, A/B testing de prompts) dans le budget — cohérent avec le protocole @ia qui exige un ROI pour chaque appel LLM.
