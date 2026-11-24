# Keybindings

Generated from `config/sxhkd/sxhkdrc` by `config/bspwm/scripts/keys.py --markdown`. Press `super + F1` in the rice to browse them and run actions.

## General

| Keys | Action |
|---|---|
| `Super + Enter` | Open a terminal (Alacritty) |
| `Super + @space` | Launcher: apps first. Ctrl+Tab switches to windows, commands or files |
| `Super + F1` | Keyboard cheat sheet (this list). Enter on a row runs its action when it is safe |
| `Super + Esc` | Reload this file after editing it |
| `Ctrl + Alt + L` | Lock the screen (needs i3lock) |
| `Super + Shift + Q` | Power menu: suspend, log out, reboot or shut down (confirms first) |
| `Super + Shift + Enter` | Floating terminal, centred, for quick commands |

## Apps

| Keys | Action |
|---|---|
| `Super + E` | File manager (Thunar) |
| `Super + Shift + B` | Web browser (Firefox) |
| `Super + Shift + D` | Code editor (VS Code) |
| `Super + Shift + Space` | Run a shell command |
| `Super + Shift + F` | File browser |
| `Alt + Tab` | Window switcher (windows only) |
| `Super + Shift + A` | Fullscreen app grid (Launchpad style) |
| `Super + Ctrl + N` | Wi-Fi menu: join or leave a network (needs NetworkManager) |
| `Super + Ctrl + B` | Bluetooth menu: connect or disconnect paired devices (needs bluez) |

## Windows (bspwm)

