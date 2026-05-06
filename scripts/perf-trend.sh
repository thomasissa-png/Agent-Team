#!/usr/bin/env bash
# perf-trend.sh — Mesure 7 metriques de perf du framework Gradient Agents
# Usage : bash scripts/perf-trend.sh
# Sortie : append 1 ligne dans docs/perf-trends.md
# Exit 0 = PASS, Exit 1 = WARNING TREND DEGRADANT (3 sessions consecutives)
#
# Conventions :
# - Bash POSIX-friendly (Linux + macOS)
# - Anti-bug ((var++)) : on utilise var=$((var+1)) partout (learning P1)
# - Idempotent : peut etre re-execute sans casser
# - Si une metrique non-disponible (ex: M2 si Phase B pas encore appliquee), retourne 0 + commentaire

set -euo pipefail

# --- Resolution chemins (script peut etre lance depuis n'importe ou) ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

PERF_FILE="docs/perf-trends.md"

# --- Seuils ---
M1_TARGET=1100; M1_WARN=1300
M2_TARGET=250;  M2_WARN=350
M3_TARGET_LO=30; M3_TARGET_HI=40; M3_WARN=50
M4_TARGET=20;   M4_WARN=30
M5_TARGET=500;  M5_WARN=900
M6_TARGET=100;  M6_WARN=150
M7_TARGET=3;    M7_WARN=3;    M7_CRIT=6   # M7 : > M7_WARN = WARNING, > M7_CRIT = CRITICAL

# --- Helper : compte lignes d'un fichier, 0 si absent ---
count_lines() {
  local f="$1"
  if [ -f "$f" ]; then
    wc -l < "$f" | tr -d ' '
  else
    echo 0
  fi
}

# --- M1 : Contexte commun lu par chaque agent ---
# Note : _base-agent-protocol.md et _gates.md sont dans .claude/agents/
M1_FILES=(
  "CLAUDE.md"
  ".claude/agents/_base-agent-protocol.md"
  ".claude/agents/_gates.md"
  "docs/lessons-learned.md"
  "docs/founder-preferences.md"
  "project-context.md"
)
M1=0
for f in "${M1_FILES[@]}"; do
  n=$(count_lines "$f")
  M1=$((M1 + n))
done

