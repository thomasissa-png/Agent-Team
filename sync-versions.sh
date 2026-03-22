#!/usr/bin/env bash
# sync-versions.sh — Synchronise les versions des agents .md vers index.html
# Usage : ./sync-versions.sh
# Appelé automatiquement par le pre-commit hook ou manuellement

set -euo pipefail

AGENTS_DIR=".claude/agents"
INDEX_FILE="index.html"

if [[ ! -f "$INDEX_FILE" ]]; then
  echo "Erreur : $INDEX_FILE introuvable. Exécuter depuis la racine du repo."
  exit 1
fi

changed=0

for md_file in "$AGENTS_DIR"/*.md; do
  filename=$(basename "$md_file" .md)

  # Skip base protocol (not an agent)
  [[ "$filename" == "_base-agent-protocol" ]] && continue

  # Extract version from YAML frontmatter
  version=$(grep -m1 '^version:' "$md_file" 2>/dev/null | sed 's/version: *"\{0,1\}\([^"]*\)"\{0,1\}/\1/' || true)
  [[ -z "$version" ]] && continue

  # Update version in index.html AGENTS array
  # Match: id:"agent-name", ... version:"X.Y"
  current=$(grep -oP "id:\"${filename}\"[^}]*version:\"\K[^\"]*" "$INDEX_FILE" 2>/dev/null || true)

  if [[ -n "$current" && "$current" != "$version" ]]; then
    # Replace the version value for this specific agent
    sed -i "s/\(id:\"${filename}\"[^}]*version:\"\)[^\"]*/\1${version}/" "$INDEX_FILE"
    echo "  Mis à jour : @${filename} v${current} → v${version}"
    changed=$((changed + 1))
  elif [[ -z "$current" ]]; then
    echo "  Attention : @${filename} n'a pas de champ version dans $INDEX_FILE"
  fi
done

if [[ $changed -gt 0 ]]; then
  echo "✓ ${changed} version(s) synchronisée(s) dans $INDEX_FILE"
  # Re-stage index.html if we're in a git commit context
  if git rev-parse --git-dir > /dev/null 2>&1; then
    git add "$INDEX_FILE" 2>/dev/null || true
  fi
else
  echo "✓ Toutes les versions sont déjà synchronisées"
fi
