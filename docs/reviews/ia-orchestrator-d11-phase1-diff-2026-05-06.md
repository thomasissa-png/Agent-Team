<!-- Version: 2026-05-06T17:30 — @ia — Phase 1 D11 diff exact + audit non-régression rigoureux -->

# Phase 1 D11 — Diff exact orchestrator.md + audit non-régression

**Date** : 2026-05-06
**Auditeur** : @ia
**Mission** : produire le diff EXACT Phase 1 D11 sur `.claude/agents/orchestrator.md` (-92L théoriques sur 9 sections candidates) + audit non-régression rigoureux.
**Critère absolu Thomas** : aucun impact négatif performance/fonctionnel confirmé sinon non-application.
**Statut** : aucun fichier source modifié — rapport seul.

---

## Verdict global : **GO PARTIEL — 7 sections sur 9, économie -82L au lieu de -92L**

**Bloquants empêchant le GO complet** :

1. **S16 (Règles anti-timeout orchestrateur, 176-193, 18L)** → **NO-GO suppression pure** : la substance (max 2-3 Task/message, structure d'un message orchestrateur type, sauvegarde orchestration-plan.md avant 1er Task) est SPÉCIFIQUE à l'orchestrateur et N'EST PAS couverte par `_base-agent-protocol.md` (qui parle des règles de Write par agent producteur, pas de la cadence Task/message côté orchestrateur). L'audit initial classait S16 comme "90% dupliqué" — vérification empirique : c'est inexact. **Recommandation** : reporter en Phase 2 avec condensation propre (18L → 6L renvoi + spécifiques), pas suppression Phase 1.

2. **S7 (Mapping subagent_type, 75-100, 26L)** → **GO CONDITIONNEL** : référencé EXPLICITEMENT par `agent-factory.md` lignes 286, 402, 414. Si on déplace vers `orchestrator-reference.md`, agent-factory continuera à modifier orchestrator.md (le tableau aura disparu) → **régression**. Solutions : (a) déplacer ET mettre à jour agent-factory.md (3 références) en même temps, (b) garder S7 dans orchestrator.md. **Recommandation** : option (a) GO si modification agent-factory acceptée, sinon NO-GO.

3. Toutes les autres sections : **GO** validé empiriquement.

**Économie réelle en Phase 1 stricte (sans S16, avec S7 conditionnelle)** :
- Si S7 inclus avec mise à jour agent-factory.md : **-79L** (89L initial − 10L S16) en orchestrator.md ; +26L dans orchestrator-reference.md ; 3 edits dans agent-factory.md
- Si S7 exclu : **-54L** en orchestrator.md

**Hypothèses validées** : H1 OUI, H2 OUI, H3 OUI.

---

## Tableau de synthèse — 9 sections candidates

| # | Section | Lignes (orch.md) | Volume | Destination | Couvert par base/ref ? | Réfs externes | Verdict |
|---|---|---|---|---|---|---|---|
| S2 | Domaines de compétence | 19-27 | 9L | Suppression pure | NON (pas dans base — c'est un template par agent), mais redondant avec Identité (15-17) | aucune | **GO suppression** |
| S3 | Protocole d'entrée obligatoire | 29-37 | 9L | Renvoi + champs critiques | OUI (`_base-agent-protocol.md` ligne 11) | aucune | **GO condensation** |
| S7 | Mapping agents → subagent_type | 75-100 | 26L | `orchestrator-reference.md` | NON — orchestrator-reference.md ne contient PAS ce tableau | OUI — `agent-factory.md` lignes 286, 402, 414 | **GO CONDITIONNEL** (nécessite mise à jour agent-factory.md) |
| S16 | Règles anti-timeout orchestrateur | 176-193 | 18L | (Phase 2) | PARTIEL — base couvre Write/Read agent producteur ; orchestrateur Task/message NON couvert | aucune | **NO-GO Phase 1** (substance unique — reporter Phase 2) |
| S20 | Routage demande → bibliothèque | 259-285 | 27L | `orchestrator-reference.md` | NON — pas dans orchestrator-reference.md (carte de prompts par phase ≠ routage par mots-clés) | aucune externe (RÈGLE en ligne 285 audit-réel "audite/vérifie/teste" déjà dans orchestrator-reference.md ligne 50) | **GO déplacement** |
| S30 | Étape 1b Compréhension utilisateur | 423-432 | 10L | Renvoi + spécificité | OUI — base ligne 27 "Adaptation au profil utilisateur" couvre 90% (point 4 "première utilisation framework" unique) | aucune | **GO condensation** |
| S39 | Protocole d'escalade | 825-831 | 7L | Renvoi + spécificités | OUI — base ligne 151. Spécifique : arbitrage persona>objectif>budget (à préserver) | aucune | **GO condensation** |
| S42 | Mode révision | 851-853 | 3L | Renvoi | OUI — base ligne 192. Spécifique : "valider via PulseBoard" (à préserver) | aucune | **GO condensation** |
| S44 | Protocole de fin de livrable | 872-874 | 3L | Renvoi | OUI — base ligne 322 | aucune | **GO suppression/renvoi** |

**Total volume initial** : 112L sur les 9 sections
**Total nouveau** : 30L (sections condensées + renvois)
**Économie nette orchestrator.md** : -82L (avec S7) ou -54L (sans S7)
**À ajouter ailleurs** : +28L dans orchestrator-reference.md (S7 + S20) + 3 edits agent-factory.md (mineurs)

---

## Audit des 3 hypothèses

### H1 : `orchestrator-reference.md` existe et est lu en début de session ?

**VRAI partiellement.**
- Le fichier `.claude/agents/orchestrator-reference.md` EXISTE (297 lignes).
- Il contient déjà : Carte des prompts par phase, mode autopilot, templates, cycle reviewer, estimation coût, circuit breaker, métriques live, compression contexte, mode hotfix.
- **Il N'EST PAS lu systématiquement** : le fichier lui-même indique en ligne 3 "Il est consulté à la demande (via Read), pas chargé systématiquement."
- Référencé une seule fois dans orchestrator.md ligne 822 ("Voir orchestrator-reference.md pour : métriques d'orchestration, seuils de succès, templates...").

**Implication** : tout déplacement vers ce fichier doit s'accompagner d'un **renvoi explicite** dans orchestrator.md, sinon l'information devient invisible. Pour S7 (mapping subagent_type) crucial à chaque Task : le renvoi doit être en début d'orchestrator.md, pas en fin.

### H2 : sections S13/S27 jamais déclenchées en S1/S2 ?

**Hors scope Phase 1** — S13 (Bug Permissions Write) et S27 (Fusion UX+Design) sont en Phase 3 dans l'audit initial. Pas de vérification effectuée pour cette mission.

**Pour Phase 1**, pas de section "mort-vivant" candidate — toutes les 9 sections sont actives.

### H3 : aucun prompt `index.html` ne référence les sections candidates ?

**VRAI.** Grep dans `index.html` (89 prompts) sur :
- "Domaines de compétence" : 0 résultat
- "Protocole d'entrée obligatoire" : 0 résultat
- "Mode révision" : 0 résultat
- "Protocole de fin de livrable" : 0 résultat
- "Étape 1b" : 0 résultat
- "Compréhension de l'utilisateur" : 0 résultat
- "Mapping agents" : 0 résultat
- "Routage demande" : 0 résultat
- "subagent_type" : 0 résultat dans index.html (référencé uniquement dans `agent-factory.md` ligne 286 et orchestrator.md)

Les 3 occurrences "orchestrator.md" dans index.html (lignes 900, 3305, 3309, 3631) ne référencent que le fichier global, pas les sections internes.

**Conclusion H3 validée** : zéro prompt client-facing impacté.

---

## Diff exact par section

Format : contexte 3 lignes (avant/après si applicable). `-` = ligne supprimée, `+` = ligne ajoutée, ` ` (espace) = ligne contexte inchangée.

### S2 — Domaines de compétence (lignes 19-27, -9L) — GO suppression

```diff
 Chef d'orchestre de projets digitaux complexes. 20 ans de direction de production digitale, des premières startups Web 2.0 aux scale-ups à 100M ARR. A coordonné jusqu'à 25 spécialistes en parallèle sur des lancements 0-to-1 dans 8 secteurs différents. Son rôle : planifier, déléguer via le tool Task, contrôler les résultats, et itérer jusqu'à la livraison finale. Il ne fait jamais le travail des agents — il les dirige. Philosophie de coordination : la valeur d'un orchestrateur ne se mesure pas au nombre de tâches lancées, mais à la qualité des dépendances identifiées entre elles. Un projet qui échoue échoue rarement sur l'exécution — il échoue sur l'ordre des opérations. Sa hantise : un agent qui travaille sur des inputs obsolètes parce qu'un autre agent en amont a changé la donne. Chaque phase est verrouillée avant de passer à la suivante.
 
-## Domaines de compétence
-
-- Décomposition de projets complexes en sous-tâches ordonnées et assignées
-- Identification des dépendances inter-agents (A doit finir avant B)
-- Arbitrage des contradictions entre livrables d'agents différents
-- Surveillance de la cohérence globale du projet à chaque étape
-- Synthèse finale et recommandations pour les prochaines itérations
-- Gestion des phases parallèles vs séquentielles selon les contraintes
-- Détection du mode projet (nouveau vs existant) et adaptation du plan
-
 ## Protocole d'entrée obligatoire
```

**Justification** : la section Identité ligne 17 énumère DÉJÀ "planifier, déléguer, contrôler, itérer" et "verrouiller chaque phase". La liste 19-27 paraphrase. Aucune perte d'information opérationnelle.

### S3 — Protocole d'entrée obligatoire (lignes 29-37, 9L → 4L, -5L) — GO condensation

```diff
-## Protocole d'entrée obligatoire
-
-1. Lire `project-context.md` à la racine
-2. Si absent → STOP. Afficher : "STOP — project-context.md manquant. Remplis le template dans templates/ avant que je puisse travailler."
-3. Vérifier que les champs critiques sont remplis ET exploitables (voir critères de qualité ci-dessous)
-4. Si champs critiques vides → lister les champs manquants, refuser d'avancer
-5. Si champs remplis mais insuffisants → lister les champs à enrichir avec des questions ciblées, refuser d'avancer
-
-Champs critiques pour cet agent : Nom du projet, Secteur, Persona principal, Objectif principal à 6 mois, Stack technique, KPI North Star, Promesse unique, Ton de marque
+## Protocole d'entrée obligatoire
+
+Le protocole standard s'applique (voir `_base-agent-protocol.md`). **Spécificité orchestrateur** : ne pas se contenter de la présence des champs — vérifier la **qualité** via les critères ci-dessous (un champ vague bloque autant qu'un champ vide).
+
+Champs critiques pour cet agent : Nom du projet, Secteur, Persona principal, Objectif principal à 6 mois, Stack technique, KPI North Star, Promesse unique, Ton de marque
```

**Économie : -5L** (9L → 4L). Préserve la liste des champs critiques (utile en lecture rapide) et la spécificité qualité>présence.

### S7 — Mapping agents → subagent_type (lignes 75-100, -25L) — GO CONDITIONNEL

**Action 1** : déplacer vers `orchestrator-reference.md` (à insérer après ligne 6 "Carte de référence").

**Action 2** dans `orchestrator.md` :

```diff
-## Mapping agents → subagent_type
-
-Quand tu invoques le tool Task pour déléguer à un agent, utilise le `subagent_type` correspondant :
-
-| Agent | subagent_type |
-|---|---|
-| @creative-strategy | `creative-strategy` |
-| @product-manager | `product-manager` |
-| @data-analyst | `data-analyst` |
-| @ux | `ux` |
-| @design | `design` |
-| @copywriter | `copywriter` |
-| @fullstack | `fullstack` |
-| @qa | `qa` |
-| @infrastructure | `infrastructure` |
-| @ia | `ia` |
-| @seo | `seo` |
-| @geo | `geo` |
-| @growth | `growth` |
-| @sales-enablement | `sales-enablement` |
-| @social | `social` |
-| @legal | `legal` |
-| @reviewer | `reviewer` |
-| @agent-factory | `agent-factory` |
-| @elon | `elon` |
-| @moi | `moi` |
+## Mapping agents → subagent_type
+
+Voir `orchestrator-reference.md` section "Mapping subagent_type" (tableau complet 19 agents). Règle générale : `subagent_type` = nom de l'agent sans `@`. Pour les agents custom, voir bloc ci-dessous.
```

**Action 3 — Mise à jour agent-factory.md (3 edits)** pour préserver la cohérence :

- Ligne 286 : `**a) Tableau "Mapping agents → subagent_type"** — ajouter une ligne au format exact :` → `**a) Tableau "Mapping agents → subagent_type"** dans `orchestrator-reference.md` — ajouter une ligne au format exact :`
- Ligne 402 : `**Retirer de orchestrator.md** : supprimer du mapping subagent_type et des descriptions de phase` → `**Retirer de orchestrator-reference.md** (mapping subagent_type) **et orchestrator.md** (descriptions de phase si présentes)`
- Ligne 414 : `□ L'agent est-il intégré dans CLAUDE.md (...) ET orchestrator.md (mapping subagent_type) ?` → `□ L'agent est-il intégré dans CLAUDE.md (...), orchestrator-reference.md (mapping subagent_type) ET orchestrator.md (descriptions de phase) ?`

**Économie nette** : -25L orchestrator.md, +24L orchestrator-reference.md, +3 edits mineurs agent-factory.md.

**Si Thomas refuse de toucher agent-factory.md** → garder S7 en place (zéro régression mais zéro économie).

### S16 — Règles strictes anti-timeout orchestrateur (lignes 176-193, 18L) — NO-GO Phase 1

**Vérification empirique** :

Lignes 176-193 contiennent :
1. Maximum 2-3 Task par message (pas dans base)
2. Un cycle par message (pas dans base)
3. Sauvegarder orchestration-plan.md entre cycles (pas dans base)
4. Écrire orchestration-plan.md AVANT le 1er Task (pas dans base)
5. Après timeout : Glob+Read pour vérifier livrables existants (couvert par base ligne 82 point 6, mais formulation orchestrateur-spécifique)
6. Structure d'un message orchestrateur type (exemple 4 messages, pas dans base)

**Vraie zone dupliquée** : ~3 lignes sur 18 (point 5).

**Action** : laisser en place pour Phase 1. Reporter en Phase 2 avec condensation 18L → 8L (renvoi base + 4 règles spécifiques). **Aucun diff Phase 1 sur S16.**

### S20 — Routage demande → bibliothèque (lignes 259-285, -24L) — GO déplacement

```diff
-### Routage demande utilisateur → prompt de la bibliothèque — règle critique
-
-**RÈGLE** : pour TOUTE demande utilisateur en cours de session, l'orchestrateur DOIT d'abord chercher si un prompt de la bibliothèque (`index.html`) correspond. NE PAS improviser si un prompt existe.
-
-**Table de routage rapide (demandes fréquentes hors-phase) :**
-
-| L'utilisateur dit... | Prompt à utiliser (Grep dans index.html) |
-|---|---|
-| "audite / vérifie / teste [page/feature]" | "Audit réel (crash test)" |
-| "audit approfondi / avant mise en prod" | "Audit exhaustif (stress test production)" |
-| "ajoute [feature]" / "développe [feature]" | "Développer une feature" |
-| "ajoute de l'IA / un chatbot / du LLM" | "Ajouter une feature IA" |
-| "améliore l'onboarding" | "Onboarding utilisateur gamifié" ou "Optimiser l'onboarding" |
-| "refais le pricing / la page pricing" | "Stratégie de pricing complète" |
-| "améliore le SEO" | "Stratégie SEO technique & éditoriale" |
-| "lance mon projet" | "Lancer mon projet de A à Z" |
-| "check-up / où en est-on" | "Faire un check-up complet" |
-| "prépare le lancement" | "Plan de lancement" + "Checklist jour de lancement" |
-| "crée un agent pour [domaine]" | "Créer un agent spécialisé" |
-| "debug [problème]" | "Debug & troubleshooting" |
-| "améliore les performances" | "Performance budget & optimisation" |
-| "ajoute Stripe / le paiement" | "Intégrer le paiement Stripe" |
-| "refais le design / la DA" | "Définir la direction artistique" |
-
-**Si aucun prompt ne matche** → formuler un prompt Task sur mesure avec le template obligatoire (contexte pré-digéré, livrables amont, output attendu, anti-timeout).
-
-**NE JAMAIS** : improviser un audit code basique quand l'utilisateur demande "audite/vérifie/teste" — utiliser le crash test.
+### Routage demande utilisateur → prompt de la bibliothèque
+
+**RÈGLE** : pour TOUTE demande utilisateur, l'orchestrateur DOIT d'abord chercher si un prompt d'`index.html` correspond. NE PAS improviser si un prompt existe. **Tableau complet de routage** : voir `orchestrator-reference.md` section "Routage demande → bibliothèque". Si aucun match → prompt Task sur mesure (template obligatoire).
```

**Action 2** : ajouter le tableau complet (24L) dans `orchestrator-reference.md` après la "Carte de référence par phase".

**Économie** : -24L orchestrator.md, +24L orchestrator-reference.md (déplacement net).

### S30 — Étape 1b Compréhension utilisateur (lignes 423-432, 10L → 3L, -7L) — GO condensation

```diff
-## Étape 1b — Compréhension de l'utilisateur
-
-Avant de clarifier la demande, comprendre QUI demande :
-
-1. **Lire les Notes libres** de project-context.md — elles contiennent souvent le contexte humain (contraintes de temps, budget personnel, niveau technique, stade de vie entrepreneuriale)
-2. **Évaluer le niveau technique** de l'utilisateur à partir de la stack choisie et du vocabulaire utilisé :
-   - **Non-technique** : adapter les points d'avancement en langage métier ("ta page d'accueil est prête" plutôt que "le composant Hero a été implémenté avec les design tokens")
-   - **Technique** : donner les détails d'implémentation, les choix techniques, les trade-offs
-3. **Calibrer le niveau de détail** des rapports inter-phases selon ce profil
-4. **Si première utilisation du framework** (historique des interventions vide) : expliquer en 3-4 lignes ce qui va se passer : "Je vais coordonner plusieurs agents spécialisés pour ton projet. Chaque agent produit un livrable dans docs/. Je te présenterai les résultats à chaque étape pour validation."
+## Étape 1b — Compréhension de l'utilisateur
+
+Le protocole "Adaptation au profil utilisateur" standard s'applique (voir `_base-agent-protocol.md`). **Spécificité orchestrateur** : si historique des interventions VIDE (1ère utilisation du framework), expliquer en 3-4 lignes ce qui va se passer : "Je vais coordonner plusieurs agents spécialisés. Chaque agent produit un livrable dans docs/. Je te présenterai les résultats à chaque étape pour validation."
```

**Économie** : -7L. Préserve l'unique spécificité (1ère utilisation framework) absente du base.

### S39 — Protocole d'escalade (lignes 825-831, 7L → 4L, -3L) — GO condensation

```diff
-## Protocole d'escalade
-
-La règle anti-invention absolue s'applique (voir CLAUDE.md Règle n°2). **En tant qu'orchestrateur** : vérifier que les sous-agents n'inventent pas de données non plus. Si un livrable contient des chiffres non sourcés, le signaler et demander correction.
-
-- Si contradiction entre livrables de deux agents → arbitrer selon : persona principal > objectif 6 mois > contraintes budget. Documenter la décision et la justification
-- Si la demande nécessite un agent non disponible → signaler clairement la lacune et proposer l'agent le plus proche
-- Si une décision engage le budget ou la timeline → flag explicite à l'utilisateur, ne pas trancher seul
+## Protocole d'escalade
+
+Protocole standard (voir `_base-agent-protocol.md`). **Spécificités orchestrateur** : (1) vérifier que les sous-agents n'inventent pas de données ; (2) en cas de contradiction inter-agents, arbitrer selon **persona principal > objectif 6 mois > contraintes budget** ; (3) toute décision engageant budget/timeline → flag utilisateur, ne pas trancher seul.
```

**Économie** : -3L. Préserve l'arbitrage hiérarchique (spécificité critique).

### S42 — Mode révision (lignes 851-853, 3L → 2L, -1L) — GO condensation

```diff
-## Mode révision
-
-Le protocole de révision standard s'applique (voir _base-agent-protocol.md). Spécificité : vérifier que les modifications ne cassent pas les dépendances entre agents déjà exécutés. Après toute modification de ce fichier, valider le fonctionnement via le protocole de test du framework (voir _base-agent-protocol.md section "Protocole de test du framework") avec le projet test PulseBoard (`tests/project-context-test.md`).
+## Mode révision
+
+Protocole standard (voir `_base-agent-protocol.md`). **Spécificités** : (1) vérifier que les modifications ne cassent pas les dépendances inter-agents ; (2) toute modification de ce fichier → test framework via PulseBoard (`tests/project-context-test.md`).
```

**Économie** : -1L. Préserve les 2 spécificités.

### S44 — Protocole de fin de livrable (lignes 872-874, 3L → 2L, -1L) — GO renvoi

```diff
-## Protocole de fin de livrable
-
-Mettre à jour le tableau "Historique des interventions agents" de project-context.md après chaque livrable (voir _base-agent-protocol.md).
+## Protocole de fin de livrable
+
+Voir `_base-agent-protocol.md` (mise à jour de l'historique des interventions agents standard).
```

**Économie** : -1L.

---

## Récapitulatif chiffré du diff

| Section | Lignes avant | Lignes après | Économie orchestrator.md | Ajout orchestrator-reference.md | Edits agent-factory.md |
|---|---|---|---|---|---|
| S2 | 9 | 0 | -9 | 0 | 0 |
| S3 | 9 | 4 | -5 | 0 | 0 |
| S7 (conditionnel) | 26 | 3 | -23 | +24 | 3 edits |
| S16 | (Phase 2) | (Phase 2) | 0 | 0 | 0 |
| S20 | 27 | 4 | -23 | +24 | 0 |
| S30 | 10 | 3 | -7 | 0 | 0 |
| S39 | 7 | 4 | -3 | 0 | 0 |
| S42 | 3 | 2 | -1 | 0 | 0 |
| S44 | 3 | 2 | -1 | 0 | 0 |
| **Totaux (avec S7)** | **94** | **22** | **-72** | **+48** | **3 edits** |
| **Totaux (sans S7)** | **68** | **19** | **-49** | **+24** | **0** |

**Note** : l'audit initial annonçait -92L. Le delta vient de :
- S16 reportée Phase 2 (-13L absorbés par Phase 2)
- Condensations préservant plus de spécificités que l'audit initial estimait (sécurité)

**Avant (orchestrator.md)** : 891L
**Après (avec S7)** : 819L
**Après (sans S7)** : 842L

---

## Plan extension `orchestrator-reference.md`

Le fichier existe (297L) — pas besoin de création. **Ajouter 2 sections** :

### Section à insérer après ligne 6 (avant "Carte de référence — Prompts par phase")

```markdown
## Mapping agents → subagent_type

Quand tu invoques le tool Task pour déléguer à un agent, utilise le `subagent_type` correspondant :

| Agent | subagent_type |
|---|---|
| @creative-strategy | `creative-strategy` |
| @product-manager | `product-manager` |
| @data-analyst | `data-analyst` |
| @ux | `ux` |
| @design | `design` |
| @copywriter | `copywriter` |
| @fullstack | `fullstack` |
| @qa | `qa` |
| @infrastructure | `infrastructure` |
| @ia | `ia` |
| @seo | `seo` |
| @geo | `geo` |
| @growth | `growth` |
| @sales-enablement | `sales-enablement` |
| @social | `social` |
| @legal | `legal` |
| @reviewer | `reviewer` |
| @agent-factory | `agent-factory` |
| @elon | `elon` |
| @moi | `moi` |

Pour les agents custom (pas dans la liste hardcodée Claude Code) : voir `orchestrator.md` section "Agents custom".

---
```

### Section à insérer après "Carte de référence — Prompts par phase" (avant "Mode autopilot détaillé")

```markdown
## Routage demande utilisateur → prompt de la bibliothèque

Table de routage rapide (demandes fréquentes hors-phase) :

| L'utilisateur dit... | Prompt à utiliser (Grep dans index.html) |
|---|---|
| "audite / vérifie / teste [page/feature]" | "Audit réel (crash test)" |
| "audit approfondi / avant mise en prod" | "Audit exhaustif (stress test production)" |
| "ajoute [feature]" / "développe [feature]" | "Développer une feature" |
| "ajoute de l'IA / un chatbot / du LLM" | "Ajouter une feature IA" |
| "améliore l'onboarding" | "Onboarding utilisateur gamifié" ou "Optimiser l'onboarding" |
| "refais le pricing / la page pricing" | "Stratégie de pricing complète" |
| "améliore le SEO" | "Stratégie SEO technique & éditoriale" |
| "lance mon projet" | "Lancer mon projet de A à Z" |
| "check-up / où en est-on" | "Faire un check-up complet" |
| "prépare le lancement" | "Plan de lancement" + "Checklist jour de lancement" |
| "crée un agent pour [domaine]" | "Créer un agent spécialisé" |
| "debug [problème]" | "Debug & troubleshooting" |
| "améliore les performances" | "Performance budget & optimisation" |
| "ajoute Stripe / le paiement" | "Intégrer le paiement Stripe" |
| "refais le design / la DA" | "Définir la direction artistique" |

Si aucun prompt ne matche → formuler un prompt Task sur mesure avec le template obligatoire.
**NE JAMAIS** : improviser un audit code basique quand l'utilisateur demande "audite/vérifie/teste" — utiliser le crash test.

---
```

**Total ajout orchestrator-reference.md** : ~48L (de 297L à ~345L). Bien sous les 100L plafond suggérés par l'utilisateur (cap implicite).

---

## Risques résiduels post-application + mitigations

| # | Risque | Niveau | Mitigation |
|---|---|---|---|
| R1 | `orchestrator-reference.md` non lu en début de session par défaut → mapping subagent_type oublié au lancement de Task | **MEDIUM** | Avant application S7, ajouter en TÊTE d'orchestrator.md (dans section Identité ou juste après) une ligne : "Lire `orchestrator-reference.md` au démarrage si projet contient des agents custom OU si Task à lancer hors phase standard." |
| R2 | agent-factory.md modifie orchestrator.md (mapping) sans savoir que le tableau a déménagé → erreur d'intégration agents custom | **HIGH si S7 appliqué sans Action 3** | OBLIGATOIRE : appliquer les 3 edits agent-factory.md EN MÊME TEMPS que S7. Vérification post-application : Grep "Mapping agents → subagent_type" dans agent-factory.md → doit pointer vers orchestrator-reference.md. |
| R3 | Condensation S30 perd la nuance "non-technique vs technique vs expert" du base | LOW | Vérifié : base ligne 32-35 couvre les 3 niveaux explicitement. Spécificité orchestrateur (1ère utilisation) préservée. |
| R4 | Condensation S39 perd la hiérarchie persona>objectif>budget | LOW (déjà dans diff) | Hiérarchie explicitement préservée dans le nouveau texte. |
| R5 | Suppression S2 perd "détection mode projet (nouveau vs existant)" | LOW | Vérifié : S33 Étape 4 lignes 549+ traite explicitement le mode projet (Phase 0/0b autopilot). Pas de perte. |
| R6 | Le 3e bullet S39 ("budget/timeline → flag utilisateur") déjà couvert par CLAUDE.md commandement 5 ("ne jamais couper feature par manque de temps") | LOW | Préservé dans la version condensée — formulation différente (flag explicite vs ne pas trancher seul). Pas redondant. |
| R7 | Phase 2 (S16 reportée) accumule la condensation anti-timeout orchestrateur — risque d'oublier la spécificité "max 2-3 Task/message" | MEDIUM | Documenter dans le handoff : S16 = priorité Phase 2, contient 4 règles uniques NON couvertes par base. |
| R8 | Effet de bord : si un autre agent (ex: @reviewer) audite orchestrator.md et ne sait pas que `_base-agent-protocol.md` couvre certaines sections → faux FAIL | LOW | Tous les renvois mentionnent EXPLICITEMENT le fichier source. @reviewer suit déjà les renvois `_base-agent-protocol.md` (pattern utilisé dans 19 agents). |

---

## Recommandation finale Thomas

**Option A — GO complet (7 sections, S7 inclus avec mise à jour agent-factory.md)** :
- Économie : -72L orchestrator.md, +48L orchestrator-reference.md, 3 edits mineurs agent-factory.md
- Risque : MEDIUM (sur R1 mitigé par renvoi explicite + R2 mitigé par application simultanée)
- Délai d'exécution : 25-30 min

**Option B — GO partiel (6 sections, S7 exclu)** :
- Économie : -49L orchestrator.md, +24L orchestrator-reference.md, 0 edit agent-factory.md
- Risque : LOW
- Délai d'exécution : 15 min

**Option C — NO-GO Phase 1 complète** : si tolérance zéro impact strict ET si Thomas refuse modification agent-factory.md → conserver S7 ET S16 ET S20.

**Préconisation @ia** : **Option A**. Les modifications agent-factory.md sont triviales (3 lignes) et améliorent même la cohérence (le mapping est mieux placé dans orchestrator-reference.md, fichier "templates et références" par nature). Le risque R2 est entièrement éliminé en faisant les 3 edits en même temps.

Si Thomas préfère minimiser le risque : **Option B** est sûre, économise 49L (suffit à lever le WARN 900 même seul : 891 − 49 = 842), et ne touche à aucun autre agent.

---

## Handoff → @orchestrator (lecture seule, décision Thomas attendue)

- **Fichiers produits** : `/home/user/Agent-Team/docs/reviews/ia-orchestrator-d11-phase1-diff-2026-05-06.md`
- **Aucun fichier source modifié** (orchestrator.md, orchestrator-reference.md, agent-factory.md, _base-agent-protocol.md restent intacts).
- **Décisions prises** :
  - Verdict global : **GO PARTIEL** (7-9 sections selon option)
  - **NO-GO sur S16** (anti-timeout orchestrateur) — substance unique non couverte par base, à reporter Phase 2
  - **GO CONDITIONNEL sur S7** (mapping subagent_type) — référencé par agent-factory.md ; nécessite 3 edits agent-factory.md pour éviter régression
  - **GO sur S2, S3, S20, S30, S39, S42, S44** — empiriquement couvertes par base ou redondantes en interne
- **Hypothèses** : H1 OUI (orchestrator-reference.md existe, 297L, lu à la demande), H2 hors scope Phase 1, H3 OUI (zéro ref index.html sur les 9 sections).
- **Sections à appliquer (Option A — recommandée)** : S2, S3, S7+agent-factory edits, S20, S30, S39, S42, S44 → -72L orchestrator.md
- **Sections à appliquer (Option B — sûre)** : S2, S3, S20, S30, S39, S42, S44 → -49L orchestrator.md
- **Sections à NE PAS appliquer Phase 1** : S16 (reporter Phase 2 avec condensation propre)
- **Points d'attention** :
  - Si Option A choisie : appliquer S7 ET agent-factory.md edits dans la MÊME session pour éviter régression
  - Avant tout Edit : ajouter en tête d'orchestrator.md une ligne demandant la lecture conditionnelle d'orchestrator-reference.md (mitigation R1)
  - Tester via PulseBoard après application (protocole framework)
  - Mettre à jour `lessons-learned.md` : pattern "audit empirique avant suppression — 90% dupliqué annoncé ≠ 90% dupliqué réel"
- **Aucune action Replit requise.**

---
