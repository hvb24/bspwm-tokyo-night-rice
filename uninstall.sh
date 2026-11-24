#!/bin/bash
# Reverts the last install.sh run: restores backed-up files and removes files the rice created.
# It never deletes folders and never touches files that were not created by the installer.
set -euo pipefail
STATE="${XDG_DATA_HOME:-$HOME/.local/share}/bspwm-rice"
MANIFEST="$STATE/last-install.tsv"
[ -f "$MANIFEST" ] || { echo "no install manifest at $MANIFEST, nothing to undo"; exit 1; }

while IFS=$'\t' read -r kind target backup; do
  case "$kind" in
    BACKUP) cp -p "$backup" "$target" && echo "restored  $target" ;;
    NEW)    if [ -f "$target" ]; then rm -f "$target" && echo "removed   $target"; fi ;;
  esac
done < "$MANIFEST"

# Strip the zsh block if it was added (the backup restore above already covers ~/.zshrc when present)
echo ""
echo "Done. Restart bspwm (bspc wm -r) to load your previous setup."
