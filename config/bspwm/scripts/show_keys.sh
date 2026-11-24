#!/bin/bash
# Keyboard cheat sheet (super + F1). Search with the keyboard. Enter runs the highlighted action,
# unless it changes the session (quit, close, power). Those only show what the key is.
KEYS="$HOME/.config/bspwm/scripts/keys.py"
THEME="$HOME/.config/rofi/menu.rasi"

idx=$("$KEYS" --rows | rofi -dmenu -i -format i -p "Keys" \
      -mesg "Enter runs the action when it is safe. Esc closes." \
      -theme "$THEME" -theme-str 'window { width: 1120px; } listview { lines: 20; }' -m -4)
[ -n "$idx" ] || exit 0

cmd=$("$KEYS" --cmd "$idx")
if [ -z "$cmd" ]; then
  keys=$("$KEYS" --keys "$idx")
  command -v notify-send >/dev/null && notify-send -u low "Press $keys to run this" "It changes the session, so the cheat sheet will not run it."
  exit 0
fi
( sh -c "$cmd" >/dev/null 2>&1 & )
