import re, os, sys
root = os.path.expanduser('~/RobloxProjekt')
p = os.path.join(root, 'src/shared/RB7/Meta/Build.lua')
s = open(p,'r',encoding='utf-8').read()
m = re.search(r'Version\s*=\s*"(\d+)\.(\d+)\.(\d+)"', s)
if not m: print("0.0.0"); sys.exit(0)
print(".".join(m.groups()))
