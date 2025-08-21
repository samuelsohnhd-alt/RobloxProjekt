#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
python3 scripts/fix_rojo_keys.py
pkill -f "rojo serve --port 34872" >/dev/null 2>&1 || true
nohup rojo serve --port 34872 >/tmp/rojo_serve.log 2>&1 & disown
echo "Rojo läuft auf :34872 (mapping gefixt)."
