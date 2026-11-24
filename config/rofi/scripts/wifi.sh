#!/bin/bash
# Rofi Wi-Fi menu (NetworkManager). Usage: wifi.sh | wifi.sh --list
THEME="$HOME/.config/rofi/menu.rasi"
dev=$(nmcli -t -f DEVICE,TYPE dev | awk -F: '$2=="wifi"{print $1; exit}')
notify() { command -v notify-send >/dev/null && notify-send -a Wi-Fi "$1" "$2"; }

# lines: "display<TAB>action<TAB>ssid<TAB>security<TAB>inuse"
lines() {
  if [ "$(nmcli radio wifi)" != enabled ]; then printf '%s\ttoggle\t\t\t\n' "  Turn Wi-Fi on"; return; fi
  printf '%s\ttoggle\t\t\t\n' "  Turn Wi-Fi off"
  nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list --rescan auto 2>/dev/null | "$HOME/.config/rofi/scripts/wifi_list.py"
  printf '%s\tedit\t\t\t\n' "  Advanced settings..."
}

[ "$1" = "--list" ] && { lines; exit 0; }

mapfile -t L < <(lines)
disp=(); for l in "${L[@]}"; do disp+=("${l%%$'\t'*}"); done
cur=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | sed -n 's/^yes://p' | head -1)
mesg="Wi-Fi"; [ -n "$cur" ] && mesg="Connected: $cur"
idx=$(printf '%s\n' "${disp[@]}" | rofi -dmenu -i -no-custom -p "" -mesg "$mesg" -format i -theme "$THEME" -theme-str "window { width: 480px; }" -m -4)
[ -z "$idx" ] && exit 0
IFS=$'\t' read -r _ act ssid sec inuse <<< "${L[$idx]}"
case "$act" in
  toggle) if [ "$(nmcli radio wifi)" = enabled ]; then nmcli radio wifi off; else nmcli radio wifi on; fi ;;
  edit)   exec nm-connection-editor ;;
  net)
    if [ -n "$inuse" ]; then nmcli device disconnect "$dev" >/dev/null && notify "Wi-Fi" "Disconnected from $ssid"
    elif nmcli -t -f NAME connection show | grep -Fxq "$ssid"; then
      notify "Wi-Fi" "Connecting to $ssid..."
      nmcli --wait 20 connection up id "$ssid" >/dev/null 2>&1 && notify "Wi-Fi" "Connected to $ssid" || notify "Wi-Fi" "Could not connect to $ssid"
    elif [ -z "$sec" ]; then
      nmcli --wait 20 device wifi connect "$ssid" >/dev/null 2>&1 && notify "Wi-Fi" "Connected to $ssid" || notify "Wi-Fi" "Could not connect to $ssid"
    else
      pw=$(rofi -dmenu -password -p "" -mesg "Password for $ssid" -theme "$THEME" -m -4 </dev/null)
      [ -z "$pw" ] && exit 0
      # --ask reads the password from stdin, so it never appears in the process list
      printf '%s\n' "$pw" | nmcli --ask --wait 25 device wifi connect "$ssid" >/dev/null 2>&1 \
        && notify "Wi-Fi" "Connected to $ssid" || notify "Wi-Fi" "Could not connect to $ssid (wrong password?)"
    fi ;;
esac
