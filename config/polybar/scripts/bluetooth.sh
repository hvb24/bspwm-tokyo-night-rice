#!/bin/bash
# Bluetooth for polybar + rofi.  Usage: bluetooth.sh status | menu | toggle | list
. "$HOME/.config/theme/palette.sh"
ICON=""
THEME="$HOME/.config/rofi/menu.rasi"
notify() { command -v notify-send >/dev/null && notify-send -a Bluetooth "$1" "$2"; }
powered() { bluetoothctl show 2>/dev/null | awk '/Powered:/{print $2}'; }
connected_names() { bluetoothctl devices Connected 2>/dev/null | sed -n 's/^Device [0-9A-F:]* //p'; }

status() {
  p=$(powered); [ -z "$p" ] && exit 0                      # no controller: show nothing
  if [ "$p" != yes ]; then printf '%%{T3}%%{F#%s}%s%%{F-}%%{T-}' "$FG_MUTED" "$ICON"; exit 0; fi
  names=$(connected_names); n=$(printf '%s' "$names" | grep -c .)
  if [ "$n" -gt 0 ]; then
    first=$(printf '%s\n' "$names" | head -1 | cut -c1-16); extra=""; [ "$n" -gt 1 ] && extra=" +$((n-1))"
    printf '%%{T3}%%{F#%s}%s%%{F-}%%{T-} %s%s' "$CYAN" "$ICON" "$first" "$extra"
  else printf '%%{T3}%%{F#%s}%s%%{F-}%%{T-}' "$BLUE" "$ICON"; fi
}

toggle() {
  if [ "$(powered)" = yes ]; then bluetoothctl power off >/dev/null && notify "Bluetooth" "Turned off"
  else bluetoothctl power on >/dev/null && notify "Bluetooth" "Turned on"; fi
}

# menu lines: "display<TAB>action<TAB>mac"
lines() {
  if [ "$(powered)" = yes ]; then printf '%s\ttoggle\t\n' "  Turn Bluetooth off"
  else printf '%s\ttoggle\t\n' "  Turn Bluetooth on"; return; fi
  bluetoothctl devices Paired 2>/dev/null | sed -n 's/^Device \([0-9A-F:]*\) \(.*\)$/\1\t\2/p' | while IFS=$'\t' read -r mac name; do
    if bluetoothctl info "$mac" 2>/dev/null | grep -q 'Connected: yes'; then printf '%s\tdisconnect\t%s\n' "  $name" "$mac"
    else printf '%s\tconnect\t%s\n' "   $name" "$mac"; fi
  done
  printf '%s\tblueman\t\n' "  Pair new device..."
}

menu() {
  mapfile -t L < <(lines)
  disp=(); for l in "${L[@]}"; do disp+=("${l%%$'\t'*}"); done
  idx=$(printf '%s\n' "${disp[@]}" | rofi -dmenu -i -no-custom -p "" -mesg "Bluetooth" -format i -theme "$THEME" -theme-str "window { width: 480px; }" -m -4)
  [ -z "$idx" ] && exit 0
  IFS=$'\t' read -r _ act mac <<< "${L[$idx]}"
  name=$(bluetoothctl info "$mac" 2>/dev/null | sed -n 's/^\s*Name: //p')
  case "$act" in
    toggle)     toggle ;;
    connect)    notify "Bluetooth" "Connecting to $name..."; timeout 20 bluetoothctl connect "$mac" >/dev/null 2>&1 && notify "Bluetooth" "Connected: $name" || notify "Bluetooth" "Could not connect to $name" ;;
    disconnect) bluetoothctl disconnect "$mac" >/dev/null 2>&1; notify "Bluetooth" "Disconnected: $name" ;;
    blueman)    exec blueman-manager ;;
  esac
}

case "$1" in status) status ;; toggle) toggle ;; list) lines ;; menu|"") menu ;; esac
