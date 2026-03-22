#!/usr/bin/env bash
# Gradient Agents — Deliverable Validation
# Vérifie qu'un livrable produit par un agent respecte les standards.
# Usage: bash tests/validate-deliverable.sh <chemin-fichier>

set -euo pipefail

FILE="${1:-}"
ERRORS=0
WARNINGS=0

red()    { printf "\033[31m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
green()  { printf "\033[32m%s\033[0m\n" "$1"; }

err()  { red  "[ERREUR] $1"; ERRORS=$((ERRORS + 1)); }
warn() { yellow "[AVERTISSEMENT] $1"; WARNINGS=$((WARNINGS + 1)); }
ok()   { green "[OK] $1"; }

if [ -z "$FILE" ]; then
  echo "Usage: bash tests/validate-deliverable.sh <chemin-fichier>"
  exit 1
fi

if [ ! -f "$FILE" ]; then
  red "Fichier $FILE introuvable."
  exit 1
fi

BASENAME=$(basename "$FILE")
LINE_COUNT=$(wc -l < "$FILE")

echo "=== Validation du livrable: $BASENAME ==="
echo "Lignes: $LINE_COUNT"
echo ""

# 1. Taille minimale
echo "--- Structure ---"
if [ "$LINE_COUNT" -lt 20 ]; then
  err "Livrable trop court ($LINE_COUNT lignes, minimum 20). Probable timeout ou échec."
elif [ "$LINE_COUNT" -lt 50 ]; then
  warn "Livrable court ($LINE_COUNT lignes). Vérifier que le contenu est complet."
else
  ok "Taille acceptable ($LINE_COUNT lignes)"
fi

# 2. Handoff présent
if grep -qi "Handoff" "$FILE"; then
  ok "Bloc Handoff présent"
else
  err "Pas de bloc Handoff en fin de livrable"
fi

# 3. Placeholders non remplis
PLACEHOLDER_COUNT=0
for pattern in '\[TODO\]' '\[A COMPLETER\]' '\[À COMPLÉTER\]' '\[PLACEHOLDER\]' '\[INSERT\]' '\[XXX\]'; do
  MATCHES=$(grep -ci "$pattern" "$FILE" 2>/dev/null || echo 0)
  PLACEHOLDER_COUNT=$((PLACEHOLDER_COUNT + MATCHES))
done
if [ "$PLACEHOLDER_COUNT" -gt 0 ]; then
  err "$PLACEHOLDER_COUNT placeholder(s) non rempli(s) détecté(s)"
else
  ok "Pas de placeholders non remplis"
fi

# 4. Hypothèses marquées correctement
HYPO_COUNT=$(grep -c '\[HYPOTHÈSE' "$FILE" 2>/dev/null || echo 0)
if [ "$HYPO_COUNT" -gt 0 ]; then
  # Vérifier qu'il y a un bloc "Hypothèses à valider" en fin de document
  if grep -qi "Hypothèses à valider" "$FILE"; then
    ok "$HYPO_COUNT hypothèse(s) marquée(s), bloc récapitulatif présent"
  else
    warn "$HYPO_COUNT hypothèse(s) marquée(s) mais pas de bloc 'Hypothèses à valider' en fin de document"
  fi
else
  ok "Pas d'hypothèses (toutes les données sont factuelles)"
fi

# 5. Sections avec contenu (pas juste des titres vides)
SECTION_COUNT=$(grep -c "^## " "$FILE" 2>/dev/null || echo 0)
if [ "$SECTION_COUNT" -lt 2 ]; then
  warn "Peu de sections structurées ($SECTION_COUNT). Le livrable manque peut-être de structure."
else
  ok "$SECTION_COUNT sections structurées"
fi

# 6. Références à project-context.md ou au projet
if grep -qi "project-context\|persona\|objectif.*mois\|KPI" "$FILE"; then
  ok "Références au contexte projet détectées (spécificité)"
else
  warn "Pas de référence explicite au contexte projet — livrable potentiellement générique"
fi

# Résumé
echo ""
echo "=== Résumé ==="
if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
  green "Livrable valide. 0 erreurs, 0 avertissements."
elif [ "$ERRORS" -eq 0 ]; then
  yellow "$WARNINGS avertissement(s), 0 erreur."
else
  red "$ERRORS erreur(s), $WARNINGS avertissement(s)."
fi

exit "$ERRORS"
