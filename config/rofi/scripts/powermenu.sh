#!/bin/bash
# Power menu. Destructive actions ask for confirmation. DRY=1 prints the action instead of running it.
THEME="$HOME/.config/rofi/menu.rasi"
run() { if [ -n "${DRY:-}" ]; then echo "DRY: $*"; else "$@"; fi; }

lock=$'  Lock';  suspend=$'  Suspend'; logout=$'  Log out'
reboot=$'  Reboot'; shutdown=$'  Shut down'

opts=()
command -v i3lock >/dev/null && opts+=("$lock")      # only offered when a locker is installed
opts+=("$suspend" "$logout" "$reboot" "$shutdown")

menu()    { rofi -dmenu -i -no-custom -p "" -mesg "$1" -theme "$THEME" -m -4; }
confirm() { [ "$(printf 'No\nYes\n' | menu "$1")" = "Yes" ]; }

choice=$(printf '%s\n' "${opts[@]}" | menu "up $(uptime -p | sed 's/^up //')")
case "$choice" in
  "$lock")     run i3lock -c 1a1b26 ;;
  "$suspend")  run systemctl suspend ;;
  "$logout")   confirm "Log out of bspwm?" && run bspc quit ;;
  "$reboot")   confirm "Reboot now?"       && run systemctl reboot ;;
  "$shutdown") confirm "Shut down now?"    && run systemctl poweroff ;;
esac
