#!/usr/bin/env bash
# Gradient Agents — Tests bout en bout de install.sh et update.sh
# Rejoue les situations rencontrées sur les vrais projets (ISSA, Versi, Husky, ancienne équipe...)
# contre une copie locale du repo (historique git réel + arbre de travail courant).
# Usage : bash tests/test-installers.sh [racine]   — exit = nombre d'échecs
# Prérequis : historique git complet (en CI : actions/checkout avec fetch-depth: 0).

set -uo pipefail
ROOT="$(cd "${1:-.}" && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
FAILS=0; PASSES=0
OLD_REF="0a82aea"          # équipe d'avant la revue des prompts (versions d'origine anciennes)
ORCH_REF="ccae5f0"         # commit qui a renommé orchestrator.md
LEGACY_HOOK_REF="744d4f0~1" # dernier pre-commit Gradient avant le marqueur GRADIENT-HOOK

ok()   { printf "\033[32m  PASS\033[0m %s\n" "$1"; PASSES=$((PASSES+1)); }
ko()   { printf "\033[31m  FAIL\033[0m %s\n" "$1"; FAILS=$((FAILS+1)); }
check() { if eval "$2" >/dev/null 2>&1; then ok "$1"; else ko "$1"; fi; }
clean() { sed 's/\x1b\[[0-9;]*m//g' "$1"; }
G() { git -c user.email=t@t -c user.name=t "$@"; }

# ─── Dépôt source de test : historique réel + arbre de travail courant ───
git clone -q "$ROOT" "$WORK/src" || { echo "clone impossible"; exit 1; }
(cd "$WORK/src" && git rm -rq . && (cd "$ROOT" && git ls-files -co --exclude-standard | tar cf - -T -) | tar xf - \
  && git add -A && G commit -qm "WIP test" && git checkout -q -B main)
for f in install update; do
  sed -e "s#^REPO_URL=.*#REPO_URL=\"file://$WORK/src\"#" -e "s#--filter=blob:none ##" "$ROOT/$f.sh" > "$WORK/$f-src.sh"
done
HAS_HISTORY=true
git -C "$ROOT" cat-file -e "$OLD_REF^{commit}" 2>/dev/null || HAS_HISTORY=false

newproj() {  # projet git vide
  P="$WORK/p/$1"; mkdir -p "$P/.claude/agents" && cd "$P" && git init -q && G commit -q --allow-empty -m init
}
team() {     # équipe Gradient à jour + CLAUDE.md avec règles maison + update.sh de test
  cp "$WORK/src/.claude/agents/"*.md .claude/agents/
  sed -n '/GRADIENT-AGENTS-START/,/GRADIENT-AGENTS-END/p' "$WORK/src/CLAUDE.md" > CLAUDE.md
  printf '\n## Règles maison\nR1 maison.\n' >> CLAUDE.md
  cp "$WORK/update-src.sh" update.sh
}
upd() { cp "$WORK/update-src.sh" update.sh; timeout 300 bash update.sh --all > "$1" 2>&1 < /dev/null; }

echo "=== Tests installeurs ==="

echo "--- S1 installation neuve"
newproj s1; timeout 300 bash "$WORK/install-src.sh" > ../s1.log 2>&1 < /dev/null; rc=$?
check "exit 0" "[ $rc -eq 0 ]"
check "19 agents (hors _*.md)" "[ \$(ls .claude/agents/*.md | grep -v '/_' | wc -l) -eq 19 ]"
check "update.sh, préférences, bibliothèque, checklists posés" "[ -f update.sh ] && [ -f .claude/founder-preferences.md ] && [ -f .claude/prompts-library.html ] && [ -f .claude/checklists/favicon-checklist.md ]"
check "tampon de version écrit (branche + commit)" "grep -q '^branche: main' .claude/gradient-version && grep -q '^commit: ' .claude/gradient-version"
check "hooks actifs (GRADIENT-HOOK + hooksPath)" "grep -q GRADIENT-HOOK .githooks/pre-commit && [ \"\$(git config core.hooksPath)\" = .githooks ]"

echo "--- S2 installation alors que l'équipe est déjà là (sans terminal)"
timeout 300 bash "$WORK/install-src.sh" > ../s2.log 2>&1 < /dev/null; rc=$?
check "exit 0 et redirection vers update.sh" "[ $rc -eq 0 ] && clean ../s2.log | grep -q 'Installation annulée'"

