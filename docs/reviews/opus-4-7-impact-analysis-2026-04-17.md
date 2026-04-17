# Opus 4.7 — Impact Analysis pour Gradient Agents

**Date** : 2026-04-17
**Auteur** : @ia
**Contexte** : Opus 4.7 sorti le 16/04/2026. Pricing inchangé (5$/25$ par 1M tokens). Context window 1M (vs 200K). SWE-bench 3x, CursorBench 70%.

---

## 1. TL;DR

- **Pricing identique** : zéro impact budget. Migration Opus 4.6 vers 4.7 = upgrade gratuit en performance.
- **Context window 1M** : les seuils du framework (6 phases, 18 Task, 10 fichiers audit) ont 5x plus de marge, MAIS la discipline anti-timeout reste pertinente (anti-distraction, pas juste anti-overflow).
- **SWE-bench 3x** : la confiance en autonomie augmente pour @fullstack/@qa, mais les guardrails (rules n2, n3) doivent rester -- ce sont des filets de sécurité, pas des compensations de faiblesse.
- **Actions concrètes** : mettre à jour les `model:` headers dans 9 fichiers agents Opus, documenter `xhigh` et task budgets dans ia.md, intégrer `/ultrareview` dans reviewer.md. Ne PAS assouplir les règles anti-timeout.

---

## 2. Tableau des 8 angles d'impact

| # | Angle | Impact | Verdict | Action framework |
|---|---|---|---|---|
| 1 | Context 1M et règle n3 anti-timeout | FAIBLE | **GARDER la règle telle quelle**. La règle n3 protège contre la distraction (61 tool calls sans Write = timeout réel observé session 2026-04-02). Le context window n'était pas la cause du timeout -- c'était le pattern "lire tout avant d'écrire". 1M tokens ne résout pas ce problème comportemental. | Aucune modification de CLAUDE.md |
| 2 | Context 1M et seuils orchestrator | MOYEN | Les seuils (6 phases / 18 Task / 10 fichiers audit) sont **conservateurs mais safe**. Avec 1M, un agent d'audit pourrait gérer 20-30 fichiers. [HYPOTHESE A VALIDER] : tester empiriquement sur 1 audit réel si 15 fichiers passent sans dégradation qualité avant de relever le seuil. | Phase 2 : test empirique puis potentiel +50% seuil fichiers audit |
| 3 | SWE-bench 3x et autonomie | MOYEN | La performance code augmente, mais le framework est un outil de coordination, pas de compensation. Les gates (G1-G30) et la validation @reviewer existent pour la cohérence inter-agents, pas pour compenser la faiblesse d'un modèle. @moi Shadow Mode : pas de changement de phase -- le score de fidélité dépend de l'alignement avec Thomas, pas de la capacité du modèle. | Aucune modification des seuils d'autonomie |
| 4 | `/ultrareview` et reviewer.md | MOYEN | **Complémentaire, pas doublon**. Le walkthrough reviewer.md (L167-184) simule le parcours utilisateur et Grep les patterns suspects -- c'est un audit fonctionnel. `/ultrareview` fait du bug-detection code-level. Les deux couvrent des angles différents. | Ajouter mention `/ultrareview` dans reviewer.md comme étape complémentaire optionnelle post-walkthrough |
| 5 | Effort `xhigh` + Task budgets | HAUT | **`xhigh`** : utile pour @reviewer (audits critiques) et @elon (analyses first principles). **Task budgets** (beta) : pertinent pour orchestrator qui lance des Task longs. À documenter dans ia.md et orchestrator.md. | Documenter dans ia.md + recommander `xhigh` pour audits/reviews dans orchestrator.md |
| 6 | Memory file-system améliorée | FAIBLE | Le framework gère déjà la mémoire via fichiers explicites (project-context.md, lessons-learned.md, founder-preferences.md). La memory file-system de Claude Code est un bonus d'UX, pas un remplacement du protocole. Le protocole v2 cross-projets ne peut PAS être simplifié -- il garantit la portabilité (fonctionne même sans memory file-system). | Aucune modification du protocole mémoire |
| 7 | Instruction following amélioré | FAIBLE | La règle n2 (zero invention) et le Write-first (règle n3) sont des **guardrails de processus**, pas des compensations de défauts du modèle. Même un modèle parfait en instruction following doit être contraint par un processus explicite quand il coordonne 20 agents. Analogie : un développeur senior a toujours besoin de linting. | Aucune modification des règles n2 et n3 |
| 8 | Vision 2576 px | MOYEN | La boucle visuelle (design.md + reviewer.md + ux.md screenshots) bénéficie directement de 3x résolution. Les compositions de pages, tokens visuels et comparaisons design/implémentation seront plus précises. | Ajouter une note dans design.md et reviewer.md : "Opus 4.7+ supporte des images jusqu'à 2576px -- privilégier des screenshots haute résolution pour les validations visuelles" |

