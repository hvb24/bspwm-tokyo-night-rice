# Changelog

## Unreleased
- Keyboard cheat sheet (super + F1) is searchable; Enter runs the highlighted action, and actions that change the session only show what the key is.
- Every binding has a description. Generated list in docs/KEYBINDINGS.md.
- Fixed: super + q (close) and super + o / i (focus history) were not expanding correctly.
- Added: lock (ctrl + alt + l), screenshots (Print, shift + Print), brightness and media keys, microphone mute, Wi-Fi and Bluetooth menus, floating terminal, move window to other monitor, force-close.
- Checks: duplicate keys and unexpanded braces fail tests/check.sh.

## 1.0.0
- First public release: bspwm + sxhkd + polybar + rofi + alacritty + picom + GTK3/Thunar, Tokyo Night palette.
- Monitors, battery, backlight, Wi-Fi and CPU sensor are detected automatically (`config/theme/machine.sh`).
- `install.sh` backs up everything it replaces; `uninstall.sh` restores it.
