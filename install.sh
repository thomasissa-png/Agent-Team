#!/usr/bin/env bash
set -euo pipefail

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# gradient-agents — Script d'installation
# Usage : curl -fsSL https://raw.githubusercontent.com/thomasissa-png/Agent-Team/main/install.sh | bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

VERSION="3.2.0"
REPO_URL="https://github.com/thomasissa-png/Agent-Team"
RAW_URL="https://raw.githubusercontent.com/thomasissa-png/Agent-Team/main"
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

# ─── Fonctions partagées install/update : ne jamais écraser un réglage propre au projet ───

# Fusionne le settings.json Gradient dans celui du projet : les clés du projet
# (hooks, env, permissions...) sont conservées, les permissions Gradient ajoutées.
# $1 = settings.json Gradient, $2 = settings.json du projet, $3 = dossier de sauvegarde
merge_settings_json() {
  local src="$1" dst="$2" bak="$3"
  mkdir -p "$(dirname "$dst")"
  if [ ! -f "$dst" ]; then
    cp "$src" "$dst"
    echo -e "  ${GREEN}✓ .claude/settings.json installé${NC}"
    return 0
  fi
  if cmp -s "$src" "$dst"; then
    echo -e "  ${BLUE}= .claude/settings.json déjà à jour${NC}"
    return 0
  fi
  mkdir -p "$bak" && cp "$dst" "$bak/settings.json" && printf '*\n' > "$bak/.gitignore"
  if command -v node >/dev/null 2>&1 && node -e '
const fs=require("fs");const [s,d]=process.argv.slice(1);
const G=JSON.parse(fs.readFileSync(s,"utf8")),P=JSON.parse(fs.readFileSync(d,"utf8"));
const out={...G,...P},gp=G.permissions||{},pp=P.permissions||{};
out.permissions={...gp,...pp};
for(const k of ["allow","deny","ask"]){const u=[...new Set([...(pp[k]||[]),...(gp[k]||[])])];if(u.length)out.permissions[k]=u;}
fs.writeFileSync(d,JSON.stringify(out,null,2)+"\n");' "$src" "$dst" 2>/dev/null; then
    echo -e "  ${GREEN}✓ .claude/settings.json fusionné (réglages du projet conservés, permissions Gradient ajoutées ; sauvegarde : ${bak}/settings.json)${NC}"
  elif command -v python3 >/dev/null 2>&1 && python3 - "$src" "$dst" 2>/dev/null <<'PY'
import json, sys
s, d = sys.argv[1:3]
G = json.load(open(s, encoding="utf-8")); P = json.load(open(d, encoding="utf-8"))
out = {**G, **P}; gp = G.get("permissions", {}); pp = P.get("permissions", {})
out["permissions"] = {**gp, **pp}
for k in ("allow", "deny", "ask"):
    u = list(dict.fromkeys(pp.get(k, []) + gp.get(k, [])))
    if u: out["permissions"][k] = u
with open(d, "w", encoding="utf-8") as f:
    json.dump(out, f, indent=2, ensure_ascii=False); f.write("\n")
PY
  then
    echo -e "  ${GREEN}✓ .claude/settings.json fusionné (réglages du projet conservés, permissions Gradient ajoutées ; sauvegarde : ${bak}/settings.json)${NC}"
  else
    cp "$src" "$(dirname "$dst")/settings.gradient.json"
    echo -e "  ${YELLOW}⚠ Fusion de settings.json impossible (node/python absents ou JSON invalide) : le vôtre est conservé tel quel, la version Gradient est dans .claude/settings.gradient.json (à fusionner à la main)${NC}"
  fi
}

# Tampon de version : quelle version du framework tourne dans ce projet
write_gradient_version() {  # $1 = racine du projet, $2 = branche source
  local commit date
  commit=$(cd "$TEMP_DIR/repo" && git rev-parse --short HEAD 2>/dev/null || echo inconnu)
  date=$(cd "$TEMP_DIR/repo" && git log -1 --format=%cI 2>/dev/null || echo inconnue)
  mkdir -p "$1/.claude"
  printf 'branche: %s\ncommit: %s\ndate: %s\nsource: %s\n' "$2" "$commit" "$date" "$REPO_URL" > "$1/.claude/gradient-version"
  echo -e "  ${GREEN}✓ .claude/gradient-version : ${2}@${commit}${NC}"
  return 0
}

