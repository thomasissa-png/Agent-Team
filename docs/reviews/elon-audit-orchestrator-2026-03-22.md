# Audit @orchestrator — Vision Elon

**Date** : 2026-03-22
**Auditeur** : @elon
**Sujet** : Audit de fond en comble de l'agent @orchestrator — le cerveau de l'équipe

---

## Score global : 8.5/10

L'orchestrateur est solide. C'est un bon chef d'orchestre — mais ce n'est pas encore un grand chef d'orchestre. Il gère bien la mécanique, mais il manque de réflexes de guerre. Quand tout va bien, il est excellent. Quand ça déraille, il a des trous dans sa cuirasse. Et dans un système où la marge d'erreur est nulle, c'est ces trous qui te tuent.

---

## Scores par dimension

| # | Dimension | Score | Commentaire brutal |
|---|---|---|---|
| 1 | Protocole d'entrée | **9/10** | Les critères de qualité par champ sont un coup de génie. Rare de voir ça. |
| 2 | Décomposition & priorisation | **9/10** | Le croisement stade×KPI×budget est exactement le bon framework. |
| 3 | Gestion des timeouts | **8/10** | Bien pensé mais pas assez défensif. Le plan B est flou. |
| 4 | Utilisation de Task | **9/10** | Format de prompt structuré, parallélisation documentée. Solide. |
| 5 | Boucle Plan→Execute→Verify | **8/10** | Le cycle est bon mais la vérification est trop manuelle et subjective. |
| 6 | Mode autopilot | **8/10** | Bonne idée, mais les conditions de blocage sont incomplètes. |
| 7 | Clarification de la demande | **9/10** | Le protocole de clarification est un des meilleurs éléments du framework. |
| 8 | Gestion d'erreurs & dégradation | **8/10** | La dégradation gracieuse existe — mais le seuil de tolérance est trop généreux. |
| 9 | Feedback remontant | **8.5/10** | Le concept est là, les cas sont documentés, mais pas de priorisation des feedbacks. |
| 10 | Auto-évaluation | **9/10** | 9 questions spécifiques, toutes pertinentes. C'est sérieux. |

**Score moyen : 8.55/10** — arrondi à **8.5/10**

---

## Ce qui fonctionne (ne pas toucher)

### 1. Critères de qualité par champ critique (lignes 38-51)
C'est le truc le plus intelligent du fichier. La plupart des systèmes vérifient "est-ce que le champ est rempli ?". L'orchestrateur vérifie "est-ce que le champ est **exploitable** ?". La différence entre "Marie, 35 ans" et "Marie, 35 ans, responsable marketing PME, perd 3h/semaine à consolider ses analytics manuellement" — c'est la différence entre un projet qui démarre sur du sable et un projet qui démarre sur du béton. Ne touche pas à ça.

### 2. Protocole de clarification (lignes 245-278)
Le classement Précise/Directionnelle/Ouverte est exactement ce qu'il faut. Et la phrase clé : "le coût d'une question de cadrage = 30 secondes. Le coût d'un mauvais cadrage = relance complète de la chaîne d'agents." C'est du first principles thinking pur. Ça reste.

### 3. Priorisation stade×KPI×budget (lignes 284-302)
L'orchestrateur ne lance pas mécaniquement Phase 0→5 comme un automate. Il adapte selon le contexte. C'est la différence entre un chef de projet et un script bash. Le tableau stade/phases prioritaires est clean.

### 4. Prompt Task structuré (lignes 137-166)
Le format imposé pour chaque Task est un multiplicateur de qualité. Contexte projet + mission + contraintes + livrables attendus + règles anti-timeout. Chaque agent reçoit tout ce dont il a besoin. Pas d'ambiguïté. C'est comme donner un brief précis à un ingénieur SpaceX — le résultat est 10x meilleur qu'un "fais le moteur".

### 5. Checkpoint Phase 0 obligatoire (lignes 310-316)
"Ne JAMAIS lancer la Phase 1 sans cette validation — un positionnement erroné en Phase 0 contamine irréversiblement tout l'aval." Exactement. C'est comme lancer une fusée avec une trajectoire incorrecte — chaque seconde qui passe augmente la déviation. Ce checkpoint est non négociable.

---

## Ce qui est broken (fixer immédiatement)

### Problème #1 — Pas de métriques de succès pour la vérification (VERIFY)

**Constat** : L'étape VERIFY (lignes 186-189) dit "Vérifier la cohérence avec les livrables précédents" et "Détecter les contradictions". Mais COMMENT ? Avec quels critères objectifs ? Les "critères de cohérence" (lignes 373-378) sont une checklist narrative, pas des métriques mesurables.

