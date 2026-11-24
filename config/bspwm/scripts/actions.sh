#!/bin/bash
# Actions behind some keybindings. If a tool an action needs is missing, you get a notification
# that names the package, instead of a silent failure.
#
#   actions.sh lock
#   actions.sh screenshot area|full
#   actions.sh brightness up|down
#   actions.sh media play-pause|next|previous

need() {  # need <command> <hint>
  command -v "$1" >/dev/null 2>&1 && return 0
  command -v notify-send >/dev/null 2>&1 && notify-send -u low "Not installed: $1" "$2"
  return 1
}

case "$1" in
  lock)
    need i3lock "Install i3lock to use the lock shortcut." && i3lock -c 1a1b26 ;;

  screenshot)
    need maim "Install maim (and xclip to copy) for screenshots." || exit 0
    dir="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
    mkdir -p "$dir"
    file="$dir/$(date +%Y%m%d-%H%M%S).png"
    case "$2" in
      area) maim -s "$file" ;;
      full) maim "$file" ;;
      *) echo "usage: $0 screenshot area|full" >&2; exit 2 ;;
    esac || exit 1
    if command -v xclip >/dev/null 2>&1; then xclip -selection clipboard -t image/png -i "$file"; fi
    command -v notify-send >/dev/null 2>&1 && notify-send -i "$file" "Screenshot saved" "$file" ;;

  brightness)
    need brightnessctl "Install brightnessctl for the brightness keys." || exit 0
    case "$2" in
      up)   brightnessctl set +5% >/dev/null ;;
      down) brightnessctl set 5%- >/dev/null ;;
      *) echo "usage: $0 brightness up|down" >&2; exit 2 ;;
    esac ;;

  media)
    need playerctl "Install playerctl for the media keys." || exit 0
    playerctl "$2" ;;

  *)
    echo "usage: $0 lock | screenshot area|full | brightness up|down | media play-pause|next|previous" >&2
    exit 2 ;;
esac
