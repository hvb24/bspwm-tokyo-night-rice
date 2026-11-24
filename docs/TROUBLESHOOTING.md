# Troubleshooting

**Bars missing on a monitor.** `launch.sh` starts one bar per monitor that `xrandr` reports as connected.
Check `xrandr --query` and `~/.cache/polybar/*.log`. Force names with `~/.config/theme/machine.local.sh`:

    export POLYBAR_PRIMARY=DP-1
    export POLYBAR_SECONDARY=HDMI-1

**A module shows an error.** Battery, backlight and Wi-Fi are optional. On a desktop, remove
`battery` and `backlight` from `modules-right` in `config/polybar/config.ini`, or set the device
name in `machine.local.sh`. Find names with `ls /sys/class/power_supply`, `ls /sys/class/backlight`,
`ls /sys/class/net`.

**Wrong CPU temperature.** Set `POLYBAR_CPU_TEMP` to the file under `/sys/class/hwmon/*/temp1_input`
for your sensor (`cat /sys/class/hwmon/hwmon*/name` shows which one).

**Icons show as boxes.** Install a Nerd Font (`ttf-firacode-nerd`) and restart polybar.

**Colours did not change after editing `palette.sh`.** Run `~/.config/theme/apply.sh`, then
`~/.config/polybar/launch.sh` and `rofi` will pick up the new values on next open.

**Wallpaper folder.** Put images in `~/Pictures/wallpapers`, or set `WALLPAPER_DIR` in `machine.local.sh`.

**Undo.** `~/bspwm-tokyo-night-rice/uninstall.sh` (or wherever you cloned it) restores every file the
installer replaced and removes the ones it created.
