#!/usr/bin/env bash
# Gradient Agents — Framework Validation Script
# Vérifie la cohérence structurelle du framework sans exécuter les agents.
# Usage: bash tests/validate-framework.sh [chemin-racine] [--strict]
# --strict : transforme les avertissements en erreurs (utile en CI/CD)

set -euo pipefail

NEW_AGENT_FILE=""
ROOT="."
STRICT=false

# Parse arguments — positional and flags in any order
for arg in "$@"; do
  case "$arg" in
    --strict) STRICT=true ;;
    --new-agent=*) NEW_AGENT_FILE="${arg#--new-agent=}" ;;
    *) ROOT="$arg" ;;
  esac
done

AGENTS_DIR="$ROOT/.claude/agents"
CLAUDE_MD="$ROOT/CLAUDE.md"
ORCH="$AGENTS_DIR/orchestrator.md"
ERRORS=0
WARNINGS=0

red()    { printf "\033[31m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
green()  { printf "\033[32m%s\033[0m\n" "$1"; }

err()  { red  "[ERREUR] $1"; ERRORS=$((ERRORS + 1)); }
warn() {
  if $STRICT; then
    red "[ERREUR (strict)] $1"; ERRORS=$((ERRORS + 1))
  else
    yellow "[AVERTISSEMENT] $1"; WARNINGS=$((WARNINGS + 1))
  fi
}
ok()   { green "[OK] $1"; }

echo "=== Validation du framework Gradient Agents ==="
echo "Racine: $ROOT"
$STRICT && echo "Mode: STRICT (warnings = erreurs)"
echo ""

# 1. Fichiers critiques
echo "--- Fichiers critiques ---"
for f in "$CLAUDE_MD" "$AGENTS_DIR/_base-agent-protocol.md" "$AGENTS_DIR/orchestrator.md" "$AGENTS_DIR/agent-factory.md" "$ROOT/templates/project-context.md"; do
  if [ -f "$f" ]; then
    ok "$(basename "$f") existe"
  else
    err "$(basename "$f") manquant"
  fi
done

# 2. Validation des agents (frontmatter + sections obligatoires)
echo ""
echo "--- Validation des agents ---"
AGENT_COUNT=0
for agent in "$AGENTS_DIR"/*.md; do
  basename_agent=$(basename "$agent")
  case "$basename_agent" in _*) continue ;; esac

  AGENT_COUNT=$((AGENT_COUNT + 1))
  name=$(basename "$agent" .md)

  # Frontmatter check
  if ! head -1 "$agent" | grep -q "^---$"; then
    err "$basename_agent: pas de frontmatter YAML"
    continue
  fi

  # name field + kebab-case validation
  if ! grep -q "^name:" "$agent"; then
    err "$basename_agent: champ 'name' manquant dans le frontmatter"
  else
    YAML_NAME=$(grep "^name:" "$agent" | head -1 | sed 's/^name: *//')
    if ! echo "$YAML_NAME" | grep -qP '^[a-z][a-z0-9-]*$'; then
      err "$basename_agent: name '$YAML_NAME' n'est pas en kebab-case"
    fi
    if [ "$YAML_NAME" != "$name" ]; then
      err "$basename_agent: name YAML '$YAML_NAME' != nom fichier '$name'"
    fi
  fi

  # description field + length check
  if ! grep -q "^description:" "$agent"; then
    err "$basename_agent: champ 'description' manquant"
  else
    DESC_LEN=$(grep "^description:" "$agent" | head -1 | sed 's/^description: *//' | tr -d '"' | wc -c)
    if [ "$DESC_LEN" -gt 121 ]; then
      warn "$basename_agent: description trop longue ($DESC_LEN chars, max 120)"
    fi
  fi

  # model field + valid value check
  if ! grep -q "^model:" "$agent"; then
    err "$basename_agent: champ 'model' manquant"
  else
    MODEL_VAL=$(grep "^model:" "$agent" | head -1 | awk '{print $2}')
    case "$MODEL_VAL" in
      claude-opus-4-8|claude-sonnet-4-6|claude-haiku-4-5-20251001) ;;
      *) err "$basename_agent: modèle invalide '$MODEL_VAL'" ;;
    esac
  fi

  # tools field
  if ! grep -q "^tools:" "$agent"; then
    err "$basename_agent: champ 'tools' manquant"
  else
    # Validation des tools valides
    VALID_TOOLS="Read Write Edit Bash Glob Grep WebSearch WebFetch Task"
    TOOLS_LINE=$(grep "^tools:" "$agent" | head -1 | sed 's/^tools: *//')
    for tool in $(echo "$TOOLS_LINE" | tr -d '[],' | tr ' ' '\n' | sed 's/^ *//;s/ *$//'); do
      [ -z "$tool" ] && continue
      TOOL_VALID=false
      for valid in $VALID_TOOLS; do
        if [ "$tool" = "$valid" ]; then
          TOOL_VALID=true
          break
        fi
      done
      if ! $TOOL_VALID; then
        warn "$basename_agent: tool inconnu '$tool' (valides: $VALID_TOOLS)"
      fi
    done
  fi

  # version field
  if ! grep -q "^version:" "$agent"; then
    warn "$basename_agent: champ 'version' manquant dans le frontmatter"
  else
    VERSION_VAL=$(grep "^version:" "$agent" | head -1 | sed 's/^version: *//' | tr -d ' ')
    if ! echo "$VERSION_VAL" | grep -qP '^"[0-9]+\.[0-9]+"$'; then
      warn "$basename_agent: version '$VERSION_VAL' ne suit pas le format \"X.Y\""
    fi
  fi

  # === Sections obligatoires (alignées avec checklist agent-factory étape 5) ===

  if ! grep -q "## Identité" "$agent"; then
    err "$basename_agent: section '## Identité' manquante"
  fi

  if ! grep -q "project-context.md\|_base-agent-protocol.md" "$agent"; then
    err "$basename_agent: pas de référence à project-context.md ni au protocole standard"
  fi

  # Champs critiques définis
  if ! grep -qi "Champs critiques" "$agent"; then
    warn "$basename_agent: pas de 'Champs critiques' définis"
  fi

  # Calibration section
  if ! grep -qi "calibration\|Étape 1.*Initialisation" "$agent"; then
    warn "$basename_agent: pas de section Calibration détectée"
  fi

  # Protocole d'escalade / anti-invention
  if ! grep -qi "Règle n°2\|anti-invention\|JAMAIS inventer\|escalade" "$agent"; then
    warn "$basename_agent: pas de référence à la règle anti-invention / escalade"
  fi

  # Auto-évaluation: at least 5 checkbox questions
  CHECKBOX_COUNT=$(grep -c "^□" "$agent" 2>/dev/null || echo 0)
  if [ "$CHECKBOX_COUNT" -lt 5 ]; then
    warn "$basename_agent: seulement $CHECKBOX_COUNT questions d'auto-évaluation (minimum 5)"
  fi

  # Livrables types
  if ! grep -qi "Livrables types\|Livrables" "$agent"; then
    warn "$basename_agent: pas de section Livrables types"
  fi

  # Handoff
  if ! grep -q "Handoff" "$agent"; then
    warn "$basename_agent: pas de section Handoff détectée"
  fi

  # Cohérence tools déclarés vs tools référencés dans les instructions
  # Extraire les tools déclarés (format YAML list: "  - ToolName")
  DECLARED_TOOLS=$(sed -n '/^tools:/,/^[^ -]/p' "$agent" | grep "^  - " | sed 's/^  - //' | tr '\n' ' ')
  # Vérifier si l'agent référence des tools qu'il n'a pas
  for check_tool in Grep Bash WebSearch WebFetch; do
    # Chercher des références au tool dans le corps (après le frontmatter), en excluant les blocs de code et commentaires
    BODY_REF=$(sed -n '/^---$/,/^---$/!p' "$agent" | grep -i "\b$check_tool\b" 2>/dev/null | grep -v "^#\|^\`\`\`\|INSTRUCTION\|template\|Exemple\|example\|Ex :\|n'a pas\|pas de\|De quels tools\|tools nécessaires\|tools Claude Code\|utilise.*les cas\|sont-ils\|a-t-il besoin" | head -1 || true)
    if [ -n "$BODY_REF" ] && ! echo "$DECLARED_TOOLS" | grep -q "$check_tool"; then
      warn "$basename_agent: référence '$check_tool' dans ses instructions mais ne le déclare pas dans ses tools"
    fi
  done

