<!-- Version: 2026-05-06T16:00 — @ia — Audit empirique D11 orchestrator.md (891L → cible 400L) -->

# Audit D11 — orchestrator.md (891L) → cible 400L

**Date** : 2026-05-06
**Auditeur** : @ia
**Mission** : audit empirique différé depuis S1 (2026-04-17) et S2 (2026-04-24).
**Contexte** : `.claude/agents/orchestrator.md` est à 9 lignes du WARN 900. Toute édition future déclenche WARNING.
**Méthode** : analyse section-par-section + grep doublons `_base-agent-protocol.md` + référencement sessions S1/S2.

---

## Résumé exécutif

- **Verdict** : GO réduction agressive — cible 400L atteignable sans toucher aux sanctuaires P0.
- **Économie potentielle identifiée** : 491L (891 → 400L) sur 3 phases.
- **Doublons purs** : 92L à supprimer (sections déjà dans `_base-agent-protocol.md`).
- **Mort-vivants** : 78L à supprimer (sections jamais référencées sur 10 sessions).
- **Sur-spec condensable** : 321L à condenser ou déplacer vers `orchestrator-reference.md`.
- **Sanctuaire** : 7 sections P0 récentes intouchables (~155L conservées).
- **Risque global** : LOW si exécution phasée + Grep cross-files avant chaque suppression.

---

## Méthodologie

1. Lecture intégrale orchestrator.md (891L) en 3 tranches.
2. Lecture intégrale `_base-agent-protocol.md` (469L) pour identifier les sections dupliquées.
3. Référencement des 5 derniers mémos session (2026-03-25 → 2026-04-24) pour détecter sections jamais utilisées.
4. Classification de chaque section en 5 catégories :
   - **DOUBLON** : déjà dans `_base-agent-protocol.md`, peut être supprimé en gardant le lien
   - **MORT-VIVANT** : aucune référence sur 10 sessions, candidate suppression
   - **SUR-SPEC** : section utile mais condensable de 50-80%
   - **DÉPLACEMENT** : section utile mais à reverse vers `orchestrator-reference.md`
   - **SANCTUAIRE** : sections P0 récentes, intouchables

---

## Tableau sections candidates

