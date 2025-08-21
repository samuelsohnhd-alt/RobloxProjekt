#!/usr/bin/env python3
import json, os, sys, time

CANON = {
  "name": "RobloxProjekt",
  "tree": {
    "$className": "DataModel",
    "ServerScriptService": {
      "$className": "ServerScriptService",
      "Server": {
        "$className": "Folder",
        "src/server": { "$path": "src/server" }
      }
    },
    "ServerStorage": {
      "$className": "ServerStorage",
      "RB7_Private": {
        "$className": "Folder",
        "Sec": {
          "$className": "Folder",
          "src/sec": { "$path": "src/sec" }
        }
      },
      "Storage": {
        "$className": "Folder",
        "src/storage": { "$path": "src/storage" }
      }
    },
    "ReplicatedStorage": {
      "$className": "ReplicatedStorage",
      "Shared": {
        "$className": "Folder",
        "src/shared": { "$path": "src/shared" }
      },
      "First": {
        "$className": "Folder",
        "src/first": { "$path": "src/first" }
      }
    },
    "StarterPlayer": {
      "$className": "StarterPlayer",
      "StarterPlayerScripts": {
        "$className": "StarterPlayerScripts",
        "Client": {
          "$className": "Folder",
          "src/client": { "$path": "src/client" }
        }
      }
    },
    "StarterGui": {
      "$className": "StarterGui",
      "RB7_UI": {
        "$className": "Folder",
        "src/ui": { "$path": "src/ui" }
      }
    }
  }
}

FILES = ["default.project.json","project.json","rbx.project.json","rojo.project.json"]

def write_if_diff(path, obj):
    new = json.dumps(obj, indent=2, ensure_ascii=False) + "\n"
    old = None
    try:
        with open(path, "r", encoding="utf-8") as f:
            old = f.read()
    except FileNotFoundError:
        pass
    if old != new:
        with open(path, "w", encoding="utf-8") as f:
            f.write(new)
        return True
    return False

def ensure_dirs():
    for d in ["src/server","src/client","src/shared","src/ui","src/sec","src/storage","src/first"]:
        os.makedirs(d, exist_ok=True)
    # leichte Platzhalter, aber nur wenn leer
    placeholders = {
        "src/server/Init.server.lua": 'print("RB7: Server boot ok")\n',
        "src/client/Init.client.lua": 'print("RB7: Client boot ok")\n',
        "src/shared/Types.lua":      '-- shared types placeholder\n',
        "src/ui/README.md":          '# RB7_UI\n',
        "src/sec/README.md":         '# RB7_Private/Sec\n',
        "src/storage/.keep":         '',
        "src/first/.keep":           ''
    }
    for p,content in placeholders.items():
        if not os.path.exists(p):
            with open(p,"w",encoding="utf-8") as f:
                f.write(content)

def main():
    ensure_dirs()
    changed_any = False
    for f in FILES:
        if write_if_diff(f, CANON):
            changed_any = True
    # Touch-File für Hooks, damit diffs erkannt werden
    if changed_any:
        with open(".rojo-ci-touch","w") as f:
            f.write(str(int(time.time()))+"\n")
    print("CHANGED" if changed_any else "UNCHANGED")

if __name__ == "__main__":
    sys.exit(main())
