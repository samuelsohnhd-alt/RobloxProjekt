import json, os, sys
root = os.path.expanduser('~/RobloxProjekt')
pj   = os.path.join(root, 'default.project.json')
errors = []

def err(msg): errors.append(msg)

try:
    p = json.load(open(pj, 'r', encoding='utf-8'))
except Exception as e:
    print(f"[rojo-check] Kann default.project.json nicht lesen: {e}")
    sys.exit(2)

tree = p.get("tree", {})
if tree.get("$className") != "DataModel":
    err("Root muss $className=DataModel sein")

def get(*ks):
    cur = tree
    for k in ks:
        if not isinstance(cur, dict): return {}
        cur = cur.get(k, {})
    return cur

def has_path(d, key, expect):
    v = d.get(key, {})
    return isinstance(v, dict) and v.get("$path")==expect

# feste Mappings
if not has_path(get("ReplicatedStorage"), "Shared", "src/shared"):
    err("Mapping fehlt: src/shared -> ReplicatedStorage/Shared")
if not has_path(get("ServerScriptService"), "Server", "src/server"):
    err("Mapping fehlt: src/server -> ServerScriptService/Server")
if not has_path(get("StarterPlayer","StarterPlayerScripts"), "Client", "src/client"):
    err("Mapping fehlt: src/client -> StarterPlayer/StarterPlayerScripts/Client")
if not has_path(get("StarterGui"), "RB7_UI", "src/ui"):
    err("Mapping fehlt: src/ui -> StarterGui/RB7_UI")
if not get("ServerStorage","RB7_Private","Sec",):
    err("Mapping fehlt: src/sec -> ServerStorage/RB7_Private/Sec (Ordner/Path)")
else:
    if get("ServerStorage","RB7_Private","Sec").get("$path")!="src/sec":
        err("Mapping falsch: src/sec -> ServerStorage/RB7_Private/Sec")

# optional, wenn Ordner existieren
for opt in [("src/storage",("ServerStorage","Storage")),
            ("src/first",("ReplicatedStorage","First"))]:
    path, (svc, leaf) = opt
    if os.path.isdir(os.path.join(root, path)):
        if not has_path(get(svc), leaf, path):
            err(f"Optionales Mapping fehlt: {path} -> {svc}/{leaf}")

# Extra/* Regel: alle unbekannten src/* top-level dirs landen unter ReplicatedStorage/Extra/<Name>
src = os.path.join(root, "src")
reserved = {"shared","server","client","ui","sec","storage","first"}
if os.path.isdir(src):
    extra = get("ReplicatedStorage","Extra")
    extra_names = set(k for k,v in extra.items() if isinstance(v,dict) and v.get("$path"))
    for name in sorted(os.listdir(src)):
        if name.startswith('.'): continue
        full = os.path.join(src,name)
        if not os.path.isdir(full): continue
        if name in reserved: continue
        expect = f"src/{name}"
        if name not in extra_names:
            err(f"Auto-Mapping fehlt: {expect} -> ReplicatedStorage/Extra/{name}")

if errors:
    print("[rojo-check] FEHLER:")
    for e in errors: print(" -", e)
    sys.exit(1)
else:
    print("[rojo-check] OK")
