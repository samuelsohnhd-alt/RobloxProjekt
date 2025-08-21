#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$PROJECT_DIR" != "/Users/a./RobloxProjekt" && "$PROJECT_DIR" != "$HOME/RobloxProjekt" ]]; then
  echo "Skript erwartet den Projektpfad /Users/a./RobloxProjekt (oder ~/RobloxProjekt). Aktueller Pfad: $PROJECT_DIR"
  echo "Abbruch."
  exit 1
fi

# Whitelist: Behalte nur diese Einträge (relative zu Projektordner)
WHITELIST=(
  "default.project.json"
  ".git"
  ".gitignore"
  ".vscode"
  ".rojo"
  "README.md"
)

echo "Folgende Einträge werden BEHALTEN:"
for e in "${WHITELIST[@]}"; do echo "  - $e"; done
echo
echo "Folgende Top-Level-Einträge im Projektordner werden GEPRÜFT und alle nicht in der Whitelist gelöscht:"
ls -1A "$PROJECT_DIR"
echo

read -p "Fortfahren und nicht-whitelistete Einträge löschen? (type 'yes' to proceed) " confirm
if [[ "$confirm" != "yes" ]]; then
  echo "Abgebrochen."
  exit 0
fi

shopt -s dotglob
for entry in "$PROJECT_DIR"/* "$PROJECT_DIR"/.*; do
  name="$(basename "$entry")"
  # skip current/parent dirs
  [[ "$name" == "." || "$name" == ".." ]] && continue
  # check if name is in whitelist
  keep=false
  for w in "${WHITELIST[@]}"; do
    if [[ "$name" == "$w" ]]; then
      keep=true
      break
    fi
  done
  if [[ "$keep" == true ]]; then
    echo "Behalte: $name"
  else
    echo "Lösche: $name"
    rm -rf -- "$entry"
  fi
done

echo "Bereinigung abgeschlossen."
