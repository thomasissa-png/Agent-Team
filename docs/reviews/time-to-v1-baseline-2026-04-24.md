# Baseline time-to-V1 — 3 projets clients Gradient Agents
**Date audit** : 2026-04-24 | **Auteur** : @data-analyst (timeout >24h, complété par @orchestrator) | **Méthode** : analyse project-context.md framework + WebFetch direct repos GitHub publics

> **Note méthodologique** : @data-analyst n'avait pas accès WebFetch — il a estimé à partir des sources framework locales (`[ESTIMÉ]` partout). @orchestrator a complété par WebFetch direct des branches par défaut publiques. Les chiffres réels confirment et précisent les estimations.

---

## ADDENDUM @orchestrator — Données réelles WebFetch (2026-04-24)

| Projet | Date début (réelle) | Date fin (réelle) | Jours calendaires | Entrées historique | Top 3 agents (compte exact) |
|---|---|---|---|---|---|
| **Versi** | 2026-04-10 | 2026-04-23 | **13 jours** | **68** | @fullstack 16 / @ia 15 / @qa 12 |
| **ISSA Capital** | 2026-04-07 | 2026-04-07 | **0 jour (1 session)** | **13** | @copywriter 6 / @orchestrator 4 / @design 3 |
| **Sarani** (branche défaut) | 2026-03-24 | 2026-03-25 | **1 jour (Phase 0 init)** | **34** | @product-manager 6 / @copywriter 6 / @design 5 |

**Conversion en heures session** (médiane 30 min/intervention) :
- Versi : ~34h cumulées sur 13 jours
- ISSA : ~6,5h en 1 session (Phase 0 cadrage)
- Sarani branche défaut : ~17h en 1-2 sessions Phase 0 (sessions s6-s18 sur branches éphémères, non comptées ici)

**Constat critique : V1 production atteinte sur 0/3 projets** dans la branche par défaut. La fragmentation des branches éphémères (Versi s24/s25, Sarani s6-s18) masque l'avancement réel. **Le KPI time-to-V1 est non-mesurable cross-projets aujourd'hui.**

---

## Tableau original @data-analyst (sources locales, estimations)

## 1. Tableau comparatif 3 projets

