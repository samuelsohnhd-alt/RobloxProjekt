import re, os, sys
if len(sys.argv)<2 or sys.argv[1] not in ("patch","minor","major"):
    print("usage: bump_version.py [patch|minor|major]"); sys.exit(1)
kind = sys.argv[1]
root = os.path.expanduser('~/RobloxProjekt')
p = os.path.join(root, 'src/shared/RB7/Meta/Build.lua')
s = open(p,'r',encoding='utf-8').read()
m = re.search(r'(Version\s*=\s*")(\d+)\.(\d+)\.(\d+)(")', s)
if not m: print("no Version in Build.lua"); sys.exit(2)
pre,a,b,c,post = m.groups()
a,b,c = int(a),int(b),int(c)
if kind=="patch": c+=1
elif kind=="minor": b+=1; c=0
else: a+=1; b=0; c=0
new = f'{pre}{a}.{b}.{c}{post}'
s2 = s[:m.start()] + new + s[m.end():]
open(p,'w',encoding='utf-8').write(s2)
print(f"{a}.{b}.{c}")
