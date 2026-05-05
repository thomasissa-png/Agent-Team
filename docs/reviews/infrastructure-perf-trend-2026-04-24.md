# Infrastructure — Perf Trend (Phase C)

**Agent** : @infrastructure
**Date** : 2026-04-24
**Mission** : garantir la perf maintenue cross-sessions du framework Gradient Agents via mesure objective de la dérive.

## Solution livrée

1. **`scripts/perf-trend.sh`** — Script Bash POSIX (Linux + macOS), idempotent, `set -euo pipefail`. Mesure 6 métriques objectives à chaque clôture P2 :
   - M1 : contexte commun lu par chaque agent (CLAUDE.md + _base-agent-protocol.md + _gates.md + lessons-learned + founder-preferences + project-context)
   - M2 : total `/memories/*` (Phase B IA — retourne 0 + tag `[N/A: Phase B pas encore appliquee]` tant que le répertoire n'existe pas)
   - M3 : nombre de gates actives (`grep "^| G" _gates.md`)
   - M4 : nombre de learnings actifs (`grep "^| 2026-" lessons-learned.md`)
   - M5 : taille `orchestrator.md` (agent le plus appelé)
   - M6 : nombre total de fichiers `docs/**/*.md` (saturation)

2. **`docs/perf-trends.md`** — Tableau markdown auto-créé avec en-tête + seuils + 1ère ligne baseline. Format `| Date | Session | M1-M6 | Verdict |`.

3. **Détection trend dégradant** — Lecture des 3 dernières lignes ; si 3/3 ont verdict WARNING ou CRITICAL : exit code 1 + message `WARNING TREND DEGRADANT`.

4. **Intégration P2 (`index.html` Étape 5e)** — Insérée entre 5d (commandement n°8) et 6 (confirmation). Zéro backtick respecté (learning P0). Si exit non-zero → STOP clôture obligatoire.

## Run-sample (baseline 2026-05-05, repo Agent-Team)

| Métrique | Mesure | Cible | WARNING | Statut |
|---|---|---|---|---|
| M1 — Contexte commun | 1007 | < 1100 | > 1300 | OK |
| M2 — Memories | 0 [N/A] | < 250 | > 350 | OK (Phase B non appliquée) |
| M3 — Gates actives | 42 | 30-40 | > 50 | DEPASSE CIBLE (proche WARN) |
| M4 — Learnings actifs | 20 | < 20 | > 30 | EN LIMITE CIBLE |
| M5 — orchestrator.md | 891 | < 500 | > 900 | DEPASSE CIBLE (1L de WARN) |
| M6 — Fichiers docs/ | 72 | < 100 | > 150 | OK |

**Verdict baseline session 1 : PASS** (aucune métrique au-delà du seuil WARNING).

## Lecture du verdict

- Le framework est en zone "PASS" mais avec **3 métriques (M3, M4, M5) en limite de cible** ou au-delà.
- M5 (orchestrator.md = 891) est à 1 ligne du WARNING (>900) : à surveiller en priorité. Toute addition à orchestrator.md déclenchera un WARNING dès la prochaine session.
- M3 (gates = 42) dépasse la fourchette cible 30-40 mais reste loin du WARN (>50). Acceptable tant que stable.
- M4 (learnings = 20) atteint la limite cible. Le commandement n°8 (TTL learnings) doit s'appliquer rigoureusement à la prochaine clôture.

## Limitations connues

1. **M2 inopérant tant que Phase B (Memory tool) n'est pas implémentée** — solution : le script retourne 0 + tag explicite `[N/A: Phase B pas encore appliquee]`. Dès que `.memories/` sera créé par @ia (Phase B), la mesure deviendra automatique sans modification du script.

2. **Pas de visualisation graphique** — `docs/perf-trends.md` reste tabulaire. Évolution future : génération d'un graphe ASCII ou export CSV pour outil externe si > 20 sessions accumulées.

3. **Pas de comparaison delta inter-sessions** — chaque ligne est un snapshot. Évolution future : ajouter colonne "delta vs session précédente" si demande Thomas.

4. **Détection trend basée sur verdict global, pas par métrique** — un trend dégradant nécessite 3 sessions consécutives en WARNING/CRITICAL **toutes métriques confondues**. Une métrique unique qui dérive lentement peut passer sous le radar. Évolution future : trend par métrique individuelle si nécessaire.

## Tests effectués

- `bash -n scripts/perf-trend.sh` : SYNTAX OK
- `bash scripts/perf-trend.sh` : exit 0, ligne baseline ajoutée à `docs/perf-trends.md`
- Idempotence vérifiée : 2 runs successifs ajoutent 2 lignes distinctes (session #1, session #2) sans casser
- Anti-bug `((var++))` learning P1 : utilisation de `var=$((var+1))` partout

---

**Handoff → @orchestrator**
- Fichiers produits :
  - `/home/user/Agent-Team/scripts/perf-trend.sh` (exécutable, 224 lignes)
  - `/home/user/Agent-Team/docs/perf-trends.md` (en-tête + 1 ligne baseline)
  - `/home/user/Agent-Team/index.html` (Étape 5e ajoutée ligne 3630)
  - `/home/user/Agent-Team/docs/reviews/infrastructure-perf-trend-2026-04-24.md` (ce rapport)
- Décisions prises : seuils M1-M6 alignés sur la spec mission, verdict 3-niveaux (PASS / WARNING / CRITICAL), trend dégradant = 3 sessions consécutives non-PASS
- Points d'attention :
  - M5 à 1 ligne du WARNING — toute édition de orchestrator.md à surveiller
  - M2 reste à 0 jusqu'à livraison Phase B par @ia (intégration automatique)
- **Actions Replit requises** : aucune (script local Bash, pas d'infra cloud)
---