echo "--- S3 installation sur un projet avec seulement des agents maison"
newproj s3; printf -- '---\nname: leila\nmodel: claude-sonnet-5-5\n---\n' > .claude/agents/leila.md
printf '{"permissions":{"allow":["Bash(make *)"]},"env":{"X":"1"}}\n' > .claude/settings.json
timeout 300 bash "$WORK/install-src.sh" > ../s3.log 2>&1 < /dev/null; rc=$?
check "exit 0, agent maison conservé, 20 agents" "[ $rc -eq 0 ] && [ -f .claude/agents/leila.md ] && [ \$(ls .claude/agents/*.md | grep -v '/_' | wc -l) -eq 20 ]"
check "settings.json fusionné (env + permission maison + permissions Gradient)" "grep -q '\"X\"' .claude/settings.json && grep -q 'make' .claude/settings.json && grep -q 'git \*' .claude/settings.json"

echo "--- S4 mise à jour type ISSA (settings, hook maison, agent maison, préférences projet)"
newproj s4; team
printf '{"permissions":{"allow":["Read"]},"hooks":{"PreToolUse":[]},"env":{"ISSA":"1"}}\n' > .claude/settings.json
mkdir -p .githooks docs; printf '#!/bin/sh\nnpx tsc --noEmit || exit 1\nsh scripts/qa.sh || exit 1\n' > .githooks/pre-commit; git config core.hooksPath .githooks
printf -- '---\nname: karim\nmodel: claude-sonnet-4-6\n---\n' > .claude/agents/karim.md
printf '# Préférences ISSA\n- vocabulaire banni : patrimonial\n' > docs/founder-preferences.md
upd ../s4.log; rc=$?
check "exit 0" "[ $rc -eq 0 ]"
check "hooks et env de settings.json conservés" "grep -q PreToolUse .claude/settings.json && grep -q ISSA .claude/settings.json"
check "pre-commit maison intact" "grep -q 'scripts/qa.sh' .githooks/pre-commit"
check "agent maison intact et signalé obsolète" "grep -q sonnet-4-6 .claude/agents/karim.md && clean ../s4.log | grep -q 'karim.md sur claude-sonnet-4-6'"
check "préférences projet et règles CLAUDE.md maison intactes" "grep -q patrimonial docs/founder-preferences.md && grep -q 'R1 maison' CLAUDE.md"

echo "--- S4b règle maison écrite DANS le bloc Gradient de CLAUDE.md"
newproj s4b; team; sed -i 's/^## Routage automatique$/## Routage automatique\n| Généalogie maison | @genealogiste |/' CLAUDE.md
upd ../s4b.log; rc=$?
check "ligne maison sortie du bloc, pas perdue" "[ $rc -eq 0 ] && sed '/GRADIENT-AGENTS-START/,/GRADIENT-AGENTS-END/d' CLAUDE.md | grep -q 'Généalogie maison'"
upd ../s4c.log
check "second passage : pas de doublon" "[ \$(grep -c 'Généalogie maison' CLAUDE.md) -eq 1 ]"

echo "--- S5 Husky conservé"
newproj s5; team; mkdir -p .husky/_; git config core.hooksPath .husky/_
upd ../s5.log; rc=$?
check "exit 0 et core.hooksPath inchangé" "[ $rc -eq 0 ] && [ \"\$(git config core.hooksPath)\" = .husky/_ ]"

echo "--- S5b Husky présent mais pas encore installé (clone neuf)"
newproj s5b; team; mkdir -p .husky; printf 'npm test\n' > .husky/pre-commit
upd ../s5b.log; rc=$?
check "exit 0 et core.hooksPath laissé à Husky (non réglé)" "[ $rc -eq 0 ] && [ -z \"\$(git config core.hooksPath)\" ]"

echo "--- S6 projet hors git"
P="$WORK/p/s6"; mkdir -p "$P/.claude/agents" && cd "$P" && cp "$WORK/src/.claude/agents/"*.md .claude/agents/
upd ../s6.log; rc=$?
check "exit 0 (hooks copiés, non activés)" "[ $rc -eq 0 ] && clean ../s6.log | grep -q 'Projet hors git'"

echo "--- S7 settings.json invalide : jamais écrasé"
newproj s7; team; printf 'pas du json' > .claude/settings.json
upd ../s7.log; rc=$?
check "fichier du projet intact + version Gradient à côté" "[ $rc -eq 0 ] && grep -q 'pas du json' .claude/settings.json && [ -f .claude/settings.gradient.json ]"