---

## 3. Top 5 updates prioritaires

### Update 1 — Model ID dans les 9 agents Opus (CERTAIN)

**Fichiers** : `.claude/agents/{orchestrator,agent-factory,reviewer,elon,fullstack,ia,qa,infrastructure,moi}.md`
**Delta** : `model: claude-opus-4-6` -> `model: claude-opus-4-7`
**Justification** : pricing identique, performance 3x sur SWE-bench, instruction following amélioré. Zéro risque, zéro coût additionnel.
**Protocole migration ia.md** : la doc API est lue (findings pré-digérés), les paramètres sont identiques, le model ID change.

### Update 2 — Documenter effort `xhigh` et task budgets dans ia.md (CERTAIN)

**Fichier** : `.claude/agents/ia.md`
**Delta** : nouvelle sous-section dans "Optimisation production" documentant :
- `xhigh` effort level : quand l'utiliser (audits critiques, analyses complexes), impact latence/qualité
- Task budgets (beta) : guide la dépense token sur les Task longs de l'orchestrator
- Recommandation : `xhigh` pour @reviewer et @elon par défaut sur audits exhaustifs

### Update 3 — `/ultrareview` dans reviewer.md (CERTAIN)

**Fichier** : `.claude/agents/reviewer.md`
**Delta** : ajout post-walkthrough (après L184) :
```
### Bug détection automatisée (optionnel)
Si Claude Code `/ultrareview` est disponible, l'exécuter après le walkthrough pour détection de bugs code-level complémentaire au walkthrough fonctionnel.
```

### Update 4 — Note vision haute résolution dans design.md et reviewer.md (CERTAIN)

**Fichiers** : `.claude/agents/design.md`, `.claude/agents/reviewer.md`
**Delta** : note dans les sections screenshots/visuelles que Opus 4.7 supporte 2576px -- privilégier les captures haute résolution pour les validations visuelles (compositions, tokens, comparaisons design vs implémentation).

### Update 5 — Alias `-latest` mise à jour dans ia.md (CERTAIN)

**Fichier** : `.claude/agents/ia.md`
**Delta** : ajouter `claude-opus-4-7` dans les exemples de tags exacts. La règle alias `-latest` minor-family reste pertinente et s'applique aussi à la famille 4.7.

---

## 4. Question Sonnet vers Opus migration

### Contexte

Opus 4.6 vers 4.7 = même prix, +3x performance. Le gap Sonnet/Opus se creuse mécaniquement.

### Tableau candidats

| Agent | Modèle actuel | Tâche principale | Bénéfice Opus 4.7 | Coût delta | Verdict |
|---|---|---|---|---|---|
| creative-strategy | Sonnet 4.6 | Brand platform, personas, positionnement | MOYEN — raisonnement stratégique plus profond, mais Sonnet suffit pour du contenu structuré | +prix Opus vs Sonnet | **Pas maintenant** — le livrable (brand-platform.md) est bien couvert par Sonnet |
| product-manager | Sonnet 4.6 | Specs fonctionnelles, user stories, roadmap | HAUT — les specs complexes (25+ parcours, Given/When/Then, 5 états UI) bénéficieraient de meilleur instruction following | +prix Opus vs Sonnet | **Candidat Phase 2** [HYPOTHESE A VALIDER] |
| ux | Sonnet 4.6 | User flows, cognitive walkthrough | MOYEN — walkthrough cognitif = raisonnement sur les parcours | +prix Opus vs Sonnet | **Pas maintenant** — les flows sont bien structurés par le template |
| design | Sonnet 4.6 | Compositions visuelles, design system | HAUT — vision 2576px + meilleur multimodal = analyse screenshots + compositions plus fines | +prix Opus vs Sonnet | **Candidat Phase 2** [HYPOTHESE A VALIDER] |
| data-analyst | Sonnet 4.6 | KPI framework, tracking plan | FAIBLE — tâche structurée, Sonnet suffit | +prix Opus vs Sonnet | **Non** |
| legal | Sonnet 4.6 | RGPD, CGV, mentions légales | FAIBLE — tâche templated | +prix Opus vs Sonnet | **Non** |

### Recommandation

**Phase 1 (maintenant)** : migrer uniquement les 9 agents déjà sur Opus de 4.6 vers 4.7. Zéro coût additionnel, performance pure.

**Phase 2 (après test empirique)** : évaluer product-manager et design sur Opus 4.7 vs Sonnet 4.6 sur 1 projet réel. Comparer qualité livrable. Si le delta qualité justifie le delta coût --> migrer. [HYPOTHESE A VALIDER : le delta qualité est-il perceptible sur les livrables réels de ces agents ?]