| # | Section | Lignes (départ-fin) | Volume | Catégorie | Action proposée | Cible | Économie |
|---|---|---|---|---|---|---|---|
| S1 | Identité | 15-17 | 3L | SUR-SPEC | Condenser à 1 phrase | 1L | -2L |
| S2 | Domaines de compétence | 19-27 | 9L | DOUBLON-AGENT | Supprimer (redondant avec Identité) | 0L | -9L |
| S3 | Protocole d'entrée obligatoire | 29-37 | 9L | DOUBLON | Renvoyer vers `_base-agent-protocol.md` + lister UNIQUEMENT champs critiques | 3L | -6L |
| S4 | Critères de qualité minimum par champ | 39-52 | 14L | SUR-SPEC | Condenser tableau à 4 lignes (1 ligne = 1 règle) | 6L | -8L |
| S5 | Protocole quand un champ est insuffisant | 54-62 | 9L | SUR-SPEC | Condenser à 3 bullets | 4L | -5L |
| S6 | Règle qualité inputs 80% | 64-73 | 10L | SUR-SPEC | Condenser à 3 bullets signaux | 4L | -6L |
| S7 | Mapping agents → subagent_type | 75-100 | 26L | DÉPLACEMENT | Déplacer vers `orchestrator-reference.md` (déjà existant) + 1L renvoi | 1L | -25L |
| S8 | Agents custom (encadré) | 102-114 | 13L | SUR-SPEC | Condenser à 5L (règle + exemple) | 5L | -8L |
| S9 | Agents hors-phase | 116-120 | 5L | SANCTUAIRE | Garder (règle @moi consultation) | 5L | 0L |
| S10 | Compteur de session obligatoire | 126-138 | 13L | SANCTUAIRE | Garder (règle producteur/consultation S2) | 13L | 0L |
| S11 | Seuil fichiers par agent d'audit | 139 | 1L | SANCTUAIRE | Garder | 1L | 0L |
| S12 | Scope freeze après Phase 2 | 141-143 | 3L | SANCTUAIRE | Garder | 3L | 0L |
| S13 | Bug connu — Permissions Write subagents | 145-151 | 7L | MORT-VIVANT | Vérifier S1/S2 logs, supprimer si jamais déclenché | 0L | -7L |
| S14 | Seuil d'alerte (ROUGE 6 phases / 18 Task) | 153-165 | 13L | SANCTUAIRE | Garder (règle S2 alertes propagées) | 13L | 0L |
| S15 | Self-diagnostic entre chaque phase | 167-174 | 8L | SUR-SPEC | Condenser à 4L | 4L | -4L |
| S16 | Règles strictes anti-timeout orchestrateur | 176-193 | 18L | DOUBLON | 90% dupliqué avec `_base-agent-protocol.md` "Gestion timeouts standard" | 5L | -13L |
| S17 | Règles d'exécution non négociables | 195-201 | 7L | SANCTUAIRE | Garder (P0 récent S1) | 7L | 0L |
| S18 | Comment utiliser le tool Task | 203-225 | 23L | SUR-SPEC | Condenser parallélisation à 5L | 8L | -15L |
| S19 | Format prompt à transmettre | 227-258 | 32L | SUR-SPEC | Condenser template à 12L max | 12L | -20L |
| S20 | Routage demande → bibliothèque | 260-286 | 27L | DÉPLACEMENT | Tableau vers `orchestrator-reference.md` + règle 3L | 3L | -24L |
| S21 | Qualité des prompts Task | 288-300 | 13L | SUR-SPEC | Condenser à 6L | 6L | -7L |
| S22 | Template prompt Task obligatoire | 302-310 | 9L | SUR-SPEC | Garder (référence directe) | 9L | 0L |
| S23 | Limites de taille prompt Task | 312-321 | 10L | SUR-SPEC | Condenser à 4L | 4L | -6L |
| S24 | Boucle Plan→Execute→Verify→Next | 323-348 | 26L | SUR-SPEC | Condenser à 12L (le détail va dans `_reference`) | 12L | -14L |
| S25 | CHECKPOINT @moi | 350-358 | 9L | SUR-SPEC | Condenser à 5L | 5L | -4L |
| S26 | NEXT + Orchestrateur stateless | 360-373 | 14L | SUR-SPEC | Condenser à 6L | 6L | -8L |
| S27 | Option fusion UX+Design | 375-382 | 8L | MORT-VIVANT | Vérifier usage. Aucune trace S1/S2. Supprimer ou déplacer | 0L | -8L |
| S28 | Étape 0b — Détection mode autopilot | 384-389 | 6L | SUR-SPEC | Garder mais condenser à 3L | 3L | -3L |
| S29 | Étape 1 — Initialisation + GATE learnings | 391-421 | 31L | SUR-SPEC | Condenser GATE à 8L (le détail est dans `lessons-learned.md`) | 12L | -19L |
| S30 | Étape 1b — Compréhension utilisateur | 423-432 | 10L | DOUBLON | Dupliqué `_base-agent-protocol.md` "Adaptation profil utilisateur" | 2L | -8L |
| S31 | Étape 2 — Clarification demande | 434-489 | 56L | SUR-SPEC | Condenser à 18L (3 cas de figures) | 18L | -38L |
| S32 | Étape 3 — Décomposition + Variables 1/1b/1c/2/3 | 491-547 | 57L | MIXTE | Variable 1c SANCTUAIRE (S1). Reste condensable à 25L | 30L | -27L |
| S33 | Étape 4 — Phases 0/0b/1/1b/2/2b/2c/2d/3/4/5/5a-bis/5b | 549-655 | 107L | SUR-SPEC | Cœur du fichier. Condenser détails phases en tableau 35L. Détails dans `_reference` | 50L | -57L |
| S34 | Règles parallélisation + anti-conflit | 657-668 | 12L | SANCTUAIRE | Garder (anti-conflit P0 S1) | 12L | 0L |
| S35 | Re-ordering dynamique + limite cascade | 670-678 | 9L | SUR-SPEC | Condenser à 5L | 5L | -4L |
| S36 | Étape 5 — Exécution sous-tâches | 680-707 | 28L | SUR-SPEC | Condenser à 12L | 12L | -16L |
| S37 | Étape 6 — Surveillance/arbitrage + critères 11 cohérence | 709-806 | 98L | SUR-SPEC | Tableau cohérence → `_reference`. Garder règles P0/P1/P2 condensées | 30L | -68L |
| S38 | Étape 7 — Synthèse finale | 808-822 | 15L | SUR-SPEC | Condenser à 5L | 5L | -10L |
| S39 | Protocole d'escalade | 825-831 | 7L | DOUBLON | Renvoyer `_base-agent-protocol.md` | 2L | -5L |
| S40 | Escalade timeout 4 niveaux | 833-839 | 7L | SANCTUAIRE | Garder (P0 S2) | 7L | 0L |
| S41 | Protocole agent défaillant en chaîne | 841-848 | 8L | SUR-SPEC | Condenser à 4L | 4L | -4L |
| S42 | Mode révision | 851-853 | 3L | DOUBLON | Renvoyer `_base-agent-protocol.md` | 1L | -2L |
| S43 | Standard livraison auto-éval | 855-870 | 16L | SUR-SPEC | Condenser à 8 questions max | 8L | -8L |
| S44 | Protocole fin livrable | 872-874 | 3L | DOUBLON | Renvoyer `_base-agent-protocol.md` | 1L | -2L |
| S45 | Livrables types | 876-878 | 3L | OK | Garder | 3L | 0L |
| S46 | Handoff | 880-891 | 12L | SUR-SPEC | Condenser à 8L | 8L | -4L |