**Impact** : La vérification dépend du jugement subjectif de l'orchestrateur à chaque run. Un même livrable pourrait passer ou échouer selon le contexte de la conversation. Dans un système à marge d'erreur nulle, c'est inacceptable.

**Solution** : Ajouter des critères de vérification binaires (pass/fail) pour chaque type de cohérence :
- Ton aligné avec brand-platform → le livrable cite-t-il explicitement le ton défini ? OUI/NON
- Composants respectent les tokens → les noms de couleurs/tailles correspondent-ils au design-tokens.json ? OUI/NON
- Events tracking correspondent → chaque event dans le code a-t-il un équivalent dans tracking-plan.md ? OUI/NON

**Score actuel → cible** : 8/10 → 9.5/10

### Problème #2 — Le mode autopilot manque de garde-fous critiques

**Constat** : Le mode autopilot (lignes 197-225) bloque si un agent score <3 ou si une contradiction est détectée. Mais il ne bloque PAS si :
- Le contexte approche la limite (il le mentionne ligne 461 mais hors du mode autopilot)
- Un agent produit un livrable vide ou quasi-vide
- Le temps total d'orchestration dépasse un seuil raisonnable
- Les livrables divergent progressivement du project-context original (drift)

**Impact** : En mode autopilot, l'orchestrateur pourrait continuer à lancer des agents sur un projet qui a dérivé silencieusement. C'est le pire scénario — 10 agents qui produisent des livrables cohérents entre eux mais déconnectés de la réalité du projet.

**Solution** : Ajouter 3 conditions de blocage automatique au mode autopilot :
1. **Détection de drift** : après chaque phase, re-vérifier que le persona principal et le KPI North Star sont toujours alignés avec les livrables produits
2. **Livrable vide** : si un agent produit un fichier <20 lignes alors qu'un livrable complet est attendu → bloquer
3. **Limite de contexte** : si le message est le 5ème+ d'un autopilot → checkpoint utilisateur obligatoire

**Score actuel → cible** : 8/10 → 9/10

### Problème #3 — Pas de priorisation dans le feedback remontant

**Constat** : Le protocole de feedback remontant (lignes 393-410) liste des cas fréquents mais ne les priorise pas. Un bug QA (critique) et une densité sémantique insuffisante (mineur) reçoivent le même traitement.

**Impact** : L'orchestrateur pourrait perdre du temps à corriger un problème mineur pendant qu'un problème critique attend. Dans un système à marge d'erreur nulle, la séquence de correction est aussi importante que la correction elle-même.

**Solution** : Classifier les feedbacks remontants par sévérité :
- **P0 (bloquer immédiatement)** : bug critique, impossibilité technique, contradiction avec persona/KPI
- **P1 (corriger avant phase suivante)** : incohérence entre livrables, flow cassé
- **P2 (noter et corriger en fin de run)** : optimisations, densité sémantique, ajustements de ton

**Score actuel → cible** : 8.5/10 → 9.5/10

---

## Ce qui manque (ajouter)

### Manque #1 — Rapport d'orchestration post-run

**Pourquoi c'est critique** : L'orchestrateur produit `project-synthesis.md` et `orchestration-plan.md`, mais aucun rapport de performance de l'orchestration elle-même. Combien de Task ont été lancés ? Combien ont échoué ? Combien de feedbacks remontants ? Quels agents ont été relancés ? Quel pourcentage du plan initial a été exécuté vs modifié ?

**Comment l'implémenter** : Ajouter un bloc "Métriques d'orchestration" dans `project-synthesis.md` :
```
## Métriques d'orchestration
- Agents invoqués : X/18
- Task lancés : X (dont X en parallèle)
- Échecs : X (agents : @X, @Y)
- Feedbacks remontants : X (dont X P0)
- Phases complétées : X/5
- Drift détecté : OUI/NON
```

### Manque #2 — Protocole de reprise après interruption

**Pourquoi c'est critique** : L'orchestrateur mentionne "sauvegarder l'état entre les cycles" (ligne 99) mais ne détaille pas le protocole de reprise. Quand un utilisateur revient dans une nouvelle session après un timeout ou un changement de contexte, l'orchestrateur doit savoir exactement comment reprendre.

**Comment l'implémenter** : Ajouter une section "Protocole de reprise" :
1. Lire `docs/orchestration-plan.md` — identifier la dernière phase complétée
2. Glob `docs/**/*.md` — inventorier les livrables existants
3. Comparer plan vs livrables → identifier les agents non exécutés
4. Reprendre à la phase suivante sans relancer les agents déjà terminés
5. Signaler à l'utilisateur : "Reprise détectée. Phase X terminée, Phase Y en cours. Je reprends à partir de [agent]."

### Manque #3 — Stratégie de test de l'orchestrateur lui-même