# --- M2 : Total /memories/* (Memory tool, Phase B) ---
M2=0
M2_NOTE=""
if [ -d ".memories" ]; then
  # Compter lignes de tous les .md dans .memories
  shopt -s nullglob 2>/dev/null || true
  for f in .memories/*.md; do
    [ -f "$f" ] || continue
    n=$(count_lines "$f")
    M2=$((M2 + n))
  done
else
  M2_NOTE="[N/A: Phase B pas encore appliquee]"
fi

# --- Helper : grep -c safe (retourne toujours un entier propre) ---
safe_grep_c() {
  local pattern="$1"
  local file="$2"
  local n
  if [ ! -f "$file" ]; then
    echo 0
    return
  fi
  n=$(grep -c "$pattern" "$file" 2>/dev/null || true)
  n=$(echo "$n" | tr -d ' \n' | head -c 10)
  [ -z "$n" ] && n=0
  echo "$n"
}

# --- M3 : Nombre de gates actives ---
GATES_FILE=".claude/agents/_gates.md"
M3=$(safe_grep_c "^| G[0-9]" "$GATES_FILE")

# --- M4 : Nombre de learnings actifs (non archives) ---
LL_FILE="docs/lessons-learned.md"
M4=$(safe_grep_c "^| 2026-" "$LL_FILE")

# --- M5 : Taille orchestrator.md ---
ORCH_FILE=".claude/agents/orchestrator.md"
M5=$(count_lines "$ORCH_FILE")

# --- M6 : Nombre de fichiers docs/ ---
if [ -d "docs" ]; then
  M6=$(find docs -type f -name "*.md" | wc -l | tr -d ' ')
else
  M6=0
fi

# --- M7 : Sur-invocation d'un agent sur une meme feature ---
# Compte le max d'invocations d'un meme agent dans le tableau "Historique des interventions agents"
# de project-context.md. Si > 3 -> WARNING. Si > 6 -> CRITICAL.
# Format de sortie : "<max> <agent>" ex "16 fullstack"
# Fallback : "0 [N/A: pas de project-context]" ou "0 [N/A: format historique non reconnu]"
M7=0
M7_AGENT=""
M7_NOTE=""
PCTX_FILE="project-context.md"

if [ ! -f "$PCTX_FILE" ]; then
  M7_NOTE="[N/A: pas de project-context]"
else
  # Extraire la section "Historique des interventions agents" :
  # de "## Historique des interventions" jusqu'a la prochaine section (^## , ^---, ou EOF)
  HIST_START=$(grep -nE "^## Historique des interventions" "$PCTX_FILE" 2>/dev/null | head -1 | cut -d: -f1)
  if [ -z "$HIST_START" ]; then
    # Fallback : chercher directement l'en-tete tableau "| Agent"
    HIST_START=$(grep -nE "^\| Agent " "$PCTX_FILE" 2>/dev/null | head -1 | cut -d: -f1)
  fi

  if [ -z "$HIST_START" ]; then
    M7_NOTE="[N/A: format historique non reconnu]"
  else
    # Extraire les lignes de tableau apres HIST_START, jusqu'a la prochaine section (^## ou ^---)
    # awk : on commence apres HIST_START, on stoppe a ^## (sauf le ## Historique lui-meme) ou ^---
    HIST_BLOCK=$(awk -v start="$HIST_START" '
      NR < start { next }
      NR == start { in_hist = 1; next }
      in_hist && /^## / { exit }
      in_hist && /^---[[:space:]]*$/ { exit }
      in_hist { print }
    ' "$PCTX_FILE")

    if [ -z "$HIST_BLOCK" ]; then
      M7_NOTE="[N/A: format historique non reconnu]"
    else
      # Extraire la 1ere colonne des lignes de tableau (qui commencent par "| ")
      # Exclure :
      #   - en-tete "| Agent"
      #   - separateur "|---" ou "| ---"
      # Normaliser : strip @, lower-case, prendre 1er token avant " (", " +", ","
      AGENTS_LIST=$(echo "$HIST_BLOCK" | awk -F'|' '
        /^\| / {
          col = $2
          # Trim spaces
          gsub(/^[[:space:]]+|[[:space:]]+$/, "", col)
          # Skip header / separator
          if (col == "Agent") next
          if (col ~ /^-+$/) next
          if (col == "") next
          # Skip lignes "Session" du tableau score fidelite (defense en profondeur)
          if (col == "Session") next
          if (col == "Fichier") next
          # Strip leading @
          sub(/^@/, "", col)
          # Garder 1er token avant " (", " +", ",", " /"
          n = split(col, parts, /[[:space:]]*[(+,\/][[:space:]]*/)
          token = parts[1]
          gsub(/^[[:space:]]+|[[:space:]]+$/, "", token)
          # Lower-case
          token = tolower(token)
          if (token != "") print token
        }
      ')

      if [ -n "$AGENTS_LIST" ]; then
        # Compter chaque agent et garder le max
        TOP_LINE=$(echo "$AGENTS_LIST" | sort | uniq -c | sort -rn | head -1)
        if [ -n "$TOP_LINE" ]; then
          M7=$(echo "$TOP_LINE" | awk '{print $1}')
          M7_AGENT=$(echo "$TOP_LINE" | awk '{print $2}')
        fi
      fi

      if [ "$M7" = "0" ] || [ -z "$M7_AGENT" ]; then
        M7_NOTE="[N/A: format historique non reconnu]"
        M7=0
        M7_AGENT=""
      fi
    fi
  fi
fi

# --- Verdict pour CETTE session (PASS / WARNING / CRITICAL) ---
# WARNING si au moins 1 metrique depasse son seuil WARN
verdict_session() {
  local warn=0
  [ "$M1" -gt "$M1_WARN" ] && warn=$((warn + 1))
  [ "$M2" -gt "$M2_WARN" ] && warn=$((warn + 1))
  [ "$M3" -gt "$M3_WARN" ] && warn=$((warn + 1))
  [ "$M4" -gt "$M4_WARN" ] && warn=$((warn + 1))
  [ "$M5" -gt "$M5_WARN" ] && warn=$((warn + 1))
  [ "$M6" -gt "$M6_WARN" ] && warn=$((warn + 1))
  [ "$M7" -gt "$M7_WARN" ] && warn=$((warn + 1))
  if [ "$warn" -ge 2 ]; then
    echo "CRITICAL"
  elif [ "$warn" -ge 1 ]; then
    echo "WARNING"
  else
    echo "PASS"
  fi
}
VERDICT=$(verdict_session)

