#!/usr/bin/env bash
set -euo pipefail

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# gradient-agents — Script de mise à jour
# Usage : bash update.sh [--all] [--rollback]
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

REPO_URL="https://github.com/thomasissa-png/Agent-Team"
AGENTS_DIR=".claude/agents"
BACKUP_DIR=".claude/agents/.backup"
TEMP_DIR=$(mktemp -d)
UPDATE_ALL=false
ROLLBACK=false

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

cleanup() { rm -rf "$TEMP_DIR"; }
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
  mkdir -p "$bak" && cp "$dst" "$bak/settings.json"
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

# Ancien pre-commit Gradient (avant le marqueur GRADIENT-HOOK), jamais modifié par le projet
is_legacy_gradient_hook() {
  grep -q "Guard: la section Gradient de CLAUDE.md" "$1" \
    && [ "$(wc -l < "$1")" -le 20 ] \
    && ! grep -qE "tsc|npm|npx|pnpm|yarn|bun|vitest|jest|husky|claude-md-guard" "$1"
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
  elif [ -f "$gitdir/hooks/pre-commit" ]; then
    echo -e "  ${BLUE}= .git/hooks/pre-commit existant conservé (core.hooksPath non modifié)${NC} : ajoutez-y « sh .githooks/claude-md-guard.sh || exit 1 »"
  else
    (cd "$dst" && git config core.hooksPath .githooks)
    echo -e "  ${GREEN}✓ Hooks activés (core.hooksPath = .githooks)${NC}"
  fi
  return 0
}

# ─── Parsing des arguments ───────────────────────────
for arg in "$@"; do
  case "$arg" in
    --all) UPDATE_ALL=true ;;
    --rollback) ROLLBACK=true ;;
  esac
done

if [ ! -d "$AGENTS_DIR" ]; then
  echo -e "${YELLOW}Aucun agent installé. Lance install.sh d'abord.${NC}"
  exit 1
fi

