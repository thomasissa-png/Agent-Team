# Revue technique IA — Session 2026-04-17 → 2026-04-24

**Agent** : @ia | **Date** : 2026-05-06 | **Périmètre** : migration Opus 4.7, commandement n°8, gates G31/G32, Phase A/B/C, A1+A2+A3, fixes upstream `update.sh`/`install.sh`

---

## 1. Note globale : **8.5 / 10**

Session dense, exécutée avec rigueur production. Architecture Memory ancrée sur la doc Anthropic. Bugs upstream correctement traités. **Un défaut technique réel** : compteur M3 du script perf-trend mesure 42 au lieu de 32 (capture aussi GP1-10 et GC1-10) — pattern grep trop permissif. Réelle dérive silencieuse possible.

## 2. Notation par angle

| # | Angle | Note | Justification 1 ligne |
|---|---|---|---|
| 1 | Cohérence subagent architecture 2026 | 9/10 | Frontmatter, tools whitelist, MCP respectés ; effort/maxTurns documentés correctement comme limités au top-level (non-Task) |
| 2 | Qualité scripts (`perf-trend.sh` + spec Memory) | 7.5/10 | `set -euo pipefail` OK, anti-`((var++))` OK partout (sauf commentaire ligne 9), `bash -n` PASS, run réel PASS. **Bug** : pattern M3 `^\| G` capture GP/GC → overcount 42 au lieu de 32 |
| 3 | Cohérence cross-fichiers (32 gates) | 8/10 | CLAUDE.md, _gates.md, agents alignés sur "32 gates G1-G32". Pattern grep du script désaligné — mais doc cohérente |
| 4 | Spec Memory tool (Phase B) | 9/10 | Limitations 2026 (client-side, 100KB/8 stores, pas de TTL natif) bien adressées. Caps 250L 3x plus stricts qu'Anthropic = défensif. TTL simulé via header structuré = pragmatique |
| 5 | Anti-régression bugs upstream | 9/10 | `--no-cone` présent dans install.sh:69 et update.sh:71. `var=$((var+1))` présent update.sh:102,110,124,126. Audit complet du repo : aucun autre `((var++))` actif (seul match = commentaire perf-trend.sh:9) |
| 6 | Performance future (M1-M7) | 7.5/10 | 7 métriques couvrent volume + qualité (M7) + scope. **Angles morts** : pas de mesure latence orchestrator réelle, pas de mesure consommation tokens session, pas de mesure taux d'invocation reviewer (proxy qualité) |

## 3. Top 3 forces techniques

1. **Spec Memory ancrée doc Anthropic** : caps 250L vs 100KB Anthropic (3x plus restrictif), header structuré avec session_id+date pour TTL simulé, lecture orchestrator-only pendant session = excellent compromis perf/utilité. Le rejet du "1 fichier par agent" est une vraie décision d'architecture, pas du cargo-cult.
2. **Robustesse `update.sh`/`install.sh`** : le passage `--no-cone` + `var=$((var+1))` règle 2 bugs production réels. Le fallback clone complet si sparse échoue est correct. Backup avant update + rollback explicite = pattern production-grade.
3. **`perf-trend.sh` pragmatique** : helpers `count_lines` / `safe_grep_c`, idempotent, fallback "[N/A]" sur métriques absentes (Memory Phase B), détection trend dégradant 3 sessions = **observabilité framework concrète**, pas cosmétique.

## 4. Top 3 risques techniques résiduels

1. **BUG M3 perf-trend.sh — overcount gates** : `safe_grep_c "^| G" _gates.md` retourne **42** (capture G1-32 + GP1-10 + GC1-10) au lieu de 32. **Fix précis** : remplacer pattern par `^| G[0-9]` (ligne 89) → retourne 32. Sans ce fix, les seuils M3 (cible 30-40, warn >50) sont biaisés à vie : 42 dépasse déjà la cible haute mais est lu comme borderline acceptable. Risque : warning silencieux + perte de confiance dans le tableau de bord.
2. **M5 (orchestrator.md) à 891 lignes / cap 900** : run réel mesure orchestrator.md à **891 lignes** (cap WARNING = 900). 9 lignes de marge. Toute prochaine session qui ajoute du contexte → flip immédiat en WARNING. **Monitoring** : surveiller le delta orchestrator.md dans chaque PR ; déclencher refactoring P1 dès 850L.
3. **Spec Memory : protocole d'écriture concurrent non spécifié** : si 2 sessions tournent en parallèle (ex: Sarani + Versi), les écritures sur `/memories/framework-learnings.md` peuvent se croiser (last-write-wins, pas de lock). Anthropic Memory tool est client-side — la responsabilité de la concurrence est à nous. **Monitoring** : ajouter à la spec un champ `last_modified_session_id` en tête de fichier + check avant écriture (refus si session_id différente de celle attendue). Pas bloquant pour POC mais bloquant pour production multi-projet simultané.

## 5. Verdict global

**GO AVEC RÉSERVES**.

Le travail est de qualité production sur 5 angles sur 6. Le bug M3 doit être corrigé **avant la prochaine clôture de session** (fix 1 ligne, impact direct sur la confiance du dashboard). Les 2 autres risques sont des signaux faibles à surveiller, pas des bloquants.

Conditions de levée des réserves :
- [ ] Fix pattern M3 dans `scripts/perf-trend.sh:89` (`^| G` → `^| G[0-9]`)
- [ ] Ajouter à `ia-memory-tool-integration-spec` section "Concurrence multi-projets" (last_modified_session_id)
- [ ] Re-run `bash scripts/perf-trend.sh` après fix M3 pour vérifier M3=32

Sources techniques :
- Subagent frontmatter : https://code.claude.com/docs/en/sub-agents
- Memory tool client-side limites : https://platform.claude.com/docs/en/agents-and-tools/tool-use/memory-tool

---
**Handoff → @orchestrator**
- Fichier produit : `/home/user/Agent-Team/docs/reviews/ia-session-review-2026-04-24.md`
- Décisions : note globale 8.5/10, GO AVEC RÉSERVES, 1 bug bloquant identifié (M3 overcount), 2 signaux faibles (M5 marge 9L, concurrence Memory).
- Points d'attention : fix `scripts/perf-trend.sh:89` à prioriser avant prochaine clôture ; surveiller orchestrator.md (891/900) ; ajouter section concurrence à la spec Memory.
---