# --- Date + numero session ---
DATE=$(date +%Y-%m-%d)

# --- Creer le fichier perf-trends.md s'il n'existe pas ---
if [ ! -f "$PERF_FILE" ]; then
  mkdir -p "$(dirname "$PERF_FILE")"
  cat > "$PERF_FILE" <<'EOF'
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
EOF
fi

# --- Determiner numero de session (compte lignes existantes du tableau) ---
# Une ligne de mesure commence par "| 2"
EXISTING=$(grep -c "^| 2" "$PERF_FILE" 2>/dev/null || true)
EXISTING=$(echo "$EXISTING" | tr -d ' \n' | head -c 10)
[ -z "$EXISTING" ] && EXISTING=0
SESSION=$((EXISTING + 1))

# --- M2 affichage : valeur + commentaire si N/A ---
M2_DISPLAY="$M2"
if [ -n "$M2_NOTE" ]; then
  M2_DISPLAY="${M2} ${M2_NOTE}"
fi

# --- M7 affichage : "<max> <agent>" ou note N/A ---
if [ -n "$M7_NOTE" ]; then
  M7_DISPLAY="${M7} ${M7_NOTE}"
elif [ -n "$M7_AGENT" ]; then
  M7_DISPLAY="${M7} ${M7_AGENT}"
else
  M7_DISPLAY="${M7}"
fi

# --- Append la ligne ---
NEW_LINE="| ${DATE} | ${SESSION} | ${M1} | ${M2_DISPLAY} | ${M3} | ${M4} | ${M5} | ${M6} | ${M7_DISPLAY} | ${VERDICT} |"
echo "$NEW_LINE" >> "$PERF_FILE"

# --- Detection trend degradant : 3 dernieres lignes ---
# On lit les 3 dernieres lignes de mesure (commencant par "| 2")
TREND_DEGRADANT=0
LAST_THREE=$(grep "^| 2" "$PERF_FILE" | tail -n 3)
LAST_COUNT=$(echo "$LAST_THREE" | grep -c "^| 2" || true)

if [ "$LAST_COUNT" -ge 3 ]; then
  # Compter combien des 3 dernieres ont WARNING ou CRITICAL
  warn_sessions=0
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    if echo "$line" | grep -qE "WARNING|CRITICAL"; then
      warn_sessions=$((warn_sessions + 1))
    fi
  done <<TRENDEOF
$LAST_THREE
TRENDEOF
  if [ "$warn_sessions" -ge 3 ]; then
    TREND_DEGRADANT=1
  fi
fi

# --- Sortie console ---
echo "================================================"
echo "Perf-trend session #${SESSION} — ${DATE}"
echo "================================================"
echo "M1 (contexte commun)     : ${M1}    [cible <${M1_TARGET}, warn >${M1_WARN}]"
echo "M2 (memories)            : ${M2_DISPLAY}    [cible <${M2_TARGET}, warn >${M2_WARN}]"
echo "M3 (gates)               : ${M3}    [cible ${M3_TARGET_LO}-${M3_TARGET_HI}, warn >${M3_WARN}]"
echo "M4 (learnings actifs)    : ${M4}    [cible <${M4_TARGET}, warn >${M4_WARN}]"
echo "M5 (orchestrator.md)     : ${M5}    [cible <${M5_TARGET}, warn >${M5_WARN}]"
echo "M6 (fichiers docs/)      : ${M6}    [cible <${M6_TARGET}, warn >${M6_WARN}]"
echo "M7 (max invoc agent)     : ${M7_DISPLAY}    [cible <=${M7_TARGET}, warn >${M7_WARN}, crit >${M7_CRIT}]"
echo "------------------------------------------------"
echo "Verdict session : ${VERDICT}"
echo "Fichier         : ${PERF_FILE}"

# --- Alerte M7 sur-invocation ---
if [ "$M7" -gt "$M7_WARN" ] && [ -n "$M7_AGENT" ]; then
  echo ""
  echo "WARNING: agent ${M7_AGENT} invoque ${M7} fois - signal scope mal cadre, reality check Phase 0/1 recommande"
fi
echo "================================================"

if [ "$TREND_DEGRADANT" -eq 1 ]; then
  echo ""
  echo "WARNING TREND DEGRADANT — 3 sessions consecutives en WARNING/CRITICAL"
  echo "Action requise : audit profond avant de continuer la cloture."
  exit 1
fi

exit 0