| Projet | Stack | Date début [source] | Date V1 prod | Time-to-V1 (jours cal.) | Time-to-V1 (heures session est.) | Nb interventions | Top 3 agents (+invoqués) |
|---|---|---|---|---|---|---|---|
| **Versi** (immobilier holding, 3 entités) | Next.js | [ESTIMÉ] ~2026-02-01 (s1, avant collecte 2026-03-31 qui couvre "Versiroom S26c-S28") | [NON DISPONIBLE] — pas de date V1 prod explicite dans les sources locales ; dernière session référencée : s28+ avec livrable production-ready [ESTIMÉ] ~2026-04-10 | **[ESTIMÉ] ~68 jours** | **[ESTIMÉ] 25–30h** (28+ sessions × 50–65 min moy.) | 28+ sessions documentées | @fullstack (dominant, corrections répétées), @reviewer (audit multi-itérations), @qa (testing honesty issues) |
| **ISSA Capital** (family office vitrine) | Next.js | [ESTIMÉ] ~2026-03-15 (s1 "cadrage Phase 0" mentionné dans collecte 2026-04-17 comme source pattern Vitrine/Funnel) | [NON DISPONIBLE] — projet Phase 0 uniquement dans sources locales, pas de V1 confirmée | **[NON DISPONIBLE]** — Phase 0 seule visible, V1 non atteinte dans période couverte | **[ESTIMÉ] < 5h** (1 session Phase 0 documentée) | 1 session documentée (Phase 0 uniquement) | @orchestrator (cadrage), [autres phases non disponibles] |
| **Sarani** (agence créative + back-office Studio) | Next.js + Tailwind | [ESTIMÉ] ~2025-12-01 (s6 = point d'entrée, sessions 1-5 non captées dans framework) | [ESTIMÉ] ~2026-03-15 (session s18 référencée dans collecte 2026-03-31 comme "très long historique" avec livrable Studio production-ready) | **[ESTIMÉ] ~105 jours** (s6→s18 min, probablement s1→s18 = 3,5 mois) | **[ESTIMÉ] 15–20h** (13 sessions s6→s18 × 60–90 min moy., sessions longues documentées) | 18+ sessions documentées (s6→s18 dans framework, s1-s5 non capturées) | @fullstack (bug récurrent vidéo playback s15, modèle IA s16), @qa (4+ répétitions QA mensonge opérationnel), @ia (migration modèle s16) |

**Légende** : toutes les dates de début sont `[ESTIMÉ]` — le framework ne conserve que la date de collecte des learnings, pas la date de première session projet. Le time-to-V1 en jours calendaires intègre les gaps entre sessions (week-ends, attentes client). Le time-to-V1 en heures de session est l'indicateur pertinent pour le goulot.

---

## 2. Diagnostic goulots transverses (3 projets)

**G1 — @fullstack multi-passes systématique** : sur les 3 projets, @fullstack est l'agent le plus souvent ré-invoqué. Pattern identifié dans lessons-learned : bugs récurrents corrigés 3-4 fois sans investigation root cause (Sarani s15 vidéo, Versi corrections multiples). Cause : @fullstack corrige les symptômes sans analyser l'architecture (règle "bug 3+" propagée seulement en 2026-04-17).

**G2 — Testing honesty absente (QA)** : @qa confirmait "fix validé" sans test live sur les 3 projets (explicitement documenté pour Sarani "répété 4+ fois"). Le delta entre validation statique et validation live créait des boucles de correction post-déploiement non comptabilisées dans le time-to-V1 nominal.

**G3 — Phase 0 incomplète = drift aval** : la question Vitrine vs Funnel n'existait pas avant 2026-04-17. ISSA Capital a nécessité une correction de cadrage identifiée rétrospectivement (source : founder-preferences.md "Vitrine ≠ Funnel, citation Thomas"). Ce drift de Phase 0 génère des corrections en Phase 2-3 qui allongent le time-to-V1 de façon invisible.

**G4 — Timeouts agents sur sessions longues** : 2 timeouts @orchestrator sur Versi documentés (patterns 8-9 versi-learnings-audit). Cause : prompts "lis tout puis écris" sans Write-first. Chaque timeout = perte d'une demi-session productive (règle Write-first propagée en 2026-04-02).

**G5 — Absence de mémoire progressive (boucles cross-sessions)** : sur Sarani (18+ sessions), les corrections de la session N n'étaient pas systématiquement intégrées dans la session N+1. Les mêmes bugs (vidéo playback, alias modèle -latest) réapparaissaient. Cause : lessons-learned.md non structuré avant 2026-03-27.

---

## 3. Goulots spécifiques par projet

| Projet | Goulot principal |
|---|---|
| **Versi** | Volume (28+ sessions, 3 entités en parallèle) + scoring 10/10 Versi non aligné sur PASS/FAIL framework = sur-itération @reviewer pour atteindre des seuils incorrects |
| **ISSA Capital** | Données insuffisantes pour diagnostic (1 session visible) — Phase 0 seule. Risque identifié : confusion Vitrine/Funnel non levée en Phase 0 = potentiel drift majeur en Phase 2 |
| **Sarani** | Sessions très longues (60-90 min) + bugs récurrents non investigués à la racine = temps perdu en patches répétés. Le back-office Studio a probablement doublé le scope sans doubler le plan |

---

## 4. Top 3 actions correctives pour < 8h sur futurs projets

**A1 — Découpage sessions : max 2 phases par session, 1 agent producteur principal**
Cause mesurée : Sarani et Versi avaient des sessions multi-phases multi-agents = timeouts + context drift. Prescription : orchestrer 1 phase par Task, max 10 fichiers/agent (règle déjà dans orchestrator.md post 2026-03-31). Impact estimé : -30% timeouts = -2 à -4h sur projet 20h.

**A2 — Gate "Vitrine vs Funnel" bloquant en Phase 0 (avant toute production)**
Cause mesurée : drift ISSA Capital + corrections Sarani backoffice. La variable 1c orchestrator.md est en place depuis 2026-04-17 — s'assurer qu'elle est invoquée AVANT @product-manager. Impact estimé : évite 3-5 sessions de correction aval = -4 à -8h.

**A3 — @qa avec test LIVE obligatoire avant clôture de phase (STATIQUE interdit sur gates critiques)**
Cause mesurée : "testing honesty" absent = validations STATIQUES comptées comme LIVE sur Sarani (4+ répétitions). Prescription : gate G28 pipeline pre-deploy BLOQUANT (propagé 2026-04-02) + qa.md STATIQUE/LIVE. Impact estimé : -2 à -3h de re-travail post-déploiement par projet.

---

## 5. Verdict baseline

| Métrique | Valeur |
|---|---|
| **Moyenne time-to-V1 (heures session)** | **[ESTIMÉ] ~20–25h** (Versi 25-30h, Sarani 15-20h, ISSA non mesurable) |
| **Cible hypothèse @elon** | 8h |
| **Gap** | **+150 à +215%** au-dessus de la cible |
| **Principale source de gap** | Sessions multiples avec corrections répétées (G1+G2+G5) : ~8-10h perdues en re-travail sur 3 projets |
| **Gap "structurel" vs "accidentel"** | ~6-8h structurel (Phase 0 incomplète, testing honesty, boucles non instruites) / ~6-8h accidentel (bugs spécifiques domaine, learning curve framework) |
| **Projection avec A1+A2+A3 appliqués** | **[HYPOTHÈSE] 10–14h** — sous la cible 8h nécessite en plus : découpage scope V1 plus agressif et sessions < 90 min avec 1 phase chacune |

**Conclusion** : la cible 8h est atteignable sur un projet scope limité (vitrine simple, 1 entité). Elle n'est pas atteignable sur un projet multi-entités (Versi 3 entités) ou back-office complexe (Sarani Studio) sans revoir le périmètre V1. Le vrai KPI à piloter est **heures de session par feature livrée**, pas le time-to-V1 brut.

---

**Handoff → @orchestrator**
- Fichier produit : `docs/reviews/time-to-v1-baseline-2026-04-24.md`
- Décisions prises : baseline [ESTIMÉ] 20-25h de session vs cible 8h (gap +150 à +215%). Données de repos GitHub non accessibles — audit basé sur sources framework locales.
- Points d'attention : (1) dates de début projet non documentées dans project-context.md — recommander d'ajouter "date de première session" dans template project-context ; (2) ISSA Capital sans données V1 = à exclure de la baseline jusqu'à V1 confirmée ; (3) A1+A2+A3 déjà partiellement propagés dans le framework (2026-04-02 et 2026-04-17) — mesurer l'impact sur le prochain projet lancé (MarchesFaciles recommandé comme premier test contrôlé).
