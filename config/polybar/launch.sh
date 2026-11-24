#!/bin/bash
# (Re)start polybar: one bar per connected monitor. Safe to run repeatedly.
. "$HOME/.config/theme/machine.sh"
LOGDIR="$HOME/.cache/polybar"; mkdir -p "$LOGDIR"

polybar-msg cmd quit >/dev/null 2>&1
sleep 0.3; killall -q polybar
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 0.2; done

start() {  # $1 = bar name in config.ini, $2 = monitor (empty = not connected)
  [ -n "$2" ] || return 0
  polybar --reload "$1" >>"$LOGDIR/$1.log" 2>&1 & disown
}
start primary "$POLYBAR_PRIMARY"
start secondary "$POLYBAR_SECONDARY"
exit 0
