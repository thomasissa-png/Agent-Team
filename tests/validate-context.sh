#!/usr/bin/env bash
# Gradient Agents — Project Context Validation
# Vérifie qu'un project-context.md est correctement rempli.
# Usage: bash tests/validate-context.sh [chemin-vers-project-context.md]

set -euo pipefail

CONTEXT="${1:-./project-context.md}"
ERRORS=0
WARNINGS=0

red()    { printf "\033[31m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
green()  { printf "\033[32m%s\033[0m\n" "$1"; }

err()  { red  "[VIDE] $1"; ERRORS=$((ERRORS + 1)); }
warn() { yellow "[PARTIEL] $1"; WARNINGS=$((WARNINGS + 1)); }
ok()   { green "[OK] $1"; }

if [ ! -f "$CONTEXT" ]; then
  red "Fichier $CONTEXT introuvable."
  exit 1
fi

echo "=== Validation de $CONTEXT ==="
echo ""

# Champs critiques (bloquants pour la plupart des agents)
CRITICAL_FIELDS=(
  "Nom du projet"
  "Secteur"
  "Persona principal"
  "Problème principal"
  "Promesse unique"
  "Objectif principal à 6 mois"
  "KPI North Star"
)

# Champs importants (non bloquants mais recommandés)
IMPORTANT_FIELDS=(
  "Stade"
  "Ton de marque"
  "Concurrent principal"
  "Frontend"
  "Hébergement"
  "Modèle économique"
  "Budget mensuel infrastructure"
  "Timeline de lancement"
  "Ressources disponibles"
)

echo "--- Champs critiques (bloquants) ---"
for field in "${CRITICAL_FIELDS[@]}"; do
  LINE=$(grep -n "\\*\\*$field\\*\\*" "$CONTEXT" 2>/dev/null | head -1 || true)
  if [ -z "$LINE" ]; then
    err "$field : champ absent du fichier"
    continue
  fi
  # Extract value after the colon
  VALUE=$(echo "$LINE" | sed "s/.*\\*\\*$field\\*\\* *: *//" | sed 's/^ *//' | sed 's/ *$//')
  if [ -z "$VALUE" ] || echo "$VALUE" | grep -qP '^\[.*\]$'; then
    err "$field : non rempli"
  else
    ok "$field"
  fi
done

echo ""
echo "--- Champs importants (recommandés) ---"
for field in "${IMPORTANT_FIELDS[@]}"; do
  LINE=$(grep -n "\\*\\*$field\\*\\*" "$CONTEXT" 2>/dev/null | head -1 || true)
  if [ -z "$LINE" ]; then
    warn "$field : champ absent"
    continue
  fi
  VALUE=$(echo "$LINE" | sed "s/.*\\*\\*$field\\*\\* *: *//" | sed 's/^ *//' | sed 's/ *$//')
  if [ -z "$VALUE" ] || echo "$VALUE" | grep -qP '^\[.*\]$'; then
    warn "$field : non rempli"
  else
    ok "$field"
  fi
done

# Vérifier la date de mise à jour
echo ""
echo "--- Métadonnées ---"
if grep -q "Dernière mise à jour" "$CONTEXT"; then
  DATE_VAL=$(grep "Dernière mise à jour" "$CONTEXT" | sed 's/.*: *//')
  if echo "$DATE_VAL" | grep -q '\[DATE\]'; then
    warn "Date de mise à jour non renseignée"
  else
    ok "Date de mise à jour : $DATE_VAL"
  fi
fi

# Résumé
echo ""
echo "=== Résumé ==="
if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
  green "Context complet. Tous les champs sont remplis."
elif [ "$ERRORS" -eq 0 ]; then
  yellow "$WARNINGS champ(s) recommandé(s) manquant(s), mais les champs critiques sont OK."
else
  red "$ERRORS champ(s) critique(s) vide(s). Les agents refuseront de travailler."
  echo "Remplis les champs critiques avant d'invoquer un agent."
fi

exit "$ERRORS"
