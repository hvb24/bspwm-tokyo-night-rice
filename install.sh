#!/bin/bash
# Installs the rice into ~/.config (and ~/.themes for the GTK theme).
#
#   ./install.sh              install; existing files are backed up first
#   ./install.sh --dry-run    show what would happen, change nothing
#   ./install.sh --zsh        also source the shell additions from ~/.zshrc
#
# Nothing is deleted. Every replaced file is copied to a backup folder, and uninstall.sh restores them.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE="${XDG_DATA_HOME:-$HOME/.local/share}/bspwm-rice"
TS=$(date +%Y%m%d-%H%M%S)
BK="$STATE/backups/$TS"
MANIFEST="$STATE/last-install.tsv"
DRY=0; ZSH=0

usage() { sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; }
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY=1 ;;
    --zsh)     ZSH=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown option: $arg" >&2; usage; exit 2 ;;
  esac
done

say()  { printf '%s\n' "$*"; }
run()  { if [ "$DRY" -eq 1 ]; then say "  would: $*"; else "$@"; fi; }
[ "$DRY" -eq 1 ] || { mkdir -p "$STATE"; : > "$MANIFEST.new"; }

say "== bspwm-tokyo-night-rice: install from $REPO"
[ "$DRY" -eq 1 ] && say "   (dry run, nothing will be changed)"

# ---- 1. copy config/ into ~/.config, backing up anything it replaces ----------
while IFS= read -r src; do
  rel="${src#"$REPO/config/"}"
  dst="$HOME/.config/$rel"
  if [ -e "$dst" ]; then
    say "  backup + replace  ~/.config/$rel"
    if [ "$DRY" -eq 0 ]; then
      mkdir -p "$BK/$(dirname "$rel")"; cp -p "$dst" "$BK/$rel"
      printf 'BACKUP\t%s\t%s\n' "$dst" "$BK/$rel" >> "$MANIFEST.new"
    fi
  else
    say "  new               ~/.config/$rel"
    [ "$DRY" -eq 0 ] && printf 'NEW\t%s\t\n' "$dst" >> "$MANIFEST.new"
  fi
  run mkdir -p "$(dirname "$dst")"
  run cp -p "$src" "$dst"
done < <(find "$REPO/config" -type f | sort)

# ---- 2. optional: shell additions in ~/.zshrc (backed up, one guarded line) ----
if [ "$ZSH" -eq 1 ]; then
  ZRC="$HOME/.zshrc"; MARK="# >>> bspwm-tokyo-night-rice >>>"
  if [ -f "$ZRC" ] && grep -qF "$MARK" "$ZRC"; then
    say "  zshrc already has the rice block, leaving it alone"
  else
    say "  zshrc             append guarded source of ~/.config/rice/rice.zsh"
    if [ "$DRY" -eq 0 ]; then
      touch "$ZRC"; mkdir -p "$BK"; cp -p "$ZRC" "$BK/zshrc"
      printf 'BACKUP\t%s\t%s\n' "$ZRC" "$BK/zshrc" >> "$MANIFEST.new"
      printf '\n%s\n[ -f "$HOME/.config/rice/rice.zsh" ] && source "$HOME/.config/rice/rice.zsh"\n# <<< bspwm-tokyo-night-rice <<<\n' "$MARK" >> "$ZRC"
    fi
  fi
fi

# ---- 3. generate colour files from theme/palette.sh ----------------------------
GENERATED=(
  "$HOME/.config/polybar/colors.ini"
  "$HOME/.config/alacritty/theme.toml"
  "$HOME/.config/rofi/colors.rasi"
  "$HOME/.config/dunst/dunstrc"
  "$HOME/.config/gtk-4.0/tokyonight.css"
  "$HOME/.themes/TokyoNight/index.theme"
  "$HOME/.themes/TokyoNight/gtk-3.0/gtk.css"
)
say "  generate          colours from theme/palette.sh"
if [ "$DRY" -eq 0 ]; then
  for g in "${GENERATED[@]}"; do
    if [ ! -e "$g" ]; then printf 'NEW\t%s\t\n' "$g" >> "$MANIFEST.new"; fi
  done
  "$HOME/.config/theme/apply.sh"
  mv "$MANIFEST.new" "$MANIFEST"
  say "  manifest          $MANIFEST"
  [ -d "$BK" ] && say "  backups           $BK"
else
  rm -f "$MANIFEST.new"
fi

# ---- 4. report missing packages (this script never installs packages) -------
say ""
say "== checking packages (install missing ones yourself; names are for Arch Linux)"
check() { command -v "$1" >/dev/null 2>&1 && say "  ok       $1" || say "  MISSING  $1  ($2)"; }
check bspc      "bspwm"
check sxhkd     "sxhkd"
check polybar   "polybar"
check picom     "picom"
check rofi      "rofi"
check alacritty "alacritty"
check feh       "feh - optional fallback"
check xrandr    "xorg-xrandr"
check magick    "imagemagick - rofi wallpaper thumbnails"
check nmcli     "networkmanager - Wi-Fi menu"
check bluetoothctl "bluez-utils - Bluetooth menu"
check starship  "starship - optional prompt"
check zoxide    "zoxide - optional"
check eza       "eza - optional"
say ""
say "Done. Restart bspwm (bspc wm -r) or log out and back in to start the rice."
say "Undo everything with: $REPO/uninstall.sh"
