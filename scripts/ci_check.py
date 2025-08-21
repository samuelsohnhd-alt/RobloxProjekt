import os, sys, subprocess
root = os.path.expanduser('~/RobloxProjekt')
py = sys.executable or "/usr/bin/python3"

def run(label, args):
    print(f"[ci] {label} …")
    r = subprocess.run(args, cwd=root)
    if r.returncode != 0:
        print(f"[ci] {label} FAILED (exit {r.returncode})")
        sys.exit(r.returncode)
    print(f"[ci] {label} OK")

run("gen_remote_manifest", [py, "scripts/gen_remote_manifest.py"])
run("verify_rojo_project", [py, "scripts/verify_rojo_project.py"])
print("[ci] all checks passed")