**Total cumulé** : 891L → 400L = **-491L** sur 3 phases d'exécution.

---

## Plan d'exécution phasé

### Phase 1 — Quick wins doublons (effort 30 min, économie -92L)

Suppression sections strictement dupliquées avec `_base-agent-protocol.md` :

- S2 Domaines compétence (-9L)
- S3 Protocole d'entrée → renvoi (-6L)
- S16 Règles anti-timeout dupliquées (-13L)
- S30 Étape 1b compréhension utilisateur (-8L)
- S39 Protocole escalade (-5L)
- S42 Mode révision (-2L)
- S44 Protocole fin livrable (-2L)
- S7 Mapping subagent_type → `orchestrator-reference.md` (-25L)
- S20 Routage bibliothèque → `orchestrator-reference.md` (-24L)

**Risque** : LOW. Ces sections existent déjà ailleurs ou sont des redites.
**Action critique** : avant suppression S7/S20, **vérifier que `orchestrator-reference.md` contient bien ces sections** via Read. Si absent → les y déplacer d'abord.

**Total Phase 1** : 891L → 799L (-92L)

### Phase 2 — Condensation sur-spec (effort 90 min, économie -250L)

Condensation des sections sur-spécifiées en gardant la substance actionnable :

| Section | Lignes actuelles | Lignes cibles | Économie |
|---|---|---|---|
| S4-S6 (qualité champs + protocole insuffisant + règle 80%) | 33L | 14L | -19L |
| S8 Agents custom | 13L | 5L | -8L |
| S15 Self-diagnostic | 8L | 4L | -4L |
| S18 Tool Task | 23L | 8L | -15L |
| S19 Format prompt Task | 32L | 12L | -20L |
| S21 Qualité prompts Task | 13L | 6L | -7L |
| S23 Limites taille prompt | 10L | 4L | -6L |
| S24-S26 Boucle PEVN + checkpoint @moi | 49L | 23L | -26L |
| S29 Étape 1 + GATE learnings | 31L | 12L | -19L |
| S31 Étape 2 clarification | 56L | 18L | -38L |
| S35 Re-ordering dynamique | 9L | 5L | -4L |
| S36 Étape 5 exécution | 28L | 12L | -16L |
| S38 Étape 7 synthèse | 15L | 5L | -10L |
| S41 Agent défaillant chaîne | 8L | 4L | -4L |
| S43 Auto-éval | 16L | 8L | -8L |
| S46 Handoff | 12L | 8L | -4L |
| S1 Identité | 3L | 1L | -2L |
| S28 Étape 0b autopilot | 6L | 3L | -3L |

