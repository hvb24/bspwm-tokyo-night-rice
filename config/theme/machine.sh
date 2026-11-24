#!/bin/sh
# Per-machine detection. Sourced by bspwmrc, polybar/launch.sh and the rofi scripts.
# Any value can be overridden by exporting it before sourcing this file, e.g. in ~/.config/theme/machine.local.sh
# (machine.local.sh is sourced last if it exists and is never overwritten by the installer).

# --- monitors -----------------------------------------------------------
_connected=$(xrandr --query 2>/dev/null | awk '/ connected/{print $1}')
: "${POLYBAR_PRIMARY:=$(xrandr --query 2>/dev/null | awk '/ connected primary/{print $1; exit}')}"
[ -n "$POLYBAR_PRIMARY" ] || POLYBAR_PRIMARY=$(printf '%s\n' "$_connected" | head -1)
: "${POLYBAR_SECONDARY:=$(printf '%s\n' "$_connected" | grep -vxF "$POLYBAR_PRIMARY" | head -1)}"

# --- CPU temperature sensor (AMD: k10temp, Intel: coretemp) -----------------
if [ -z "${POLYBAR_CPU_TEMP:-}" ]; then
  for _h in /sys/class/hwmon/hwmon*; do
    [ -r "$_h/name" ] || continue
    case "$(cat "$_h/name")" in
      k10temp|coretemp|zenpower|k8temp) POLYBAR_CPU_TEMP=$(readlink -f "$_h/temp1_input"); break ;;
    esac
  done
fi
[ -n "${POLYBAR_CPU_TEMP:-}" ] || POLYBAR_CPU_TEMP=/sys/class/thermal/thermal_zone0/temp

# --- laptop hardware (left empty on desktops) --------------------------------
: "${POLYBAR_BATTERY:=$(ls /sys/class/power_supply 2>/dev/null | grep -m1 '^BAT')}"
: "${POLYBAR_ADAPTER:=$(ls /sys/class/power_supply 2>/dev/null | grep -m1 -E '^(AC|ADP|ACAD)')}"
: "${POLYBAR_BACKLIGHT:=$(ls /sys/class/backlight 2>/dev/null | head -1)}"

# --- wireless interface -------------------------------------------------------
if [ -z "${POLYBAR_WIFI:-}" ]; then
  for _i in /sys/class/net/*; do
    if [ -d "$_i/wireless" ]; then POLYBAR_WIFI=${_i##*/}; break; fi
  done
fi
: "${POLYBAR_WIFI:=wlan0}"

# --- wallpapers ----------------------------------------------------------------
: "${WALLPAPER_DIR:=$HOME/Pictures/wallpapers}"

export POLYBAR_PRIMARY POLYBAR_SECONDARY POLYBAR_CPU_TEMP POLYBAR_BATTERY POLYBAR_ADAPTER POLYBAR_BACKLIGHT POLYBAR_WIFI WALLPAPER_DIR

[ -f "$HOME/.config/theme/machine.local.sh" ] && . "$HOME/.config/theme/machine.local.sh"