**Ne PAS migrer massivement** : les 11 agents Sonnet produisent des livrables structurés par des templates stricts. Le template compense beaucoup -- le modèle n'a qu'à remplir, pas à raisonner librement. Le ROI de la migration Sonnet->Opus n'est pas garanti.

---

## 5. Ce qu'il NE FAUT PAS changer

| Règle/Seuil | Pourquoi la garder |
|---|---|
| **Règle n3 anti-timeout** (max 10-15 Read/Grep avant Write) | Prouvé sur 4 projets. Le timeout n'est pas un problème de context window mais de pattern comportemental. 1M tokens n'empêche pas un agent de tourner en boucle sans écrire. |
| **Règle n2 zero invention** | Guardrail de processus, pas compensation modèle. Même GPT-5 a besoin d'un "ne pas inventer". |
| **6 phases / 18 Task seuil ROUGE** | Protège la cohérence de session, pas la mémoire du modèle. Avec 1M tokens le modèle "se souvient" mais l'humain perd le fil. Le seuil protège Thomas autant que le modèle. |
| **Gates G1-G30 binaires** | Indépendantes du modèle. La qualité du livrable se mesure par les gates, pas par la confiance dans le modèle. |
| **Protocole mémoire explicite** (project-context.md, lessons-learned.md) | Portabilité cross-session et cross-modèle. La memory file-system de Claude Code est un bonus, pas un remplacement. |
| **@moi Shadow Mode seuils** | Le score de fidélité mesure l'alignement avec Thomas, pas la capacité du modèle. Un modèle plus performant n'est pas nécessairement plus aligné. |
| **10 fichiers max audit** | [HYPOTHESE A VALIDER avant modification] — voir Phase 2 ci-dessous |

---

## 6. Plan d'action en séquence

### Phase 1 — Updates safe, applicables immédiatement (< 1h)

| # | Action | Fichier(s) | Risque | Dépendance |
|---|---|---|---|---|
| 1.1 | Migrer `model: claude-opus-4-6` vers `model: claude-opus-4-7` dans les 9 agents Opus | 9 fichiers .claude/agents/*.md | NUL — même pricing, backward compatible | Aucune |
| 1.2 | Mettre à jour le template agent-factory.md (ligne 145) | agent-factory.md | NUL | 1.1 |
| 1.3 | Documenter `xhigh` et task budgets dans ia.md | ia.md | NUL — documentation pure | Aucune |
| 1.4 | Ajouter `/ultrareview` optionnel dans reviewer.md | reviewer.md | NUL — étape optionnelle | Aucune |
| 1.5 | Ajouter note vision 2576px dans design.md + reviewer.md | design.md, reviewer.md | NUL | Aucune |
| 1.6 | Mettre à jour CLAUDE.md L94 : "Opus" -> référence Opus 4.7 | CLAUDE.md | NUL — informatif | 1.1 |
| 1.7 | Mettre à jour project-context.md stack technique | project-context.md | NUL | 1.1 |

### Phase 2 — Tests empiriques requis avant implémentation

| # | Action | Prérequis | Méthode de validation |
|---|---|---|---|
| 2.1 | Tester seuil 15 fichiers audit (vs 10 actuel) | 1 audit réel sur projet avec Opus 4.7 | Comparer qualité audit 10 fichiers vs 15 fichiers sur même codebase. Si qualité identique --> relever à 15 |
| 2.2 | Évaluer product-manager sur Opus 4.7 | 1 projet réel avec specs complexes | Comparer functional-specs.md produit par Sonnet 4.6 vs Opus 4.7 sur même project-context. Si delta qualité perceptible et justifie le coût --> migrer |
| 2.3 | Évaluer design sur Opus 4.7 | 1 projet réel avec screenshots | Comparer précision analyse visuelle Sonnet 4.6 vs Opus 4.7 sur mêmes screenshots. Si delta perceptible --> migrer |
| 2.4 | Tester task budgets orchestrator | Beta feature, attendre GA | Tester sur 1 run orchestrator complet. Mesurer si les Task longs sont mieux gérés avec budget explicite |

---

**Handoff -> Thomas**
- Fichier produit : `docs/reviews/opus-4-7-impact-analysis-2026-04-17.md`
- Décision principale : migrer les 9 agents Opus de 4.6 vers 4.7 (zéro coût additionnel, +3x perf). Garder toutes les règles de discipline intactes.
- Si Thomas valide Phase 1 : je peux exécuter les 7 updates en séquence (< 30 min)
- Phase 2 : attendre un projet réel pour tester empiriquement les 4 hypothèses
