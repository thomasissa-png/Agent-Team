#!/usr/bin/env bash
# Gradient Agents — Framework Validation Script
# Vérifie la cohérence structurelle du framework sans exécuter les agents.
# Usage: bash tests/validate-framework.sh [chemin-racine]

set -euo pipefail

ROOT="${1:-.}"
AGENTS_DIR="$ROOT/.claude/agents"
CLAUDE_MD="$ROOT/CLAUDE.md"
ERRORS=0
WARNINGS=0

red()    { printf "\033[31m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
green()  { printf "\033[32m%s\033[0m\n" "$1"; }

err()  { red  "[ERREUR] $1"; ERRORS=$((ERRORS + 1)); }
warn() { yellow "[AVERTISSEMENT] $1"; WARNINGS=$((WARNINGS + 1)); }
ok()   { green "[OK] $1"; }

echo "=== Validation du framework Gradient Agents ==="
echo "Racine: $ROOT"
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

# 2. Validation des agents (frontmatter YAML)
echo ""
echo "--- Validation des agents ---"
AGENT_COUNT=0
for agent in "$AGENTS_DIR"/*.md; do
  basename_agent=$(basename "$agent")
  # Skip base protocol
  [ "$basename_agent" = "_base-agent-protocol.md" ] && continue

  AGENT_COUNT=$((AGENT_COUNT + 1))
  name=$(basename "$agent" .md)

  # Frontmatter check
  if ! head -1 "$agent" | grep -q "^---$"; then
    err "$basename_agent: pas de frontmatter YAML"
    continue
  fi

  # name field
  if ! grep -q "^name:" "$agent"; then
    err "$basename_agent: champ 'name' manquant dans le frontmatter"
  fi

  # description field
  if ! grep -q "^description:" "$agent"; then
    err "$basename_agent: champ 'description' manquant"
  fi

  # model field
  if ! grep -q "^model:" "$agent"; then
    err "$basename_agent: champ 'model' manquant"
  fi

  # tools field
  if ! grep -q "^tools:" "$agent"; then
    err "$basename_agent: champ 'tools' manquant"
  fi

  # Section checks
  if ! grep -q "## Identité" "$agent"; then
    err "$basename_agent: section '## Identité' manquante"
  fi

  if ! grep -q "project-context.md" "$agent"; then
    err "$basename_agent: pas de référence à project-context.md"
  fi

  if ! grep -q "Handoff" "$agent"; then
    warn "$basename_agent: pas de section Handoff détectée"
  fi

  # Anti-invention reference
  if ! grep -q "Règle n°2\|anti-invention\|JAMAIS inventer" "$agent"; then
    warn "$basename_agent: pas de référence explicite à la règle anti-invention"
  fi

  # Anti-timeout reference
  if ! grep -q "Règle n°3\|anti-timeout\|timeout" "$agent"; then
    warn "$basename_agent: pas de référence aux règles anti-timeout"
  fi
done

ok "$AGENT_COUNT agents trouvés"

# 3. Vérification CLAUDE.md — convention d'appel
echo ""
echo "--- Cohérence CLAUDE.md <-> agents ---"
for agent in "$AGENTS_DIR"/*.md; do
  basename_agent=$(basename "$agent" .md)
  [ "$basename_agent" = "_base-agent-protocol" ] && continue

  if ! grep -q "@$basename_agent" "$CLAUDE_MD"; then
    err "@$basename_agent absent de la convention d'appel dans CLAUDE.md"
  fi
done

# 4. Vérification des emojis (sauf dans les commentaires et exemples)
echo ""
echo "--- Vérification emojis ---"
EMOJI_COUNT=$(grep -rlP '[\x{26A0}\x{26D4}\x{1F534}\x{1F7E1}\x{1F7E2}\x{1F4CB}\x{1F3AF}\x{1F4A1}\x{1F680}\x{1F4CA}\x{1F50D}\x{2705}\x{274C}]' "$AGENTS_DIR"/*.md 2>/dev/null | wc -l || true)
EMOJI_COUNT=${EMOJI_COUNT:-0}
if [ "$EMOJI_COUNT" -gt 0 ]; then
  warn "$EMOJI_COUNT lignes avec emojis détectées dans les agents"
else
  ok "Aucun emoji détecté dans les agents"
fi

# 5. Vérification template project-context.md — sections critiques
echo ""
echo "--- Template project-context.md ---"
TEMPLATE="$ROOT/templates/project-context.md"
if [ -f "$TEMPLATE" ]; then
  for section in "Identité" "Cible" "Positionnement" "Objectifs" "Stack technique" "Modèle économique" "Contraintes" "Historique des interventions" "Performance des agents"; do
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
ORCH="$AGENTS_DIR/orchestrator.md"
if [ -f "$ORCH" ]; then
  for agent in "$AGENTS_DIR"/*.md; do
    basename_agent=$(basename "$agent" .md)
    [ "$basename_agent" = "_base-agent-protocol" ] && continue
    [ "$basename_agent" = "orchestrator" ] && continue

    if ! grep -q "$basename_agent" "$ORCH"; then
      warn "@$basename_agent non référencé dans orchestrator.md"
    fi
  done
fi

# 7. Vérification des références croisées (calibration amont/aval)
echo ""
echo "--- Références croisées ---"
for agent in "$AGENTS_DIR"/*.md; do
  basename_agent=$(basename "$agent" .md)
  [ "$basename_agent" = "_base-agent-protocol" ] && continue

  # Check if agent references docs/ files that should exist in their livrable path
  LIVRABLE_DIR=$(grep -o 'docs/[a-z-]*/' "$agent" 2>/dev/null | head -1 || true)
  if [ -n "$LIVRABLE_DIR" ]; then
    ok "$basename_agent: chemin livrable défini ($LIVRABLE_DIR)"
  fi
done

# 8. Vérification YAML frontmatter — name matches filename
echo ""
echo "--- Cohérence nom fichier / frontmatter ---"
for agent in "$AGENTS_DIR"/*.md; do
  basename_agent=$(basename "$agent" .md)
  [ "$basename_agent" = "_base-agent-protocol" ] && continue

  YAML_NAME=$(grep "^name:" "$agent" 2>/dev/null | head -1 | sed 's/^name: *//' || true)
  if [ -n "$YAML_NAME" ] && [ "$YAML_NAME" != "$basename_agent" ]; then
    err "$basename_agent: le name YAML '$YAML_NAME' ne correspond pas au nom de fichier"
  fi
done

# 9. Vérification fichiers support
echo ""
echo "--- Fichiers support ---"
for f in "$ROOT/INSTALL.md" "$ROOT/CHANGELOG.md"; do
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

exit "$ERRORS"