**Pourquoi c'est critique** : On peut tester chaque agent isolément (test unitaire). On peut tester des chaînes (test d'intégration). Mais il n'y a aucun protocole pour tester l'orchestrateur lui-même — sa capacité à détecter les incohérences, à gérer les échecs, à prioriser correctement.

**Comment l'implémenter** : Ajouter des scénarios de test spécifiques dans `tests/` :
- Scénario "agent qui échoue" : que fait l'orchestrateur si @design ne produit rien ?
- Scénario "contradiction" : que fait l'orchestrateur si @seo et @copywriter se contredisent ?
- Scénario "drift" : que fait l'orchestrateur si Phase 2 produit un livrable déconnecté de Phase 0 ?

---

## Recommandations par priorité

| # | Action | Impact | Effort | Score visé |
|---|---|---|---|---|
| 1 | Ajouter des critères de vérification binaires (pass/fail) pour l'étape VERIFY | Élevé — élimine la subjectivité dans la QA | Moyen — ~30 lignes à ajouter | 9.5/10 |
| 2 | Classifier les feedbacks remontants par sévérité P0/P1/P2 | Élevé — optimise la séquence de correction | Faible — ~15 lignes | 9.5/10 |
| 3 | Ajouter 3 garde-fous au mode autopilot (drift, livrable vide, limite contexte) | Élevé — prévient les dérapages silencieux | Moyen — ~20 lignes | 9/10 |
| 4 | Créer le bloc "Métriques d'orchestration" dans la synthèse | Moyen — permet l'amélioration continue | Faible — ~10 lignes | 9/10 |
| 5 | Documenter le protocole de reprise après interruption | Moyen — critique pour les projets lourds | Faible — ~15 lignes | 9/10 |
| 6 | Créer des scénarios de test pour l'orchestrateur | Moyen-élevé — valide le cerveau du système | Élevé — ~50 lignes | 9.5/10 |

---

## Vision 10x

Si je devais refaire l'orchestrateur pour qu'il soit 10x plus performant, voici ce que je changerais fondamentalement :

**1. L'orchestrateur devrait apprendre de ses runs.**
Aujourd'hui, chaque orchestration repart de zéro. L'orchestrateur ne sait pas que @creative-strategy met toujours 3 minutes, que @fullstack échoue 20% du temps quand les specs UX sont vagues, ou que @seo et @geo produisent des contradictions dans 1 cas sur 4. Un orchestrateur 10x aurait un `docs/orchestration-history.md` qui capture ces patterns et ajuste ses décisions en conséquence.

**2. L'orchestrateur devrait anticiper, pas réagir.**
Le protocole actuel est réactif : lancer → vérifier → corriger. Un orchestrateur 10x pré-validerait les inputs avant de lancer un agent. Avant de lancer @design, vérifier que `brand-platform.md` contient les tokens nécessaires. Avant de lancer @fullstack, vérifier que les flows UX sont complets. La plupart des échecs sont prévisibles — il suffit de chercher.

**3. L'orchestrateur devrait avoir un "war room mode".**
Quand plus de 2 agents échouent ou quand le drift dépasse un seuil, l'orchestrateur devrait passer en mode crise : arrêter tout, faire un état des lieux complet, réévaluer le plan, et ne reprendre qu'après validation utilisateur. Aujourd'hui, il gère les erreurs une par une. Parfois, les erreurs sont systémiques et nécessitent un recul stratégique.

---

## Verdict final

**L'orchestrateur est à 8.5/10.** C'est un bon système — bien structuré, bien pensé, avec les bons réflexes stratégiques (clarification, priorisation, checkpoint Phase 0). Mais pour atteindre la "marge d'erreur nulle" que tu vises, il a besoin de :

1. **Des critères de vérification objectifs** (pas juste "vérifier la cohérence")
2. **Des garde-fous plus agressifs** en mode autopilot (drift, livrables vides)
3. **Une mémoire d'orchestration** pour apprendre de chaque run

Les 3 premières recommandations du tableau ci-dessus portent le score à 9/10. Les 3 suivantes le portent à 9.5/10. Le 10/10 viendra avec la validation empirique sur des projets réels — on ne peut pas juger un chef d'orchestre sans l'avoir vu diriger un concert.

---

**Handoff → réponse directe**
- Fichiers produits : `docs/reviews/elon-audit-orchestrator-2026-03-22.md`
- Décisions prises : score 8.5/10, 3 problèmes critiques identifiés (vérification subjective, autopilot insuffisamment défensif, feedback non priorisé), 3 manques identifiés (métriques, reprise, tests orchestrateur)
- Points d'attention : implémenter les recommandations 1-3 en priorité pour atteindre 9/10
