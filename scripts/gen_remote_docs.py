import json, os, sys
root = os.path.expanduser('~/RobloxProjekt')
manifest = os.path.join(root, 'src/shared/RB7/Meta/Remotes.json')
out_md   = os.path.join(root, 'docs/Remotes.md')

try:
    data = json.load(open(manifest, 'r', encoding='utf-8'))
except FileNotFoundError:
    print("[gen_remote_docs] Remotes.json fehlt – bitte manifest zuerst erzeugen.", file=sys.stderr)
    sys.exit(1)

ver = data.get("version") or "v?"
remotes = data.get("remotes", {})
lines = []
lines.append("# RB7 Remote Manifest")
lines.append("")
lines.append(f"_Version_: **{ver}**")
lines.append("")
lines.append("| Key | Remote Name | Full Path |")
lines.append("|-----|-------------|-----------|")
for key in sorted(remotes):
    name = remotes[key]
    full = f"ReplicatedStorage/Shared/Events/{ver}/{name}"
    lines.append(f"| `{key}` | `{name}` | `{full}` |")

new = "\n".join(lines) + "\n"
old = None
if os.path.exists(out_md):
    old = open(out_md, 'r', encoding='utf-8').read()
if old != new:
    os.makedirs(os.path.dirname(out_md), exist_ok=True)
    open(out_md, 'w', encoding='utf-8').write(new)
    print("WROTE")
else:
    print("UNCHANGED")
