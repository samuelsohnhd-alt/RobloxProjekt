import re, json, os, sys
root = os.path.expanduser('~/RobloxProjekt')
events_path = os.path.join(root, 'src/shared/RB7/Constants/Events.lua')
out_path    = os.path.join(root, 'src/shared/RB7/Meta/Remotes.json')

pat = re.compile(r'^\s*([A-Z0-9_]+)\s*=\s*"([^"]+)"\s*,?\s*$', re.M)
data = {"version": None, "remotes": {}}

try:
    with open(events_path, 'r', encoding='utf-8') as f:
        s = f.read()
except FileNotFoundError:
    print("[gen_remote_manifest] Events.lua nicht gefunden", file=sys.stderr)
    sys.exit(1)

# VERSION separat extrahieren
mver = re.search(r'VERSION\s*=\s*"([^"]+)"', s)
if mver:
    data["version"] = mver.group(1)

for key, val in pat.findall(s):
    if key in ("ROOT", "VERSION"):
        continue
    data["remotes"][key] = val

new = json.dumps(data, indent=2, ensure_ascii=False) + "\n"
old = None
if os.path.exists(out_path):
    with open(out_path, 'r', encoding='utf-8') as f:
        old = f.read()

if old != new:
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(new)
    print("WROTE")
else:
    print("UNCHANGED")
