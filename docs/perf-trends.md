# Perf Trends — Gradient Agents

Mesure objective de la derive performance du framework, session apres session.
Genere automatiquement par scripts/perf-trend.sh a chaque cloture (P2 Etape 5e).

## Seuils

| Metrique | Cible | WARNING |
|---|---|---|
| M1 — Contexte commun (lignes) | < 1100 | > 1300 |
| M2 — Total /memories/* | < 250 | > 350 |
| M3 — Gates actives | 30-40 | > 50 |
| M4 — Learnings actifs | < 20 | > 30 |
| M5 — orchestrator.md (lignes) | < 500 | > 900 |
| M6 — Fichiers docs/ | < 100 | > 150 |
| M7 — Max invocations agent (meme feature) | <= 3 | > 3 (CRITICAL > 6) |

Verdict session :
- PASS = 0 metrique en WARNING
- WARNING = 1 metrique en WARNING
- CRITICAL = 2+ metriques en WARNING

WARNING TREND DEGRADANT (exit 1 du script) = 3 sessions consecutives avec au moins 1 metrique au-dela de son seuil WARNING.

## Mesures

| Date | Session | M1 | M2 | M3 | M4 | M5 | M6 | M7 | Verdict |
|---|---|---|---|---|---|---|---|---|---|
| 2026-05-05 | 1 | 1007 | 0 [N/A: Phase B pas encore appliquee] | 42 | 20 | 891 | 72 | N/A | PASS |
| 2026-05-06 | 2 | 1007 | 0 [N/A: Phase B pas encore appliquee] | 42 | 20 | 891 | 73 | 2 reviewer | PASS |
| 2026-05-06 | 3 | 1007 | 0 [N/A: Phase B pas encore appliquee] | 42 | 20 | 891 | 73 | 2 reviewer | PASS |
| 2026-05-06 | 4 | 1007 | 0 [N/A: Phase B pas encore appliquee] | 42 | 20 | 891 | 73 | 2 reviewer | PASS |
| 2026-05-06 | 5 | 1007 | 0 [N/A: Phase B pas encore appliquee] | 42 | 20 | 891 | 73 | 2 reviewer | PASS |
| 2026-05-06 | 6 | 1007 | 0 [N/A: Phase B pas encore appliquee] | 32 | 20 | 891 | 75 | 2 reviewer | PASS |
| 2026-05-06 | 7 | 1025 | 0 [N/A: Phase B pas encore appliquee] | 32 | 25 | 891 | 75 | 2 reviewer | PASS |