| Keys | Action |
|---|---|
| `Super + Q` | Close the focused window |
| `Super + Alt + X` | Force-close the focused window (may lose unsaved work) |
| `Super + M` | Toggle monocle layout (one window fills the desktop) |
| `Super + T` | Tiled, pseudo-tiled, floating or fullscreen for the focused window   [bspc node -t tiled] |
| `Super + Shift + T` | Tiled, pseudo-tiled, floating or fullscreen for the focused window   [bspc node -t pseudo_tiled] |
| `Super + S` | Tiled, pseudo-tiled, floating or fullscreen for the focused window   [bspc node -t floating] |
| `Super + F` | Tiled, pseudo-tiled, floating or fullscreen for the focused window   [bspc node -t fullscreen] |
| `Super + Ctrl + M` | Mark, lock, make sticky or make private the focused window   [bspc node -g marked] |
| `Super + Ctrl + X` | Mark, lock, make sticky or make private the focused window   [bspc node -g locked] |
| `Super + Ctrl + Y` | Mark, lock, make sticky or make private the focused window   [bspc node -g sticky] |
| `Super + Ctrl + Z` | Mark, lock, make sticky or make private the focused window   [bspc node -g private] |
| `Super + Y` | Send the marked window into the preselected spot |
| `Super + G` | Swap the focused window with the biggest window |
| `Super + Shift + Left` | Move the focused window to the other monitor   [bspc node -m prev --follow] |
| `Super + Shift + Right` | Move the focused window to the other monitor   [bspc node -m next --follow] |
| `Super + H` | Focus a window in a direction (with shift: swap it instead)   [bspc node -f west] |
| `Super + J` | Focus a window in a direction (with shift: swap it instead)   [bspc node -f south] |
| `Super + K` | Focus a window in a direction (with shift: swap it instead)   [bspc node -f north] |
| `Super + L` | Focus a window in a direction (with shift: swap it instead)   [bspc node -f east] |
| `Super + Shift + H` | Focus a window in a direction (with shift: swap it instead)   [bspc node -s west] |
| `Super + Shift + J` | Focus a window in a direction (with shift: swap it instead)   [bspc node -s south] |
| `Super + Shift + K` | Focus a window in a direction (with shift: swap it instead)   [bspc node -s north] |
| `Super + Shift + L` | Focus a window in a direction (with shift: swap it instead)   [bspc node -s east] |
| `Super + C` | Focus next or previous window (with shift: previous)   [bspc node -f next.local.!hidden.window] |
| `Super + Shift + C` | Focus next or previous window (with shift: previous)   [bspc node -f prev.local.!hidden.window] |
| `Super + P` | Focus the parent, brother, first or second window   [bspc node -f @parent] |
| `Super + B` | Focus the parent, brother, first or second window   [bspc node -f @brother] |
| `Super + ,` | Focus the parent, brother, first or second window   [bspc node -f @first] |
| `Super + .` | Focus the parent, brother, first or second window   [bspc node -f @second] |
| `Super + `` | Focus the last window (`) or the last desktop (Tab)   [bspc node -f last] |
| `Super + Tab` | Focus the last window (`) or the last desktop (Tab)   [bspc desktop -f last] |
| `Super + O` | Focus the older window in focus history |
| `Super + I` | Focus the newer window in focus history |
| `Super + Alt + H` | Grow an edge of the focused window   [bspc node -z left -20 0] |
| `Super + Alt + J` | Grow an edge of the focused window   [bspc node -z bottom 0 20] |
| `Super + Alt + K` | Grow an edge of the focused window   [bspc node -z top 0 -20] |
| `Super + Alt + L` | Grow an edge of the focused window   [bspc node -z right 20 0] |
| `Super + Alt + Shift + H` | Shrink an edge of the focused window   [bspc node -z right -20 0] |
| `Super + Alt + Shift + J` | Shrink an edge of the focused window   [bspc node -z top 0 20] |
| `Super + Alt + Shift + K` | Shrink an edge of the focused window   [bspc node -z bottom 0 -20] |
| `Super + Alt + Shift + L` | Shrink an edge of the focused window   [bspc node -z left 20 0] |
| `Super + Left` | Move the focused floating window   [bspc node -v -20 0] |
| `Super + Down` | Move the focused floating window   [bspc node -v 0 20] |
| `Super + Up` | Move the focused floating window   [bspc node -v 0 -20] |
| `Super + Right` | Move the focused floating window   [bspc node -v 20 0] |
| `Super + Ctrl + H` | Choose where the next window splits (h, j, k, l)   [bspc node -p west] |
| `Super + Ctrl + J` | Choose where the next window splits (h, j, k, l)   [bspc node -p south] |
| `Super + Ctrl + K` | Choose where the next window splits (h, j, k, l)   [bspc node -p north] |
| `Super + Ctrl + L` | Choose where the next window splits (h, j, k, l)   [bspc node -p east] |
| `Super + Ctrl + 1` | Choose the split ratio for the next window (1 to 9 = 10% to 90%)   [bspc node -o 0.1] |
| `Super + Ctrl + 2` | Choose the split ratio for the next window (1 to 9 = 10% to 90%)   [bspc node -o 0.2] |
| `Super + Ctrl + 3` | Choose the split ratio for the next window (1 to 9 = 10% to 90%)   [bspc node -o 0.3] |
| `Super + Ctrl + 4` | Choose the split ratio for the next window (1 to 9 = 10% to 90%)   [bspc node -o 0.4] |
| `Super + Ctrl + 5` | Choose the split ratio for the next window (1 to 9 = 10% to 90%)   [bspc node -o 0.5] |
| `Super + Ctrl + 6` | Choose the split ratio for the next window (1 to 9 = 10% to 90%)   [bspc node -o 0.6] |
| `Super + Ctrl + 7` | Choose the split ratio for the next window (1 to 9 = 10% to 90%)   [bspc node -o 0.7] |
| `Super + Ctrl + 8` | Choose the split ratio for the next window (1 to 9 = 10% to 90%)   [bspc node -o 0.8] |
| `Super + Ctrl + 9` | Choose the split ratio for the next window (1 to 9 = 10% to 90%)   [bspc node -o 0.9] |
| `Super + Ctrl + Space` | Cancel the split choice on the focused window |
| `Super + Ctrl + Shift + Space` | Cancel all split choices on this desktop |
| `Super + Alt + Q` | Quit bspwm (ends the session) |
| `Super + Alt + R` | Restart bspwm in place |

## Desktops

| Keys | Action |
|---|---|
| `Super + 1` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc desktop -f '^1'] |
| `Super + 2` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc desktop -f '^2'] |
| `Super + 3` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc desktop -f '^3'] |
| `Super + 4` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc desktop -f '^4'] |
| `Super + 5` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc desktop -f '^5'] |
| `Super + 6` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc desktop -f '^6'] |
| `Super + 7` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc desktop -f '^7'] |
| `Super + 8` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc desktop -f '^8'] |
| `Super + 9` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc desktop -f '^9'] |
| `Super + 0` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc desktop -f '^10'] |
| `Super + Shift + 1` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc node -d '^1'] |
| `Super + Shift + 2` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc node -d '^2'] |
| `Super + Shift + 3` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc node -d '^3'] |
| `Super + Shift + 4` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc node -d '^4'] |
| `Super + Shift + 5` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc node -d '^5'] |
| `Super + Shift + 6` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc node -d '^6'] |
| `Super + Shift + 7` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc node -d '^7'] |
| `Super + Shift + 8` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc node -d '^8'] |
| `Super + Shift + 9` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc node -d '^9'] |
| `Super + Shift + 0` | Go to desktop 1-9 (0 = 10). With shift, send the focused window there   [bspc node -d '^10'] |
| `Super + [` | Previous or next desktop   [bspc desktop -f prev.local] |
| `Super + ]` | Previous or next desktop   [bspc desktop -f next.local] |

## Wallpaper & screen

| Keys | Action |
|---|---|
| `Super + W` | Random wallpaper from ~/Pictures/wallpapers |
| `Super + Shift + W` | Wallpaper picker with thumbnails |
| `Print` | Screenshot a selected area (saved to ~/Pictures/Screenshots and copied; needs maim) |
| `Shift + Print` | Screenshot the whole screen (needs maim) |

## Volume & media

| Keys | Action |
|---|---|
| `Volume Up` | Volume up or down by 5%   [pactl set-sink-volume @DEFAULT_SINK@ +5%] |
| `Volume Down` | Volume up or down by 5%   [pactl set-sink-volume @DEFAULT_SINK@ -5%] |
| `Mute` | Mute or unmute the speakers |
| `Mic Mute` | Mute or unmute the microphone |
| `Brightness Up` | Screen brightness up or down by 5% (needs brightnessctl)   [~/.config/bspwm/scripts/actions.sh brightness up] |
| `Brightness Down` | Screen brightness up or down by 5% (needs brightnessctl)   [~/.config/bspwm/scripts/actions.sh brightness...] |
| `Play/Pause` | Play or pause, next track, previous track (needs playerctl)   [~/.config/bspwm/scripts/actions.sh media play...] |
| `Next Track` | Play or pause, next track, previous track (needs playerctl)   [~/.config/bspwm/scripts/actions.sh media next] |
| `Previous Track` | Play or pause, next track, previous track (needs playerctl)   [~/.config/bspwm/scripts/actions.sh media prev...] |

Alacritty: `Ctrl+Shift+C/V` copy and paste, `Ctrl+Shift+N` new window in the same folder, `Ctrl+Shift+O` toggle solid or translucent, `Ctrl+Shift+U` open a URL, `Ctrl+Shift+G` copy a git hash.
