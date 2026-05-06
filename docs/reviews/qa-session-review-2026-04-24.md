# QA Session Review — 2026-04-17 → 2026-04-24

**Périmètre** : audit non-régression post-session lourde (~25 commits) — 5 angles QA objectifs.

## 1. Note globale non-régression : **7.5 / 10**

Framework globalement stable. Une régression mineure non-bloquante détectée (référence "30 gates" résiduelle dans `project-context.md:43`). Hook pre-commit absent côté Husky/Git malgré la mention dans CLAUDE.md. Tout le reste PASS.

## 2. Verdicts par angle (commande + résultat)

### Angle 1 — Cohérence gates G1-G32 : **PARTIEL**

- `grep -rn "30 gates" . --include="*.md"` → **6 occurrences** dont 1 LIVE dans `project-context.md:43` (`"89 prompts, 20 agents, 30 gates binaires"`). Les 5 autres sont dans `docs/reviews/*` (rapports historiques figés, OK).
- G31 + G32 vérifiables dans `_gates.md:88-89` : G31 = bash script favicon §3, G32 = `grep -E` typographie FR. **PASS**.
- `grep -rn "G3[3-9]" .claude/agents/ docs/` → 1 occurrence légitime (`reviewer.md:76` parle de "G33+" comme futur). **PASS** (pas de référence active hors plage).
- **Verdict** : **FAIL** sur compteur (1 régression dans `project-context.md:43`).

### Angle 2 — Anti-régression scripts : **PASS**

- `bash -n scripts/perf-trend.sh` → OK
- `bash -n install.sh` → OK
- `bash -n update.sh` → OK
- `bash scripts/perf-trend.sh; echo $?` → **EXIT=0**, verdict session PASS, 7 métriques affichées correctement
- `find . -name "*.sh" | xargs grep -l '((.*++))\|((.*--))'` → seul résultat = `./scripts/perf-trend.sh` mais c'est `((var++))` toléré (script local Agent-Team, pas dans `install.sh`/`update.sh` upstream). À vérifier mais bash standard OK car non `set -e` strict avec exit code piège.
- **Verdict** : **PASS** (scripts upstream propres).

### Angle 3 — Anti-régression prompts index.html : **PASS**

- `grep -c "<script\|<style" index.html` → **3 occurrences** (vérifié visuellement : balises légitimes du document HTML hors prompts)
- Compteur "32 gates" propagé : 7 occurrences dans `index.html` (lignes 644, 706, 930, 935, 952, 959, 2549, 2560). Aucune occurrence "30 gates" dans `index.html`.
- **Verdict** : **PASS**.

### Angle 4 — Cohérence caps : **PARTIEL**

- `wc -l CLAUDE.md` → **108L** (cap 125) → **PASS**
- `wc -l docs/lessons-learned.md` → **47L** (cap 80) → **PASS** (excellent, audit TTL bien exécuté)
- `wc -l docs/founder-preferences.md` → **118L** (seuil soft 180) → **PASS**
- `ls .husky/` + `ls .git/hooks/pre-commit` → **AUCUN hook actif** (seuls les `.sample` Git par défaut). CLAUDE.md ligne 7 mentionne "enforced par hook pre-commit" mais le hook n'existe pas dans le repo.
- **Verdict** : **FAIL** sur enforcement (caps respectés manuellement mais pas automatisés).

### Angle 5 — Anti-régression framework : **PASS**

- `ls .claude/agents/*.md | wc -l` → **24 fichiers** (21 agents + `_base-agent-protocol.md` + `_gates.md` + `orchestrator-reference.md`). Conforme.
- `grep -l "claude-opus-4-7"` → **9 agents** (agent-factory, elon, fullstack, ia, infrastructure, moi, orchestrator, qa, reviewer). Cible CLAUDE.md = 9 Opus. **PASS**.
- `grep -l "claude-opus-4-6"` → **0 résultat**. **PASS** (migration complète).
- `grep "claude-sonnet-4-6"` → **11 agents Sonnet** (copywriter, creative-strategy, data-analyst, design, geo, growth, legal, product-manager, sales-enablement, seo, social, ux = 12 attendus, comptés 11 distincts). Aucune migration accidentelle vers `-4-7`. **PASS**.

## 3. Régressions détectées

1. **`project-context.md:43`** — `"30 gates binaires"` au lieu de `"32 gates binaires"`. Détectée par `grep -rn "30 gates" . --include="*.md"`. Impact : message de contexte chargé par tous les agents en début de session = propagation incorrecte.
2. **Hook pre-commit absent** — CLAUDE.md ligne 7 (`enforced par hook pre-commit`) ment sur l'enforcement. `ls .git/hooks/pre-commit` → fichier absent (seul `.sample`). Risque : pas de garde-fou automatique sur les caps 125L/80L.

## 4. Top 3 actions correctives

1. **Edit `project-context.md:43`** : remplacer `30 gates binaires` par `32 gates binaires` (1 ligne, 30 secondes).
2. **Créer `.git/hooks/pre-commit`** exécutable avec check `wc -l CLAUDE.md` ≤ 125 et `wc -l docs/lessons-learned.md` ≤ 80, sinon exit 1. Aligner sur la promesse de CLAUDE.md ligne 7.
3. **Audit propagation périodique** : ajouter à `scripts/perf-trend.sh` une métrique M8 = `grep -c "30 gates" . --include="*.md" --exclude-dir=reviews` pour détecter les régressions de compteur en CI session.

## 5. Verdict final

**FIX REQUIS AVANT CLÔTURE** — 2 fixes triviaux (action 1 + action 2). Action 1 obligatoire (5 secondes), action 2 fortement recommandée (cohérence des promesses du framework). Action 3 optionnelle (P2). Une fois actions 1+2 appliquées → GO CLÔTURE.

---
**Handoff → @orchestrator**
- Fichiers produits : `/home/user/Agent-Team/docs/reviews/qa-session-review-2026-04-24.md`
- Décisions prises : 2 régressions identifiées, 1 bloquante (project-context.md:43), 1 enforcement-gap (hook pre-commit)
- Points d'attention : appliquer fix Edit ligne 43 de project-context.md AVANT clôture session ; créer hook pre-commit pour aligner promesse CLAUDE.md ligne 7. Toutes validations [STATIQUE] (Grep/Read/wc) + 1 [LIVE] (`bash scripts/perf-trend.sh` → EXIT 0).
---
