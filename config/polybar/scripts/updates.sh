#!/bin/bash
# Pending pacman updates (checkupdates uses a temp db, no root needed). Prints nothing when up to date.
. "$HOME/.config/theme/palette.sh"
n=$(checkupdates 2>/dev/null | wc -l)
[ "$n" -gt 0 ] && printf '%%{T3}%%{F#%s}%%{F-}%%{T-} %s' "$YELLOW" "$n"
exit 0
