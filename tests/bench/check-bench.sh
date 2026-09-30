#!/usr/bin/env bash
# Gradient Agents — Banc d'essai : contrôle automatique des livrables produits par les agents
# sur le projet fictif PulseBoard (tests/project-context-test.md).
# Usage : bash tests/bench/check-bench.sh <dossier-projet-bench>
# Attend : docs/strategy/brand-platform.md, docs/copy/landing-page-copy.md, docs/ia/ai-architecture.md
# Exit = nombre d'échecs. Mesure des faits vérifiables, pas un jugement de goût.

set -uo pipefail
B="${1:?dossier du projet bench requis}"
FAILS=0; PASSES=0
ok() { printf "\033[32m  PASS\033[0m %s\n" "$1"; PASSES=$((PASSES+1)); }
ko() { printf "\033[31m  FAIL\033[0m %s\n" "$1"; FAILS=$((FAILS+1)); }
chk() { if eval "$2" >/dev/null 2>&1; then ok "$1"; else ko "$1"; fi; }
cnt() { grep -ciE "$1" "$2" 2>/dev/null || true; }

PERSONA="Marie"
ACCENTS='deja|etre|tres|regle|donnees|equipe|strategie|securite|probleme|modele|qualite|deploiement|apres|coherence|methode|categorie|benefice|metrique'
AI_TICS="ce n'est pas [^.]{1,60}, c'est|dans un monde où|révolutionn|booste[rz]?|sans effort|en résumé|plongeons|sublime[rz]?"

generic() {  # $1 fichier
  local f="$1"
  chk "existe et ≥ 30 lignes" "[ \$(wc -l < '$f') -ge 30 ]"
  chk "G3 bloc Handoff" "grep -q 'Handoff' '$f'"
  chk "G5 persona nommé ($PERSONA)" "grep -q '$PERSONA' '$f'"
  chk "G15 zéro placeholder" "! grep -qE '\[(À REMPLIR|À COMPLÉTER|PLACEHOLDER|TODO|NOM|EXEMPLE|XX|VOTRE|INSÉRER|REMPLACER)' '$f'"
  chk "G_PROOF bloc « Vérifié : »" "grep -q 'Vérifié :' '$f'"
  chk "accents : aucun mot courant sans accent" "! LC_ALL=C.UTF-8 grep -qwE '$ACCENTS' '$f'"
}

echo "=== Banc d'essai PulseBoard : $B ==="

F="$B/docs/strategy/brand-platform.md"
echo "--- @creative-strategy : $F"
if [ -f "$F" ]; then
  generic "$F"
  chk "framework(s) stratégique(s) nommé(s)" "grep -qiE 'Kapferer|Golden Circle|Blue Ocean|ERRC|Brand Key|Category Design|Perceptual' '$F'"
  chk "hiérarchie de messages + preuves (RTB)" "grep -qiE 'hiérarchie de messages' '$F' && grep -qiE 'RTB|Reason to believe|preuve' '$F'"
  chk "espace libre / ce que tous les concurrents font" "grep -qiE 'espace libre|tous les concurrents|personne ne' '$F'"
  chk "exclusions : ce que la marque ne fait pas" "grep -qiE 'ne fait pas|exclusion|renonce' '$F'"
else ko "brand-platform.md absent"; fi

F="$B/docs/copy/landing-page-copy.md"
echo "--- @copywriter : $F"
if [ -f "$F" ]; then
  generic "$F"
  chk "zéro tiret cadratin (—) dans le copy" "! grep -q '—' '$F'"
  n=$(grep -ciE "$AI_TICS" "$F" || true)
  chk "zéro tic d'écriture IA (trouvés : $n)" "[ '$n' -eq 0 ]"
  chk "framework de persuasion documenté par section" "grep -qE '\[Framework ?:' '$F'"
  chk "aucun témoignage inventé (réels ou [À COLLECTER])" "! grep -qE '(«|\")[^»\"]{20,}(»|\")[[:space:]]*[-–—,][[:space:]]*(Marie|Sophie|Julie|Thomas|[A-Z][a-z]+ [A-Z]\.)' '$F' || grep -q 'À COLLECTER' '$F'"
  chk "objections traitées (FAQ ou section objections)" "grep -qiE 'FAQ|objection' '$F'"
else ko "landing-page-copy.md absent"; fi

F="$B/docs/ia/ai-architecture.md"
echo "--- @ia : $F"
if [ -f "$F" ]; then
  generic "$F"
  chk "IDs de modèles actuels uniquement" "grep -qE 'claude-(opus|sonnet)-5-5|claude-haiku-4-5' '$F' && ! grep -qE 'claude-3|claude-(opus|sonnet)-4|sonnet-5[^-]|opus-5[^-]|gpt-4o' '$F'"
  chk "effort fixé explicitement" "grep -qiE 'effort' '$F'"
  chk "pas de tool forcé recommandé (tool_choice any/tool)" "! grep -qiE 'tool_choice[^|]{0,40}(\"any\"|\"tool\"|: *any|: *tool)' '$F' || grep -qiE '(interdit|400|refusé|jamais)[^|]{0,80}tool_choice|tool_choice[^|]{0,80}(interdit|400|refusé)' '$F'"
  chk "pas de temperature ni budget_tokens recommandés" "! grep -qiE '(temperature|budget_tokens)[^|]{0,20}[:=] *[0-9]' '$F'"
  chk "structured outputs natifs" "grep -qiE 'structured output|output_config|messages\.parse' '$F'"
  chk "refus / stop_reason géré" "grep -qiE 'refus|stop_reason' '$F'"
  chk "coût : caching ou batch mentionnés" "grep -qiE 'cach|batch' '$F'"
else ko "ai-architecture.md absent"; fi

echo ""
echo "=== Banc : $PASSES PASS, $FAILS FAIL ==="
exit "$FAILS"
