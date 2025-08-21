#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.."; pwd)"
cd "$root"

# Checks
python3 scripts/gen_remote_manifest.py
python3 scripts/verify_rojo_project.py

# Version + Zeitstempel
ver="$(python3 scripts/extract_version.py)"
ts="$(date +%Y%m%d-%H%M%S)"

# Artefakte
mkdir -p build
# Place bauen (DataModel aus default.project.json)
rojo build --output "build/RB7-${ver}-${ts}.rbxlx"

echo "Built: build/RB7-${ver}-${ts}.rbxlx"
