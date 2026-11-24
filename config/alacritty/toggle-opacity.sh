#!/bin/sh
# Toggle terminal transparency live (uses Alacritty's IPC; ALACRITTY_SOCKET targets the calling window's process).
key=$(basename "${ALACRITTY_SOCKET:-default}")
f="${XDG_RUNTIME_DIR:-/tmp}/alacritty-opaque-$key"
if [ -e "$f" ]; then rm -f "$f"; v=0.9; else : > "$f"; v=1.0; fi
exec alacritty msg config -w -1 "window.opacity=$v"
