#!/bin/bash

sxhkd_file="$HOME/.config/sxhkd/sxhkdrc"

# Extract and display keybindings with their comments in rofi
awk '
    BEGIN {
        print "🧠  Your Active Keybindings:\n"
    }
    /^#/{ 
        gsub(/^#\s*/, "", $0); desc=$0; next 
    }
    /^[^#[:space:]]/ {
        if (desc != "")
            printf "🔑  %-35s → %s\n", $0, desc
        desc=""
    }
' "$sxhkd_file" | rofi -dmenu -i -p "Keybindings" -theme-str "window { width: 900px; }" -m -4