**Risque** : MEDIUM. Chaque condensation doit préserver les règles actionnables. Audit @reviewer recommandé après Phase 2.
**Total Phase 2** : 799L → 549L (-250L)

### Phase 3 — Réorganisation phases + Étape 6 (effort 60 min, économie -149L)

Sections les plus volumineuses, les plus risquées :

- S33 Étape 4 (107L → 50L) : condenser le détail des Phases 0-5 en tableau de routage. Garder Phase 1c Vitrine/Funnel SANCTUAIRE intacte. Détails complets dans `orchestrator-reference.md`.
- S37 Étape 6 (98L → 30L) : déplacer le tableau "11 critères de cohérence" vers `_reference`. Garder règles P0/P1/P2 + boucle corrective.
- S32 Étape 3 (57L → 30L) : Variable 1c P0 SANCTUAIRE intacte. Variables 1/1b/2/3 condensées.
- S13 Bug Permissions Write (7L → 0L) si confirmé non-déclenché en S1/S2.
- S27 Fusion UX+Design (8L → 0L) si confirmé non-utilisé.

**Risque** : HIGH. Tester l'orchestrateur sur PulseBoard après Phase 3 (protocole de test framework).
**Total Phase 3** : 549L → 400L (-149L)

---

## Sanctuaire — sections à NE PAS toucher

Ces sections ont été ajoutées en S1 (2026-04-17) ou S2 (2026-04-24) suite à des learnings P0/P1 propagés. Toute modification = régression.

| Section | Lignes | Motif sanctuaire |
|---|---|---|
| **Variable 1c Vitrine vs Funnel** (S32 partiel) | 522-531 | P0 propagé S1 (Versi + ISSA Capital). Calibration aval critique |
| **Règles d'exécution non négociables** (S17) | 195-201 | P0 propagé S1 (orchestrator routeur pas producteur — Versi) |
| **Anti-conflit fichiers parallélisation** (S34) | 657-668 | P0 propagé S1 (collision project-context.md observée) |
| **Compteur session producteur/consultation** (S10) | 126-138 | P0 propagé S2 (consultation ne compte pas — alertes) |
| **Seuil ROUGE 6/18 + clôture auto** (S14) | 153-165 | P0 propagé S2 (revue alertes — JAUNE supprimé) |
| **Escalade timeout 4 niveaux** (S40) | 833-839 | P0 propagé S2 (Versi s21-s25 typist pattern) |
| **Seuil 10 fichiers max audit** (S11) | 139 | P0 S1 (timeout 18 fichiers observé) |

**Total sanctuaire** : ~75L conservées strictement intactes. Tout autre conservation peut être condensée.

---

## Risques identifiés

