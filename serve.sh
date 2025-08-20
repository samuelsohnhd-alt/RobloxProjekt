#!/bin/bash
# Auto-Serve Script für Rojo

cd ~/RobloxProjekt || exit 1

# Start bei Standardport
PORT=34872

# Solange Port belegt ist, erhöhe um 1
while lsof -i :$PORT >/dev/null 2>&1; do
  echo "⚠️  Port $PORT belegt, versuche nächsten..."
  PORT=$((PORT+1))
done

echo "✅ Starte Rojo auf Port $PORT"
rojo serve --port $PORT

