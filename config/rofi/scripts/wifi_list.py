#!/usr/bin/env python3
"""Reads `nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list` on stdin and prints rofi menu lines:
display<TAB>net<TAB>ssid<TAB>security<TAB>inuse   (best signal per SSID, connected first, hidden SSIDs skipped)"""
import re, sys
best = {}
for raw in sys.stdin:
    f = re.split(r"(?<!\\):", raw.rstrip("\n"))
    if len(f) < 4:
        continue
    inuse = f[0].strip()
    ssid = f[1].replace("\\:", ":")
    sig = f[2]
    sec = ":".join(f[3:]).strip()
    if not ssid:
        continue
    sig = int(sig) if sig.isdigit() else 0
    cur = best.get(ssid)
    if cur is None or inuse == "*" or (cur[0] != "*" and sig > cur[1]):
        best[ssid] = (inuse, sig, sec)
order = sorted(best.items(), key=lambda kv: (kv[1][0] != "*", -kv[1][1]))
for ssid, (inuse, sig, sec) in order:
    mark = "" if inuse == "*" else " "
    secure = bool(sec) and sec != "--"
    lock = "" if secure else " "
    print("%s  %-30s %s %3d%%\tnet\t%s\t%s\t%s" % (mark, ssid[:30], lock, sig, ssid, "secure" if secure else "", "yes" if inuse == "*" else ""))