echo "--- S8 auto-mise à jour d'update.sh"
newproj s8; team; echo "# MARQUEUR-ANCIEN" >> update.sh
timeout 300 bash update.sh --all > ../s8.log 2>&1 < /dev/null; rc=$?
check "tampon de version mis à jour" "grep -q '^commit: ' .claude/gradient-version"
check "exit 0 et script remplacé (atomique)" "[ $rc -eq 0 ] && ! grep -q MARQUEUR-ANCIEN update.sh"

if [ "$HAS_HISTORY" = true ]; then
  echo "--- S9 ancienne équipe (historique git) : sauvegardes fantômes, obsolètes, personnalisations"
  newproj s9
  for f in $(git -C "$ROOT" ls-tree --name-only "$OLD_REF" .claude/agents/); do git -C "$ROOT" show "$OLD_REF:$f" > "$f"; done
  git -C "$ROOT" show "$ORCH_REF^:.claude/agents/orchestrator.md" > .claude/agents/orchestrator.md
  printf '\n<!-- PROJECT-RULES-START -->\n## Règles propres à ce projet\n- Pas de barrel exports.\n<!-- PROJECT-RULES-END -->\n' >> .claude/agents/fullstack.md
  printf '\n## Règle éditoriale\n- Du fond, jamais de la défense.\n' >> .claude/agents/copywriter.md
  python3 -c "p='.claude/agents/design.md';s=open(p).read();i=s.index('\n## ',200);open(p,'w').write(s[:i]+'\n- Règle insérée au milieu : terracotta.'+s[i:])"
  mkdir -p .claude/agents/.backup .claude/agents/_deprecated .claude/agents/sub
  cp .claude/agents/ux.md .claude/agents/.backup/; printf -- '---\nname: vieux\nmodel: claude-3\n---\n' > .claude/agents/_deprecated/vieux.md
  cp .claude/agents/qa.md .claude/agents/sub/qa.md
  printf -- '---\nname: karim\nmodel: claude-sonnet-5-5\n---\n' > .claude/agents/karim.md
  mkdir -p .githooks; git -C "$ROOT" show "$LEGACY_HOOK_REF:.githooks/pre-commit" > .githooks/pre-commit; git config core.hooksPath .githooks
  upd ../s9.log; rc=$?
  check "exit 0" "[ $rc -eq 0 ]"
  check "sauvegarde fantôme et dépréciés sortis de .claude/agents/" "[ ! -d .claude/agents/.backup ] && [ ! -d .claude/agents/_deprecated ] && [ -f .claude/deprecated-agents/vieux.md ]"
  check "orchestrator.md obsolète retiré, agent maison conservé" "[ ! -f .claude/agents/orchestrator.md ] && [ -f .claude/agents/karim.md ]"
  check "bloc PROJECT-RULES préservé et agent à jour" "grep -q 'Pas de barrel' .claude/agents/fullstack.md && grep -q claude-opus-5-5 .claude/agents/fullstack.md"
  check "ajout en fin de fichier rangé en bloc PROJECT-RULES" "sed -n '/^<!-- PROJECT-RULES-START -->\$/,/^<!-- PROJECT-RULES-END -->\$/p' .claude/agents/copywriter.md | grep -q 'jamais de la défense'"
  check "modif au milieu : agent conservé, nouvelle version en attente" "grep -q terracotta .claude/agents/design.md && [ -f .claude/gradient-backup/pending/design.md ]"
  check "doublon en sous-dossier signalé" "clean ../s9.log | grep -q 'Doublon : .claude/agents/sub/qa.md'"
  check "ancien hook Gradient intact remplacé" "grep -q GRADIENT-HOOK .githooks/pre-commit"
  upd ../s9b.log; rc=$?
  check "second passage stable (0 agent mis à jour)" "[ $rc -eq 0 ] && clean ../s9b.log | grep -q ' 0 agents mis à jour'"
  echo "--- S10 rollback"
  echo "x-local" >> .claude/agents/qa.md; upd ../s10a.log
  timeout 120 bash update.sh --rollback > ../s10.log 2>&1 < /dev/null; rc=$?
  check "rollback restaure la version d'avant la mise à jour" "[ $rc -eq 0 ] && tail -1 .claude/agents/qa.md | grep -q x-local"
else
  printf "\033[33m  SKIP\033[0m S9-S10 : historique git absent (clone superficiel ?)\n"
fi

echo ""
echo "=== Résultat : $PASSES PASS, $FAILS FAIL ==="
exit "$FAILS"
