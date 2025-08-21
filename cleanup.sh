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
  "serve.sh"
  "cleanup.sh"
)

print_report() {
  cat <<EOF
Report (basierend auf dem Sitzungsverlauf):

1) Minimal benötigte Dateien/Ordner für Rojo / VS / GitHub (empfohlen BEHALTEN):
  - default.project.json        (Rojo-Projektmapping)
  - .git/                      (Repository)
  - .gitignore                 (Git-Ausnahmen)
  - .vscode/                   (optional: VSCode-Einstellungen)
  - .rojo/                     (optional: Rojo Metadaten)
  - cleanup.sh                 (Bereinigung & Reporting)
  - serve.sh                   (Hilfsskript zum Starten von 'rojo serve')
  - README.md                  (Projektbeschreibung, optional)

2) Einträge, die laut diesem Chat ZUR INITIALISIERUNG im Projekt vorhanden waren:
  - default.project.json  (mit src/ Pfaden: src/server, src/shared, src/client, src/sec)
  - src/                  (enthielt server/, shared/, client/, sec/ - deine Roblox-Scripts/Assets)
  - start-project.sh.save (Startskript, war vorhanden)
  - serve.sh              (Skript zum Starten von Rojo)

3) Dateien/Ordner, die du NICHT brauchst oder die du entfernen wolltest:
  - src/ (komplett)      -> alle Unterordner server/, shared/, client/, sec/ entfernen, wenn du nur Rojo/VCS behalten willst
  - build/output rbxlx etc. (game.rbxlx) -> Generated builds können entfernt werden
  - node_modules/, dist/, temp/ -> falls vorhanden
  - große Assets / alte Backups / export-Ordner -> falls nicht benötigt

4) Dateien, die NACHTRÄGLICH im Gespräch/bei Bereinigung hinzugefügt wurden:
  - cleanup.sh  (wurde von diesem Skript/Assistenz angelegt)
  - .gitignore  (minimal angelegt)

Hinweis: Diese Aufstellung basiert auf dem Verlauf dieser Sitzung und auf den Dateinamen, die im Projektverlauf sichtbar waren. Führe zum Prüfen:
  - ./cleanup.sh --report     (zeigt diesen Report)
  - ./cleanup.sh              (führt interaktive Bereinigung aus)
EOF
}

# If user asked for reporting, just show report and exit
if [[ "${1:-}" == "--report" ]]; then
  print_report
  exit 0
fi

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