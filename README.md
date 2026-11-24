# bspwm Tokyo Night rice

A complete, reproducible desktop for **bspwm** on X11: tiling, keyboard-first navigation, a
polybar with pill groups, a Spotlight-style rofi launcher, a Tokyo Night colour palette shared by
every app, and a GTK theme. It is built to be forked: one palette file drives every colour, and
the installer backs up whatever it replaces.

- **Window manager:** bspwm with sxhkd keybindings and a `super + F1` cheat sheet
- **Bar:** polybar, one per monitor, with workspaces, clock, CPU, RAM, temperature, volume, Wi-Fi, Bluetooth, battery, tray and power button
- **Launcher:** rofi in three layouts (Spotlight launcher, fullscreen app grid, compact menus), with Wi-Fi, Bluetooth, power and wallpaper pickers
- **Terminal:** Alacritty with a matching theme, hints, live opacity toggle and clipboard integration
- **Compositor:** picom with blur, rounded corners and soft shadows
- **Files and GTK:** Thunar and GTK3 apps themed to match, with a generated TokyoNight theme
- **Prompt:** starship (optional)

## Screenshots

_Add a screenshot of your own setup here. Screenshots are not included because they show personal content._

## Requirements

Package names are for **Arch Linux** (other distributions use different names).

```
pacman -S --needed bspwm sxhkd polybar picom rofi alacritty xorg-xrandr imagemagick \
  networkmanager bluez-utils pavucontrol ttf-firacode-nerd noto-fonts xclip
# optional: starship zoxide eza bat dunst papirus-icon-theme python-gobject gtk3
# AUR (optional): qogir-icon-theme
```

Set up X11 and a bspwm session first (e.g. the `bspwm` session from your display manager, or `exec bspwm` in `~/.xinitrc`).

## Install

```
git clone https://github.com/hvb24/bspwm-tokyo-night-rice.git
cd bspwm-tokyo-night-rice
./install.sh --dry-run     # see what will change (changes nothing)
./install.sh               # install; existing files are backed up first
./install.sh --zsh         # optional: also load the shell additions from ~/.zshrc
```

Then restart bspwm (`bspc wm -r`) or log out and back in.

`install.sh` never deletes anything. It copies each file it replaces into
`~/.local/share/bspwm-rice/backups/<timestamp>/` and writes a manifest.

**Undo:** `./uninstall.sh` restores every replaced file and removes the ones the installer created.

## Customise

| What | Where |
|---|---|
| Colours (everything reads these) | `config/theme/palette.sh`, then run `config/theme/apply.sh` |
| Monitors, battery, Wi-Fi, sensors | Detected automatically by `config/theme/machine.sh`. Override in `~/.config/theme/machine.local.sh` |
| Bar modules and layout | `config/polybar/config.ini` (`modules-left`, `modules-center`, `modules-right`) |
| Keybindings | `config/sxhkd/sxhkdrc` (`super + F1` shows them) |
| Launcher look | `config/rofi/custom.rasi` (launcher), `menu.rasi`, `grid.rasi`, `wallpaper.rasi` |
| Terminal | `config/alacritty/alacritty.toml` |
| Wallpapers | Put images in `~/Pictures/wallpapers` (or set `WALLPAPER_DIR`). `super + shift + w` picks one |
| Workspace rules | `config/bspwm/bspwmrc` (`bspc rule` lines) |

Changes to `palette.sh` apply to every app after `apply.sh`. Machine overrides go in a file the
installer never overwrites:

```sh
# ~/.config/theme/machine.local.sh
export POLYBAR_PRIMARY=DP-1
export POLYBAR_SECONDARY=HDMI-1
export POLYBAR_BATTERY=          # desktop: no battery
export WALLPAPER_DIR="$HOME/Pictures/wallpapers"
```

More detail: [keybindings](docs/KEYBINDINGS.md) · [troubleshooting](docs/TROUBLESHOOTING.md)

## Repository layout

```
config/          copied to ~/.config (generated files are created by apply.sh)
  bspwm/         bspwmrc, helper scripts
  sxhkd/         keybindings
  polybar/       bar config, launch.sh, scripts (updates, Bluetooth)
  rofi/          themes and scripts (launcher, grid, power, Wi-Fi, wallpapers)
  alacritty/     terminal config and opacity toggle
  picom/         compositor
  theme/         palette.sh (source of truth), apply.sh, machine.sh, gen-gtk3.py, wallpaper.sh
  gtk-3.0/ Thunar/ xfce4/ starship.toml rice/   GTK, file manager, prompt, shell additions
install.sh  uninstall.sh  tests/check.sh  docs/  .github/workflows/
```

## Testing

```
./tests/check.sh
```

Runs syntax checks, TOML/XML/Python parsing, rofi theme validation (when rofi is installed) and a
scan for leftover personal data. CI runs the same script on every push.

## Credits

- Tokyo Night palette by enkia (VS Code theme), recoloured for each app here
- Adwaita GTK theme (the GTK3 theme is generated from it)
- Nerd Fonts (FiraCode, Iosevka), Qogir icons

## Licence

MIT. See [LICENSE](LICENSE).