# ─── Mode rollback ───────────────────────────────────
if [ "$ROLLBACK" = true ]; then
  if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${RED}✗ Aucune sauvegarde trouvée dans ${BACKUP_DIR}/${NC}"
    echo -e "  Le rollback n'est possible qu'après une mise à jour."
    exit 1
  fi

  backup_count=$(ls "$BACKUP_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
  echo -e "${BOLD}gradient-agents : rollback${NC}"
  echo -e "${YELLOW}→ Restauration de ${backup_count} agent(s) depuis la sauvegarde...${NC}"

  for backup_file in "$BACKUP_DIR"/*.md; do
    agent_name=$(basename "$backup_file")
    cp "$backup_file" "$AGENTS_DIR/$agent_name"
    echo -e "  ${GREEN}✓ Restauré : ${agent_name}${NC}"
  done

  rm -rf "$BACKUP_DIR"
  echo ""
  echo -e "${GREEN}Rollback terminé. La sauvegarde a été supprimée.${NC}"
  exit 0
fi

# ─── Mode mise à jour ────────────────────────────────
echo -e "${BOLD}gradient-agents : mise à jour${NC}"
echo ""
echo -e "${BLUE}→ Récupération des dernières versions...${NC}"

# Détection automatique de la branche par défaut (main préférée, master fallback legacy)
# Couvre le bootstrap problem : ancien update.sh local pointe sur master qui peut avoir été renommé
DETECTED_BRANCH=""
for BRANCH in main master; do
  if git ls-remote --exit-code --heads "$REPO_URL" "$BRANCH" >/dev/null 2>&1; then
    DETECTED_BRANCH="$BRANCH"
    break
  fi
done

if [ -z "$DETECTED_BRANCH" ]; then
  echo -e "${RED}✗ Aucune branche main/master détectée sur $REPO_URL${NC}"
  echo -e "${RED}  Vérifie l'URL et les droits d'accès.${NC}"
  exit 1
fi

echo -e "${BLUE}  Branche cible : ${DETECTED_BRANCH}${NC}"

# Clone avec fallback pour repos privés
if git clone --filter=blob:none --sparse --quiet -b "$DETECTED_BRANCH" "$REPO_URL" "$TEMP_DIR/repo" 2>/dev/null; then
  cd "$TEMP_DIR/repo"
  git sparse-checkout set --no-cone /.claude/agents/ /.claude/settings.json /CLAUDE.md /.githooks/ /update.sh /docs/founder-preferences.md /index.html
else
  if git clone --quiet -b "$DETECTED_BRANCH" "$REPO_URL" "$TEMP_DIR/repo" 2>/dev/null; then
    cd "$TEMP_DIR/repo"
  else
    echo -e "${RED}✗ Impossible de cloner le repo (branche $DETECTED_BRANCH).${NC}"
    echo -e "${RED}  Vérifie l'URL et les droits d'accès.${NC}"
    exit 1
  fi
fi

echo -e "${GREEN}✓ Dernières versions récupérées${NC}"
echo ""

# Créer une sauvegarde avant mise à jour
mkdir -p "$OLDPWD/$BACKUP_DIR"
cp "$OLDPWD/$AGENTS_DIR"/*.md "$OLDPWD/$BACKUP_DIR/" 2>/dev/null || true
echo -e "${BLUE}→ Sauvegarde créée dans ${BACKUP_DIR}/ (rollback : bash update.sh --rollback)${NC}"
echo ""

updated=0
skipped=0
new_agents=0

for remote_agent in "$TEMP_DIR/repo/.claude/agents"/*.md; do
  agent_name=$(basename "$remote_agent")
  local_agent="$OLDPWD/$AGENTS_DIR/$agent_name"

  if [ ! -f "$local_agent" ]; then
    cp "$remote_agent" "$local_agent"
    echo -e "  ${GREEN}+ Nouvel agent installé : ${agent_name}${NC}"
    new_agents=$((new_agents+1))
    continue
  fi

  remote_hash=$(md5sum "$remote_agent" | cut -d' ' -f1)
  local_hash=$(md5sum "$local_agent" | cut -d' ' -f1)

  if [ "$remote_hash" == "$local_hash" ]; then
    skipped=$((skipped+1))
    continue
  fi

  if [ "$UPDATE_ALL" = true ]; then
    cp "$remote_agent" "$local_agent"
    echo -e "  ${GREEN}✓ Mis à jour : ${agent_name}${NC}"
    updated=$((updated+1))
  else
    echo -e "  ${YELLOW}↑ Mise à jour disponible : ${agent_name}${NC}"
    read -r -p "    Mettre à jour ? [o/N] " response
    if [[ "$response" =~ ^[oO]$ ]]; then
      cp "$remote_agent" "$local_agent"
      echo -e "    ${GREEN}✓ Mis à jour${NC}"
      updated=$((updated+1))
    else
      skipped=$((skipped+1))
    fi
  fi
done

# ─── Nettoyage des fichiers framework obsolètes (renommés/supprimés en amont) ───
# update.sh copie les fichiers présents en remote mais ne supprime pas ceux qui
# en ont disparu. Ces fichiers-là sont d'anciens agents/protocoles remplacés :
# les laisser réenregistrerait des agents fantômes. Backup déjà fait ci-dessus.
for obsolete in moi.md orchestrator-reference.md orchestrator.md; do
  if [ -f "$OLDPWD/$AGENTS_DIR/$obsolete" ]; then
    rm -f "$OLDPWD/$AGENTS_DIR/$obsolete"
    echo -e "  ${GREEN}✓ Fichier obsolète retiré : ${obsolete}${NC}"
  fi
done

# ─── Agents maison sur un modèle obsolète (le script ne les modifie jamais) ───
current_models=$(grep -h '^model: claude-' "$TEMP_DIR/repo/.claude/agents"/*.md 2>/dev/null | sed 's/^model: *//' | sort -u)
for custom_agent in "$OLDPWD/$AGENTS_DIR"/*.md; do
  custom_name=$(basename "$custom_agent")
  case "$custom_name" in _*) continue ;; esac
  [ -f "$TEMP_DIR/repo/.claude/agents/$custom_name" ] && continue
  custom_model=$(grep -m1 '^model:' "$custom_agent" 2>/dev/null | sed 's/^model: *//' | tr -d '"'"'"' ' || true)
  case "$custom_model" in ""|inherit|opus|sonnet|haiku|claude-haiku-4-5*) continue ;; esac
  if ! echo "$current_models" | grep -qx "$custom_model"; then
    echo -e "  ${YELLOW}⚠ Agent maison ${custom_name} sur ${custom_model} (obsolète) : passez-le à l'un de : $(echo $current_models)${NC}"
  fi
