#!/bin/bash
# Single owner of the wallpaper. Usage: wallpaper.sh [restore|random|set <file>]
# Collection: ~/Pictures/wallpapers. Current choice is remembered in ~/.cache/wallpaper-current
DIR="${WALLPAPER_DIR:-$HOME/Pictures/wallpapers}"
STATE="$HOME/.cache/wallpaper-current"
apply() { feh --no-fehbg --bg-fill "$1" && echo "$1" > "$STATE"; }
case "${1:-restore}" in
  random)  f=$(find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | shuf -n1); [ -n "$f" ] && apply "$f" ;;
  set)     [ -f "$2" ] && apply "$2" ;;
  restore) if [ -f "$STATE" ] && [ -f "$(cat "$STATE")" ]; then apply "$(cat "$STATE")"
           else f=$(sed -n "s/.*--bg-fill '\(.*\)'.*/\1/p" "$HOME/.fehbg" 2>/dev/null); [ -f "$f" ] && apply "$f"; fi ;;
esac
