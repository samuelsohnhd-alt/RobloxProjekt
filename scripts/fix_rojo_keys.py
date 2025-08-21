#!/usr/bin/env python3
import json, os, sys
PATH = "default.project.json"

def load():
    if not os.path.exists(PATH):
        return {"name":"RobloxProjekt","servePort":34872,"tree":{"$className":"DataModel"}}
    with open(PATH,"r",encoding="utf-8") as f:
        return json.load(f)

def cap(name:str)->str:
    # Titel-Fall für bekannte Mappings
    m = {
        "src/client":"Client",
        "client":"Client",
        "src/server":"Server",
        "server":"Server",
        "src/shared":"Shared",
        "shared":"Shared",
    }
    return m.get(name.lower(), name.replace("/", "_").replace("\\","_"))

def fix_tree(node):
    if isinstance(node, dict):
        # $path-basierte Normalisierung von Schlüssel-Namen
        new = {}
        # erst Keys sammeln, dann ggf. umbenennen
        for k,v in node.items():
            if k.startswith("$"):
                new[k] = v
                continue
            fixed_v = fix_tree(v)
            newk = k
            # Wenn Key enthält Slash oder wie "src/client" aussieht: anhand $path normalisieren
            if ("/" in k or "\\" in k) or k.lower() in ("src/client","src/server","src/shared"):
                # heuristik: wenn Kind ein $path hat, nutze dessen letzte Komponente
                last = None
                if isinstance(fixed_v, dict) and "$path" in fixed_v and isinstance(fixed_v["$path"], str):
                    p = fixed_v["$path"].strip("/\\")
                    last = p.lower()
                    if last in ("src/client","src/server","src/shared"):
                        newk = cap(last)
                    else:
                        # nimm letzten Segmentnamen
                        seg = p.replace("\\","/").split("/")[-1]
                        newk = cap(seg)
                else:
                    newk = cap(k)
            # Kollisionen vermeiden: wenn Key schon existiert und beide sind dicts, merge
            if newk in new and isinstance(new[newk], dict) and isinstance(fixed_v, dict):
                # flaches Merge, $path aus fixed_v gewinnt
                merged = dict(new[newk])
                merged.update(fixed_v)
                new[newk] = merged
            else:
                new[newk] = fixed_v
        return new
    elif isinstance(node, list):
        return [fix_tree(x) for x in node]
    else:
        return node

def ensure_core_mappings(tree):
    # Stelle sicher, dass die drei Kern-Pfade korrekt sitzen
    # ServerScriptService.Server -> src/server
    sss = tree.setdefault("ServerScriptService", {"$className":"ServerScriptService"})
    if "$className" not in sss: sss["$className"] = "ServerScriptService"
    sss["Server"] = {"$path":"src/server"}

    # ReplicatedStorage.Shared -> src/shared
    rs = tree.setdefault("ReplicatedStorage", {"$className":"ReplicatedStorage"})
    if "$className" not in rs: rs["$className"] = "ReplicatedStorage"
    rs["Shared"] = {"$path":"src/shared"}
    # RB7_Meta optional lassen, nicht anfassen wenn vorhanden

    # StarterPlayer/StarterPlayerScripts/Client -> src/client
    sp = tree.setdefault("StarterPlayer", {"$className":"StarterPlayer"})
    if "$className" not in sp: sp["$className"] = "StarterPlayer"
    sps = sp.setdefault("StarterPlayerScripts", {"$className":"StarterPlayerScripts"})
    if "$className" not in sps: sps["$className"] = "StarterPlayerScripts"
    sps["Client"] = {"$path":"src/client"}

    # ServerStorage.RB7_Private -> src/sec
    ss = tree.setdefault("ServerStorage", {"$className":"ServerStorage"})
    if "$className" not in ss: ss["$className"] = "ServerStorage"
    ss.setdefault("RB7_Private", {"$path":"src/sec"})

def main():
    data = load()
    if "tree" not in data or not isinstance(data["tree"], dict):
        data["tree"] = {"$className":"DataModel"}
    # Schritt 1: alle Keys bereinigen
    data["tree"] = fix_tree(data["tree"])
    # Schritt 2: Kern-Mappings erzwingen
    ensure_core_mappings(data["tree"])
    # Schritt 3: servePort sicherstellen
    data["servePort"] = 34872

    with open(PATH,"w",encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    print("✅ default.project.json normalisiert.")

if __name__ == "__main__":
    main()