done

# ─── settings.json : fusion, jamais d'écrasement ────
if [ -f "$TEMP_DIR/repo/.claude/settings.json" ]; then
  merge_settings_json "$TEMP_DIR/repo/.claude/settings.json" "$OLDPWD/.claude/settings.json" "$OLDPWD/$BACKUP_DIR"
fi

# ─── Préférences fondateur + bibliothèque de prompts ─
if [ -f "$TEMP_DIR/repo/docs/founder-preferences.md" ]; then
  cp "$TEMP_DIR/repo/docs/founder-preferences.md" "$OLDPWD/.claude/founder-preferences.md"
  echo -e "  ${GREEN}✓ .claude/founder-preferences.md synchronisé${NC}"
fi
if [ -f "$TEMP_DIR/repo/index.html" ]; then
  cp "$TEMP_DIR/repo/index.html" "$OLDPWD/.claude/prompts-library.html"
  echo -e "  ${GREEN}✓ .claude/prompts-library.html synchronisé${NC}"
fi

# ─── Mise à jour de update.sh lui-même ─────────────
# Remplacement atomique (mv, nouvel inode) : un cp écraserait le fichier que bash
# est en train de lire, et la suite du script s'exécuterait à partir d'octets décalés.
if [ -f "$TEMP_DIR/repo/update.sh" ]; then
  cp "$TEMP_DIR/repo/update.sh" "$OLDPWD/.update.sh.new"
  chmod +x "$OLDPWD/.update.sh.new"
  mv -f "$OLDPWD/.update.sh.new" "$OLDPWD/update.sh"
  echo -e "  ${GREEN}✓ update.sh mis à jour${NC}"
fi

# ─── Hooks git : garde-fou CLAUDE.md, hook du projet et Husky préservés ───
sync_githooks "$TEMP_DIR/repo" "$OLDPWD"

# ─── Mise à jour de CLAUDE.md (fusion avec marqueurs) ─
if [ -f "$TEMP_DIR/repo/CLAUDE.md" ]; then
  local_claude="$OLDPWD/CLAUDE.md"
  source_claude="$TEMP_DIR/repo/CLAUDE.md"

  if [ ! -f "$local_claude" ]; then
    cp "$source_claude" "$local_claude"
    echo -e "  ${GREEN}✓ CLAUDE.md installé${NC}"
  elif grep -q "GRADIENT-AGENTS-START" "$local_claude"; then
    # Remplacement de la section Gradient entre les marqueurs
    gradient_content=$(sed -n '/<!-- GRADIENT-AGENTS-START -->/,/<!-- GRADIENT-AGENTS-END -->/p' "$source_claude")
    tmp_merged="$TEMP_DIR/claude_md_merged"
    sed '/<!-- GRADIENT-AGENTS-START -->/,/<!-- GRADIENT-AGENTS-END -->/d' "$local_claude" > "$tmp_merged"
    echo "$gradient_content" | cat - "$tmp_merged" > "$local_claude"
    echo -e "  ${GREEN}✓ CLAUDE.md mis à jour (section Gradient remplacée, contenu custom préservé)${NC}"
  else
    echo -e "  ${YELLOW}⚠ CLAUDE.md sans marqueurs Gradient, ajout en fin de fichier${NC}"
    echo "" >> "$local_claude"
    cat "$source_claude" >> "$local_claude"
    echo -e "  ${GREEN}✓ CLAUDE.md fusionné${NC}"
  fi
fi

echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}  Résumé :${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${GREEN}${updated}${NC} agents mis à jour"
echo -e "  ${GREEN}${new_agents}${NC} nouveaux agents"
echo -e "  ${BLUE}${skipped}${NC} déjà à jour"
echo -e "  ${GREEN}✓${NC} settings.json fusionné, CLAUDE.md synchronisé (réglages du projet préservés)"
echo ""
echo -e "${YELLOW}Note : project-context.md n'est jamais écrasé.${NC}"
echo -e "${YELLOW}Rollback : bash update.sh --rollback${NC}"