done

ok "$AGENT_COUNT agents trouvés"

# 3. Cohérence CLAUDE.md <-> agents (bidirectionnelle)
echo ""
echo "--- Cohérence CLAUDE.md <-> agents ---"

# 3a. Chaque agent doit être dans CLAUDE.md
for agent in "$AGENTS_DIR"/*.md; do
  basename_agent=$(basename "$agent" .md)
  case "$basename_agent" in _*) continue ;; esac
  if ! grep -q "@$basename_agent" "$CLAUDE_MD"; then
    err "@$basename_agent absent de CLAUDE.md"
  fi
done

# 3b. Chaque @agent dans CLAUDE.md convention d'appel doit avoir un fichier
while IFS= read -r line; do
  agent_name=$(echo "$line" | grep -oP '`@([a-z-]+)`' | tr -d '`@' | head -1)
  if [ -n "$agent_name" ] && [ ! -f "$AGENTS_DIR/$agent_name.md" ]; then
    err "@$agent_name référencé dans CLAUDE.md mais fichier agent manquant"
  fi
done < <(grep "^- \`@" "$CLAUDE_MD" 2>/dev/null || true)

# 4. Vérification des emojis
echo ""
echo "--- Vérification emojis ---"
EMOJI_COUNT=$(grep -rlP '[\x{26A0}\x{26D4}\x{1F534}\x{1F7E1}\x{1F7E2}\x{1F4CB}\x{1F3AF}\x{1F4A1}\x{1F680}\x{1F4CA}\x{1F50D}\x{2705}\x{274C}]' "$AGENTS_DIR"/*.md 2>/dev/null | wc -l || true)
EMOJI_COUNT=${EMOJI_COUNT:-0}
if [ "$EMOJI_COUNT" -gt 0 ]; then
  warn "$EMOJI_COUNT fichiers avec emojis détectés dans les agents"
else
  ok "Aucun emoji détecté dans les agents"
fi

# 5. Vérification template project-context.md
echo ""
echo "--- Template project-context.md ---"
TEMPLATE="$ROOT/templates/project-context.md"
if [ -f "$TEMPLATE" ]; then
  for section in "Identité" "Cible" "Positionnement" "Objectifs" "Stack technique" "Modèle économique" "Contraintes" "Historique des interventions" "Performance des agents" "Existant"; do
    if grep -q "$section" "$TEMPLATE"; then
      ok "Section '$section' présente"
    else
      err "Section '$section' manquante dans le template"
    fi
  done
fi

# 6. Vérification orchestrator.md — mapping subagent_type
echo ""
echo "--- Mapping orchestrator ---"
if [ -f "$ORCH" ]; then
  for agent in "$AGENTS_DIR"/*.md; do
    basename_agent=$(basename "$agent" .md)
    case "$basename_agent" in _*) continue ;; esac
    [ "$basename_agent" = "orchestrator" ] && continue
    if ! grep -q "$basename_agent" "$ORCH"; then
      warn "@$basename_agent non référencé dans orchestrator.md"
    fi
  done
fi

# 7. Vérification des références croisées
echo ""
echo "--- Références croisées ---"
for agent in "$AGENTS_DIR"/*.md; do
  basename_agent=$(basename "$agent" .md)
  case "$basename_agent" in _*) continue ;; esac

  # Vérifier que l'agent a un chemin livrable dans la convention (_base-agent-protocol.md depuis la cure S4)
  BASE_PROTO="$AGENTS_DIR/_base-agent-protocol.md"
  if [ -f "$BASE_PROTO" ] && ! grep -q "@$basename_agent" "$BASE_PROTO" 2>/dev/null; then
    case "$basename_agent" in
      agent-factory|orchestrator|fullstack) ;;
      *) warn "$basename_agent: pas de chemin livrable dans _base-agent-protocol.md (convention de chemin)" ;;
    esac
  fi

  # Check handoff targets exist (skip examples in code blocks and known non-agent patterns)
  HANDOFF_TARGETS=$(grep -v '^\s*#\|^\s*```\|Exemple\|example\|Ex :' "$agent" 2>/dev/null | grep -oP '@([a-z-]+)' | sort -u | tr -d '@' || true)
  for target in $HANDOFF_TARGETS; do
    # Skip self, orchestrator, utilisateur, and known library/tool names
    case "$target" in
      "$basename_agent"|orchestrator|utilisateur|playwright|testing-library|vercel|supabase|shadcn|tailwind|nextjs|react|expo|cloudflare|next|anthropic-ai|v) continue ;;
    esac
    if [ ! -f "$AGENTS_DIR/$target.md" ] && ! grep -q "@$target" "$CLAUDE_MD" 2>/dev/null; then
      warn "$basename_agent: référence @$target mais l'agent n'existe pas"
    fi
  done
done

# 8. Cohérence des comptes (un fait = un endroit — SOT : ls agents / _gates.md / index.html)
# Exécuté uniquement sur le repo framework (index.html présent), pas sur les projets clients.
if [ -f "$ROOT/index.html" ] && grep -q "Gradient Agents" "$ROOT/index.html" 2>/dev/null; then
  echo ""
  echo "--- Cohérence des comptes (anti-drift) ---"

  # SOT agents = nombre de fichiers (hors _*)
  for f in "$CLAUDE_MD" "$ROOT/project-context.md" "$ROOT/index.html" "$ROOT/INSTALL.md"; do
    [ -f "$f" ] || continue
    STALE_AGENTS=$(grep -oE "(19|21) agents" "$f" 2>/dev/null | head -1 || true)
    if [ -n "$STALE_AGENTS" ]; then
      err "$(basename "$f"): '$STALE_AGENTS' alors que le repo contient $AGENT_COUNT agents (SOT: ls .claude/agents)"
    fi
  done

  # SOT gates = _gates.md (lignes "| G..." + G_PROOF en gras). Historique de project-context exclu (mentions légitimes).
  if [ -f "$AGENTS_DIR/_gates.md" ]; then
    GATES_COUNT=$(grep -cE '^\| \*{0,2}G' "$AGENTS_DIR/_gates.md" || true)
    for f in "$CLAUDE_MD" "$AGENTS_DIR/_base-agent-protocol.md" "$AGENTS_DIR/reviewer.md" "$ORCH"; do
      [ -f "$f" ] || continue
      if grep -qE "32 gates|G1-G32|25 gates" "$f" 2>/dev/null; then
        err "$(basename "$f"): référence un ancien compte de gates (SOT: _gates.md = $GATES_COUNT gates)"
      fi
    done
  fi

  # SOT prompts = index.html (un prompt = un champ "prompt:\`"). Comparaison NUMÉRIQUE dynamique
  # (pas de valeurs périmées codées en dur). Historique de project-context exclu.
  PROMPT_COUNT=$(grep -c 'prompt:`' "$ROOT/index.html" || true)
  for f in "$ORCH" "$ROOT/README.md" "$ROOT/INSTALL.md"; do
    [ -f "$f" ] || continue
    MENTIONED=$(grep -oE "[0-9]+ prompts" "$f" 2>/dev/null | head -1 | grep -oE "^[0-9]+" || true)
    if [ -n "$MENTIONED" ] && [ "$MENTIONED" != "$PROMPT_COUNT" ]; then
      err "$(basename "$f"): mentionne '$MENTIONED prompts' alors que index.html en contient $PROMPT_COUNT"
    fi
  done
  ANNOUNCED=$(grep -oE "[0-9]+ prompts" "$ROOT/index.html" | head -1 | grep -oE "^[0-9]+" || true)
  if [ -n "$ANNOUNCED" ] && [ "$ANNOUNCED" != "$PROMPT_COUNT" ]; then
    err "index.html annonce '$ANNOUNCED prompts' mais en contient $PROMPT_COUNT"
  fi

  # Références mortes post-cure S4 dans les fichiers ACTIFS (docs/reviews et archives exclus)
  DEAD_REFS=$(grep -rlE "@moi[^t-]|REPLIT_ACTIONS|orchestrator-reference" "$AGENTS_DIR" "$CLAUDE_MD" "$ROOT/docs/founder-preferences.md" 2>/dev/null || true)
  if [ -n "$DEAD_REFS" ]; then
    for df in $DEAD_REFS; do
      err "$(basename "$df"): référence morte post-cure S4 (@moi / REPLIT_ACTIONS / orchestrator-reference)"
    done
  else
    ok "0 référence morte post-cure (agents + CLAUDE.md + founder-preferences)"
  fi

  ok "Comptes vérifiés : $AGENT_COUNT agents, $GATES_COUNT gates (_gates.md), $PROMPT_COUNT prompts (index.html)"
fi

# 9. Fichiers support
echo ""
echo "--- Fichiers support ---"
for f in "$ROOT/INSTALL.md" "$ROOT/CHANGELOG.md" "$ROOT/docs/lessons-learned.md"; do
  if [ -f "$f" ]; then
    ok "$(basename "$f") existe"
  else
    warn "$(basename "$f") manquant"
  fi
done

# Résumé
echo ""
echo "=== Résumé ==="
if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
  green "Tout est OK. 0 erreurs, 0 avertissements."
elif [ "$ERRORS" -eq 0 ]; then
  yellow "$WARNINGS avertissement(s), 0 erreur."
else
  red "$ERRORS erreur(s), $WARNINGS avertissement(s)."
fi

# 9. Mode --new-agent : validation spécifique d'un nouvel agent
if [ -n "$NEW_AGENT_FILE" ]; then
  echo ""
  echo "=== Validation nouvel agent : $NEW_AGENT_FILE ==="
  NA_CHECKS=0
  NA_WARNINGS=0
  NA_ERRORS=0

  if [ ! -f "$NEW_AGENT_FILE" ]; then
    red "Fichier $NEW_AGENT_FILE introuvable."
    exit 1
  fi

  NA_NAME=$(basename "$NEW_AGENT_FILE" .md)

  # Vérification référence dans CLAUDE.md
  if grep -q "@$NA_NAME" "$CLAUDE_MD" 2>/dev/null; then
    green "[OK] @$NA_NAME référencé dans CLAUDE.md"
    NA_CHECKS=$((NA_CHECKS + 1))
  else
    red "[ERREUR] @$NA_NAME non référencé dans CLAUDE.md (convention d'appel)"
    NA_ERRORS=$((NA_ERRORS + 1))
    ERRORS=$((ERRORS + 1))
  fi

  # Vérification référence dans orchestrator.md
  if [ -f "$ORCH" ] && grep -q "$NA_NAME" "$ORCH" 2>/dev/null; then
    green "[OK] $NA_NAME référencé dans orchestrator.md"
    NA_CHECKS=$((NA_CHECKS + 1))
  else
    red "[ERREUR] $NA_NAME non référencé dans orchestrator.md (mapping)"
    NA_ERRORS=$((NA_ERRORS + 1))
    ERRORS=$((ERRORS + 1))
  fi

  echo ""
  echo "Nouvel agent : $NA_NAME — $NA_CHECKS checks passed, $NA_WARNINGS warnings, $NA_ERRORS errors"
fi

exit "$ERRORS"