# Ajoute au .gitignore du projet les fichiers techniques du framework (sauvegardes)
ensure_gitignore() {
  local gi="$1/.gitignore" line
  [ -f "$gi" ] || return 0
  for line in ".claude/gradient-backup/" ".claude/settings.gradient.json"; do
    grep -qxF "$line" "$gi" || printf '%s\n' "$line" >> "$gi"
  done
  return 0
}

# Toutes les versions qu'un fichier a eues dans le repo Gradient (identifiants git,
# sans télécharger les contenus). Vide = ce fichier n'a jamais appartenu à Gradient.
gradient_history_blobs() {
  (cd "$TEMP_DIR/repo" && git log --all --format=%H -- "$1" 2>/dev/null \
    | while read -r c; do git rev-parse -q --verify "$c:$1" 2>/dev/null || true; done) | sort -u
}

# Ancien pre-commit Gradient : reconnu seulement s'il est IDENTIQUE, octet pour octet,
# à une version passée du fichier dans le repo Gradient. Toute modification = hook du projet.
is_legacy_gradient_hook() {
  local h
  h=$(git hash-object "$1" 2>/dev/null) || return 1
  gradient_history_blobs ".githooks/pre-commit" | grep -qx "$h"
}

# Installe le garde-fou CLAUDE.md sans jamais écraser un hook propre au projet
# ni désactiver Husky / .git/hooks. $1 = repo Gradient, $2 = racine du projet
sync_githooks() {
  local src="$1" dst="$2" hook="$2/.githooks/pre-commit"
  [ -d "$src/.githooks" ] || return 0
  mkdir -p "$dst/.githooks"
  if [ -f "$src/.githooks/claude-md-guard.sh" ]; then
    cp "$src/.githooks/claude-md-guard.sh" "$dst/.githooks/claude-md-guard.sh"
    chmod +x "$dst/.githooks/claude-md-guard.sh"
  fi
  if [ ! -f "$hook" ] || grep -q "GRADIENT-HOOK" "$hook" || is_legacy_gradient_hook "$hook"; then
    cp "$src/.githooks/pre-commit" "$hook" && chmod +x "$hook"
    echo -e "  ${GREEN}✓ .githooks/pre-commit Gradient installé (garde-fou CLAUDE.md)${NC}"
  else
    echo -e "  ${BLUE}= .githooks/pre-commit propre au projet conservé${NC}"
    grep -q "claude-md-guard" "$hook" || echo -e "  ${YELLOW}⚠ Pour le garde-fou CLAUDE.md, ajoutez dans votre pre-commit : sh .githooks/claude-md-guard.sh || exit 1${NC}"
  fi
  if ! (cd "$dst" && git rev-parse --git-dir >/dev/null 2>&1); then
    echo -e "  ${YELLOW}⚠ Projet hors git : hooks copiés, non activés${NC}"
    return 0
  fi
  local cur gitdir
  cur=$(cd "$dst" && git config core.hooksPath 2>/dev/null || true)
  gitdir=$(cd "$dst" && git rev-parse --git-dir)
  case "$gitdir" in /*) ;; *) gitdir="$dst/$gitdir" ;; esac
  if [ "$cur" = ".githooks" ]; then
    echo -e "  ${GREEN}✓ Hooks actifs (core.hooksPath = .githooks)${NC}"
    if [ -d "$dst/.husky" ]; then
      echo -e "  ${YELLOW}⚠ Dossier .husky présent mais inactif (core.hooksPath = .githooks, posé par une ancienne mise à jour) : pour le réactiver, npx husky puis ajoutez « sh .githooks/claude-md-guard.sh || exit 1 » dans .husky/pre-commit${NC}"
    fi
  elif [ -n "$cur" ]; then
    echo -e "  ${BLUE}= core.hooksPath = ${cur} conservé (Husky ou autre)${NC} : ajoutez « sh .githooks/claude-md-guard.sh || exit 1 » dans votre hook pre-commit"
  elif [ -d "$dst/.husky" ]; then
    # Husky pose son propre core.hooksPath à l'installation des dépendances (npm install) :
    # ne pas le préempter, même s'il n'est pas encore réglé dans ce clone
    echo -e "  ${BLUE}= Husky détecté : core.hooksPath laissé à Husky${NC} : ajoutez « sh .githooks/claude-md-guard.sh || exit 1 » dans .husky/pre-commit"
  elif [ -f "$gitdir/hooks/pre-commit" ]; then
    echo -e "  ${BLUE}= .git/hooks/pre-commit existant conservé (core.hooksPath non modifié)${NC} : ajoutez-y « sh .githooks/claude-md-guard.sh || exit 1 »"
  else
    (cd "$dst" && git config core.hooksPath .githooks)
    echo -e "  ${GREEN}✓ Hooks activés (core.hooksPath = .githooks)${NC}"
  fi
  return 0
}

print_header() {
  echo ""
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}  gradient-agents v${VERSION}${NC}"
  echo -e "${BOLD}  Librairie d'agents Claude Code · Gradient One${NC}"
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
  # Seule la présence des agents GRADIENT déclenche l'alerte : des agents maison seuls
  # ne bloquent pas l'installation (leurs noms ne sont jamais écrasés).
  if [ -f "$AGENTS_DIR/_base-agent-protocol.md" ] || [ -f "$AGENTS_DIR/fullstack.md" ] || [ -f "$AGENTS_DIR/orchestrator.md" ]; then
    echo -e "${YELLOW}⚠ L'équipe Gradient est déjà installée dans ${AGENTS_DIR}/${NC}"
    echo -e "  Agents existants : $(ls $AGENTS_DIR/*.md 2>/dev/null | wc -l | tr -d ' ') fichier(s)"
    echo ""
    # Pas de terminal (Claude Code, curl | bash) : ne jamais écraser, orienter vers update.sh
    response=""
    if [ -t 0 ]; then
      read -r -p "  Écraser avec la version du repo ? [o/N] " response || response=""
    elif (: < /dev/tty) 2>/dev/null; then
      read -r -p "  Écraser avec la version du repo ? [o/N] " response < /dev/tty || response=""
    fi
    if [[ ! "$response" =~ ^[oO]$ ]]; then
      echo -e "${YELLOW}  Installation annulée : l'équipe est déjà là, c'est une mise à jour. Lance update.sh (il préserve settings, hooks, agents maison et règles projet).${NC}"
      exit 0
    fi
  fi
}

clone_repo() {
  echo -e "${BLUE}→ Téléchargement des agents...${NC}"

  # Branche source : `stable` (promue par la CI quand tous les tests passent) en priorité,
# puis main, puis master (legacy). Un commit cassé sur main n'atteint donc pas les projets.
  DETECTED_BRANCH=""
  for BRANCH in stable main master; do
    if git ls-remote --exit-code --heads "$REPO_URL" "$BRANCH" >/dev/null 2>&1; then
      DETECTED_BRANCH="$BRANCH"
      break
    fi
  done

  if [ -z "$DETECTED_BRANCH" ]; then
    echo -e "${RED}✗ Aucune branche stable/main/master détectée sur $REPO_URL${NC}"
    exit 1
  fi

  echo -e "${BLUE}  Branche cible : ${DETECTED_BRANCH}${NC}"

  # Tentative avec sparse checkout (repos publics et privés avec auth)
  if git clone --filter=blob:none --sparse --quiet -b "$DETECTED_BRANCH" "$REPO_URL" "$TEMP_DIR/repo" 2>/dev/null; then
    cd "$TEMP_DIR/repo"
    git sparse-checkout set --no-cone /.claude/agents/ /.claude/settings.json /templates/ /CLAUDE.md /update.sh /.githooks/ /docs/founder-preferences.md /index.html /.claude/checklists/
    echo -e "${GREEN}✓ Agents téléchargés (sparse checkout)${NC}"
  else
    # Fallback : clone complet si sparse échoue (certaines configs git anciennes)
    echo -e "${YELLOW}  Sparse checkout indisponible, clone complet...${NC}"
    if git clone --quiet -b "$DETECTED_BRANCH" "$REPO_URL" "$TEMP_DIR/repo" 2>/dev/null; then
      echo -e "${GREEN}✓ Agents téléchargés (clone complet)${NC}"
    else
      echo -e "${RED}✗ Impossible de cloner le repo.${NC}"
      echo -e "${RED}  Vérifie que l'URL est correcte et que tu as les droits d'accès.${NC}"
      echo -e "${RED}  Pour un repo privé, configure un token : https://docs.github.com/en/authentication${NC}"
      exit 1
    fi
  fi
}

install_agents() {
  echo -e "${BLUE}→ Installation des agents...${NC}"
  local target_dir
  target_dir="$(pwd)/$AGENTS_DIR"
  if [ -n "${OLDPWD:-}" ]; then
    target_dir="$OLDPWD/$AGENTS_DIR"
  fi
  mkdir -p "$target_dir"
  cp -r "$TEMP_DIR/repo/.claude/agents/." "$target_dir/"
  # Les fichiers _*.md sont des protocoles partagés, pas des agents invocables
  local agent_count
  agent_count=$(ls "$target_dir"/*.md 2>/dev/null | grep -v '/_' | wc -l | tr -d ' ')
  echo -e "${GREEN}✓ ${agent_count} agents installés dans ${AGENTS_DIR}/ (+ protocoles partagés)${NC}"
}

install_settings_json() {
  local target_dir
  target_dir="$(pwd)"
  if [ -n "${OLDPWD:-}" ]; then
    target_dir="$OLDPWD"
  fi

  if [ -f "$TEMP_DIR/repo/.claude/settings.json" ]; then
    merge_settings_json "$TEMP_DIR/repo/.claude/settings.json" "$target_dir/.claude/settings.json" "$target_dir/.claude/gradient-backup"
  fi
}

install_claude_md() {
  local target_dir
  target_dir="$(pwd)"
  if [ -n "${OLDPWD:-}" ]; then
    target_dir="$OLDPWD"
  fi

  if [ ! -f "$TEMP_DIR/repo/CLAUDE.md" ]; then
    echo -e "${YELLOW}⚠ CLAUDE.md non trouvé dans le repo source${NC}"
    return
  fi

  local source="$TEMP_DIR/repo/CLAUDE.md"
  local target="$target_dir/CLAUDE.md"

  if [ ! -f "$target" ]; then
    # Pas de CLAUDE.md existant → copie directe
    cp "$source" "$target"
    echo -e "${GREEN}✓ CLAUDE.md installé${NC}"
  elif grep -q "GRADIENT-AGENTS-START" "$target"; then
    # CLAUDE.md existant avec marqueurs → remplacement de la section Gradient
    local gradient_content
    gradient_content=$(sed -n '/<!-- GRADIENT-AGENTS-START -->/,/<!-- GRADIENT-AGENTS-END -->/p' "$source")

    # Créer le fichier temporaire avec la section remplacée
    local tmp_file="$TEMP_DIR/claude_md_merged"
    sed '/<!-- GRADIENT-AGENTS-START -->/,/<!-- GRADIENT-AGENTS-END -->/d' "$target" > "$tmp_file"

    # Insérer le contenu Gradient au début (avant le contenu custom)
    echo "$gradient_content" | cat - "$tmp_file" > "$target"
    echo -e "${GREEN}✓ CLAUDE.md mis à jour (section Gradient remplacée, contenu custom préservé)${NC}"
  else
    # CLAUDE.md existant SANS marqueurs → append avec marqueurs
    echo "" >> "$target"
    cat "$source" >> "$target"
    echo -e "${GREEN}✓ CLAUDE.md fusionné (instructions Gradient ajoutées en fin de fichier)${NC}"
    echo -e "${YELLOW}  Conseil : les prochaines mises à jour remplaceront proprement la section Gradient grâce aux marqueurs.${NC}"
  fi
}

install_project_context() {
  local target_dir
  target_dir="$(pwd)"
  if [ -n "${OLDPWD:-}" ]; then
    target_dir="$OLDPWD"
  fi

  if [ ! -f "$target_dir/project-context.md" ]; then
    if [ -f "$TEMP_DIR/repo/templates/project-context.md" ]; then
      cp "$TEMP_DIR/repo/templates/project-context.md" "$target_dir/project-context.md"
      echo -e "${GREEN}✓ project-context.md créé à la racine, à remplir avant d'utiliser les agents${NC}"
    fi
  else
    echo -e "${YELLOW}⚠ project-context.md existe déjà, non écrasé${NC}"
  fi
}

install_update_script() {
  local target_dir
  target_dir="$(pwd)"
  if [ -n "${OLDPWD:-}" ]; then
    target_dir="$OLDPWD"
  fi

  if [ -f "$TEMP_DIR/repo/update.sh" ]; then
    cp "$TEMP_DIR/repo/update.sh" "$target_dir/update.sh"
    chmod +x "$target_dir/update.sh"
    echo -e "${GREEN}✓ update.sh installé${NC}"
  fi
}

install_shared_refs() {
  local target_dir
  target_dir="$(pwd)"
  if [ -n "${OLDPWD:-}" ]; then
    target_dir="$OLDPWD"
  fi
  mkdir -p "$target_dir/.claude"
  # Préférences fondateur + bibliothèque de prompts : lues par les agents, absentes sans cette copie
  if [ -f "$TEMP_DIR/repo/docs/founder-preferences.md" ]; then
    cp "$TEMP_DIR/repo/docs/founder-preferences.md" "$target_dir/.claude/founder-preferences.md"
    echo -e "${GREEN}✓ .claude/founder-preferences.md installé (stack par défaut, préférences fondateur)${NC}"
  fi
  if [ -d "$TEMP_DIR/repo/.claude/checklists" ]; then
    mkdir -p "$target_dir/.claude/checklists"
    cp "$TEMP_DIR/repo/.claude/checklists"/*.md "$target_dir/.claude/checklists/" 2>/dev/null || true
    echo -e "${GREEN}✓ .claude/checklists/ installé (checklists citées par les agents)${NC}"
  fi
  if [ -f "$TEMP_DIR/repo/index.html" ]; then
    cp "$TEMP_DIR/repo/index.html" "$target_dir/.claude/prompts-library.html"
    echo -e "${GREEN}✓ .claude/prompts-library.html installé (bibliothèque de prompts)${NC}"
  fi
}

install_githooks() {
  local target_dir
  target_dir="$(pwd)"
  if [ -n "${OLDPWD:-}" ]; then
    target_dir="$OLDPWD"
  fi
  sync_githooks "$TEMP_DIR/repo" "$target_dir"
  ensure_gitignore "$target_dir"
}

print_summary() {
  local target_dir
  target_dir="$(pwd)"
  if [ -n "${OLDPWD:-}" ]; then
    target_dir="$OLDPWD"
  fi

  echo ""
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}  Agents installés :${NC}"
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

  for agent_file in "$target_dir/$AGENTS_DIR"/*.md; do
    agent_name=$(basename "$agent_file" .md)
    case "$agent_name" in _*) continue ;; esac
    description=$(grep -m1 "^description:" "$agent_file" 2>/dev/null | sed 's/description: *//;s/^"//;s/"$//' || echo "")
    printf "  ${GREEN}%-20s${NC} %s\n" "@$agent_name" "$description"
  done

  echo ""
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}  Démarrage rapide :${NC}"
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "  ${YELLOW}1.${NC} Remplis ${BOLD}project-context.md${NC} à la racine du projet"
  echo -e "  ${YELLOW}2.${NC} Dans Claude Code, décris ton besoin (ex : ${BOLD}lance mon projet${NC}), le routage est automatique"
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
clone_repo
install_agents
install_settings_json
install_claude_md
install_project_context
install_update_script
install_shared_refs
install_githooks
write_gradient_version "${OLDPWD:-$(pwd)}" "${DETECTED_BRANCH:-main}"
print_summary
