#!/bin/bash
# Wallpaper picker with thumbnails. Applies via ~/.config/theme/wallpaper.sh (single wallpaper owner).
# Usage: wallpaper-picker.sh [--warm]   (--warm only builds the thumbnail cache)
DIR="${WALLPAPER_DIR:-$HOME/Pictures/wallpapers}"
CACHE="$HOME/.cache/rofi-wallpaper-thumbs-sq"
THEME="$HOME/.config/rofi/wallpaper.rasi"
mkdir -p "$CACHE"

thumb_path() { printf '%s/%s.jpg' "$CACHE" "$(printf '%s' "$1" | md5sum | cut -d' ' -f1)"; }
make_thumb() {  # rebuild only when missing or the source is newer
  local f="$1" t; t=$(thumb_path "$f")
  [ -s "$t" ] && [ "$t" -nt "$f" ] && return 0
  magick "$f[0]" -auto-orient -thumbnail 360x360^ -gravity center -extent 360x360 -quality 82 "$t" 2>/dev/null
}
export -f thumb_path make_thumb; export CACHE

mapfile -d '' files < <(find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -print0 | sort -z)
[ "${#files[@]}" -gt 0 ] || { rofi -e "No wallpapers in $DIR"; exit 1; }

printf '%s\0' "${files[@]}" | xargs -0 -P "$(nproc)" -I{} bash -c 'make_thumb "$1"' _ {}
[ "$1" = "--warm" ] && exit 0

current=$(cat "$HOME/.cache/wallpaper-current" 2>/dev/null); sel=0; i=0
for f in "${files[@]}"; do [ "$f" = "$current" ] && sel=$i; i=$((i+1)); done

idx=$(for f in "${files[@]}"; do
        n=$(basename "$f"); printf '%s\0icon\x1f%s\n' "${n%.*}" "$(thumb_path "$f")"
      done | rofi -dmenu -i -p $'' -show-icons -format i -selected-row "$sel" -theme "$THEME" -m -4)
[ -n "$idx" ] && "$HOME/.config/theme/wallpaper.sh" set "${files[$idx]}"
