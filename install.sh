#!/usr/bin/env bash
set -euo pipefail

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# gradient-agents — Script d'installation
# Usage : curl -fsSL https://raw.githubusercontent.com/[USERNAME]/gradient-agents/main/install.sh | bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

VERSION="3.0.0"
REPO_URL="https://github.com/[USERNAME]/gradient-agents"
RAW_URL="https://raw.githubusercontent.com/[USERNAME]/gradient-agents/main"
AGENTS_DIR=".claude/agents"
TEMPLATES_DIR="templates"
TEMP_DIR=$(mktemp -d)

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

print_header() {
  echo ""
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}  gradient-agents v${VERSION}${NC}"
  echo -e "${BOLD}  Librairie d'agents Claude Code — Gradient One${NC}"
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

check_requirements() {
  if ! command -v git &> /dev/null; then
    echo -e "${RED}✗ git est requis mais non installé.${NC}"
    exit 1
  fi
  if ! command -v curl &> /dev/null; then
    echo -e "${RED}✗ curl est requis mais non installé.${NC}"
    exit 1
  fi
  echo -e "${GREEN}✓ Prérequis vérifiés${NC}"
}

check_existing_agents() {
  if [ -d "$AGENTS_DIR" ] && [ "$(ls -A $AGENTS_DIR 2>/dev/null)" ]; then
    echo -e "${YELLOW}⚠ Des agents existent déjà dans ${AGENTS_DIR}/${NC}"
    echo -e "  Agents existants : $(ls $AGENTS_DIR/*.md 2>/dev/null | wc -l | tr -d ' ') fichier(s)"
    echo ""
    read -r -p "  Écraser avec la version du repo ? [o/N] " response
    if [[ ! "$response" =~ ^[oO]$ ]]; then
      echo -e "${YELLOW}  Installation annulée. Utilise update.sh pour une mise à jour sélective.${NC}"
      exit 0
    fi
  fi
}

clone_repo_sparse() {
  echo -e "${BLUE}→ Téléchargement des agents...${NC}"
  cd "$TEMP_DIR"
  git clone --filter=blob:none --sparse --quiet "$REPO_URL" repo
  cd repo
  git sparse-checkout set .claude/agents templates CLAUDE.md
  echo -e "${GREEN}✓ Agents téléchargés${NC}"
}

install_agents() {
  echo -e "${BLUE}→ Installation des agents...${NC}"
  mkdir -p "$OLDPWD/$AGENTS_DIR"
  cp -r "$TEMP_DIR/repo/.claude/agents/." "$OLDPWD/$AGENTS_DIR/"
  echo -e "${GREEN}✓ Agents installés dans ${AGENTS_DIR}/${NC}"
}

install_claude_md() {
  if [ -f "$TEMP_DIR/repo/CLAUDE.md" ]; then
    if [ -f "$OLDPWD/CLAUDE.md" ]; then
      echo -e "${YELLOW}⚠ CLAUDE.md existe déjà à la racine — non écrasé.${NC}"
      echo -e "  Consulte ${TEMP_DIR}/repo/CLAUDE.md pour voir la version recommandée."
    else
      cp "$TEMP_DIR/repo/CLAUDE.md" "$OLDPWD/CLAUDE.md"
      echo -e "${GREEN}✓ CLAUDE.md installé${NC}"
    fi
  fi
}

install_project_context() {
  if [ ! -f "$OLDPWD/project-context.md" ]; then
    if [ -f "$TEMP_DIR/repo/templates/project-context.md" ]; then
      cp "$TEMP_DIR/repo/templates/project-context.md" "$OLDPWD/project-context.md"
      echo -e "${GREEN}✓ project-context.md créé à la racine — à remplir avant d'utiliser les agents${NC}"
    fi
  else
    echo -e "${YELLOW}⚠ project-context.md existe déjà — non écrasé${NC}"
  fi
}

print_summary() {
  echo ""
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}  Agents installés :${NC}"
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

  for agent_file in "$OLDPWD/$AGENTS_DIR"/*.md; do
    agent_name=$(basename "$agent_file" .md)
    description=$(grep -m1 "^description:" "$agent_file" 2>/dev/null | sed 's/description: *//;s/^"//;s/"$//' || echo "—")
    printf "  ${GREEN}%-20s${NC} %s\n" "@$agent_name" "$description"
  done

  echo ""
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}  Démarrage rapide :${NC}"
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "  ${YELLOW}1.${NC} Remplis ${BOLD}project-context.md${NC} à la racine du projet"
  echo -e "  ${YELLOW}2.${NC} Dans Claude Code, tape : ${BOLD}@orchestrator lance le projet${NC}"
  echo -e "  ${YELLOW}3.${NC} Pour un agent seul : ${BOLD}@design crée le design system${NC}"
  echo ""
  echo -e "  Mise à jour : ${BOLD}bash update.sh${NC}"
  echo -e "  Documentation : ${BOLD}${REPO_URL}${NC}"
  echo ""
}

# ─── Exécution ───────────────────────────────────────
print_header
check_requirements
check_existing_agents
clone_repo_sparse
install_agents
install_claude_md
install_project_context
print_summary
