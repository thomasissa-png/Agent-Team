#!/usr/bin/env bash
set -euo pipefail

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# gradient-agents — Script de mise à jour
# Usage : bash update.sh [--all]
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

REPO_URL="https://github.com/[USERNAME]/gradient-agents"
AGENTS_DIR=".claude/agents"
TEMP_DIR=$(mktemp -d)
UPDATE_ALL=false

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

cleanup() { rm -rf "$TEMP_DIR"; }
trap cleanup EXIT

if [[ "${1:-}" == "--all" ]]; then
  UPDATE_ALL=true
fi

if [ ! -d "$AGENTS_DIR" ]; then
  echo -e "${YELLOW}Aucun agent installé. Lance install.sh d'abord.${NC}"
  exit 1
fi

echo -e "${BOLD}gradient-agents — Mise à jour${NC}"
echo ""
echo -e "${BLUE}→ Récupération des dernières versions...${NC}"

cd "$TEMP_DIR"
git clone --filter=blob:none --sparse --quiet "$REPO_URL" repo
cd repo
git sparse-checkout set .claude/agents

updated=0
skipped=0

for remote_agent in "$TEMP_DIR/repo/.claude/agents"/*.md; do
  agent_name=$(basename "$remote_agent")
  local_agent="$OLDPWD/$AGENTS_DIR/$agent_name"

  if [ ! -f "$local_agent" ]; then
    cp "$remote_agent" "$local_agent"
    echo -e "  ${GREEN}+ Nouvel agent installé : ${agent_name}${NC}"
    ((updated++))
    continue
  fi

  remote_hash=$(md5sum "$remote_agent" | cut -d' ' -f1)
  local_hash=$(md5sum "$local_agent" | cut -d' ' -f1)

  if [ "$remote_hash" == "$local_hash" ]; then
    ((skipped++))
    continue
  fi

  if [ "$UPDATE_ALL" = true ]; then
    cp "$remote_agent" "$local_agent"
    echo -e "  ${GREEN}✓ Mis à jour : ${agent_name}${NC}"
    ((updated++))
  else
    echo -e "  ${YELLOW}↑ Mise à jour disponible : ${agent_name}${NC}"
    read -r -p "    Mettre à jour ? [o/N] " response
    if [[ "$response" =~ ^[oO]$ ]]; then
      cp "$remote_agent" "$local_agent"
      echo -e "    ${GREEN}✓ Mis à jour${NC}"
      ((updated++))
    fi
  fi
done

echo ""
echo -e "${BOLD}Résumé : ${updated} mis à jour, ${skipped} déjà à jour${NC}"
echo -e "${YELLOW}Note : project-context.md n'est jamais écrasé lors des mises à jour.${NC}"