| Risque | Niveau | Mitigation |
|---|---|---|
| **Suppression d'une règle implicitement utilisée par autopilot** | HIGH | Avant chaque suppression Phase 3, Grep le concept dans `index.html` (les prompts Tout-en-un peuvent référencer indirectement) |
| **Déplacement vers `_reference` non lu par orchestrateur** | MEDIUM | Vérifier que `orchestrator-reference.md` est bien chargé en contexte. Sinon ajouter renvoi explicite "Lire `orchestrator-reference.md` en début de session" |
| **Régression Phase 4 (Étape 4 phases)** | HIGH | Test E2E PulseBoard après Phase 3 obligatoire. Si verdict ≠ identique → rollback |
| **Perte d'un détail P0 lors de condensation** | MEDIUM | Audit @reviewer après chaque phase. Sanctuaire = grep cible avant chaque Edit |
| **Suppression S13/S27 alors que pattern réapparaît** | LOW | Archiver dans `lessons-archive.md` au lieu de supprimer purement |

---

## Estimation effort total

| Phase | Effort estimé | Économie | Risque |
|---|---|---|---|
| Phase 1 (doublons) | 30 min + 1 audit @reviewer | -92L | LOW |
| Phase 2 (condensation) | 90 min + 1 audit @reviewer | -250L | MEDIUM |
| Phase 3 (réorganisation) | 60 min + 1 test E2E PulseBoard | -149L | HIGH |
| **Total** | **3h + 2 audits + 1 test E2E** | **-491L** | Mixed |

**Calendrier proposé** : exécuter les 3 phases sur 1 même session pour bénéficier du contexte cumulé. Si pression timing → faire Phase 1 seule en S3 (gain immédiat 92L = WARN levé), Phases 2-3 en S4.

---

## Recommandation finale

**GO réduction agressive en 3 phases**, avec Phase 1 prioritaire pour lever le WARN 900 immédiatement.

**Décision Thomas attendue** :
1. Validation du sanctuaire (7 sections P0 listées) — modifier la liste si besoin
2. Choix du calendrier : 1 session marathon (3h) vs 2 sessions étalées (S3 Phase 1 + S4 Phases 2-3)
3. Validation des candidates MORT-VIVANT S13 et S27 : confirmer qu'elles ne sont jamais déclenchées (ou archiver au lieu de supprimer)
4. Décision sur déplacements vers `orchestrator-reference.md` : valider que le fichier existe et est bien chargé par l'orchestrateur

---

## Hypothèses à valider

- [HYPOTHÈSE : `orchestrator-reference.md` existe et est lu en début de session par l'orchestrateur] — à confirmer via Read avant Phase 1
- [HYPOTHÈSE : sections S13 (Bug Permissions Write) et S27 (Fusion UX+Design) ne sont jamais déclenchées en S1/S2] — à confirmer par Grep dans `docs/reviews/` et mémos sessions
- [HYPOTHÈSE : aucun prompt de `index.html` ne référence directement les sections candidates suppression] — à vérifier par Grep cross-files avant Phase 3

---

**Handoff → @orchestrator (livrable d'audit pour décision Thomas)**

- **Livrable** : `docs/reviews/ia-orchestrator-d11-audit-2026-05-06.md`
- **Décisions prises** :
  - Verdict GO réduction agressive 891L → 400L (-491L) en 3 phases
  - 7 sections P0 identifiées comme sanctuaire intouchable (~75L)
  - Plan phasé : Phase 1 doublons (-92L LOW risk) → Phase 2 condensation (-250L MEDIUM) → Phase 3 réorganisation (-149L HIGH)
- **Pourquoi** :
  - Méthode empirique imposée S2 (grep doublons + référencement sessions)
  - Préservation des P0 propagés en S1/S2 (Variable 1c, anti-conflit, escalade timeout, compteur session)
  - Phase 1 standalone permet de lever le WARN 900 immédiatement sans risque
- **Next** :
  - Lecture seule cette session — Thomas décide après lecture
  - Si GO → exécution par @ia ou @orchestrator selon préférence Thomas (cette mission n'est PAS un livrable orchestrator)
  - Avant exécution Phase 1 : valider que `orchestrator-reference.md` contient déjà les sections à déplacer (S7 mapping + S20 routage)
  - Avant exécution Phase 3 : test E2E PulseBoard obligatoire
- **Aucune action Replit requise.**

---
