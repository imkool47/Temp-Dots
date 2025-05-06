#!/bin/bash
# #  _              _     _           _ _
# # | | _____ _   _| |__ (_)_ __   __| (_)_ __   __ _ ___
# # | |/ / _ \ | | | '_ \| | '_ \ / _` | | '_ \ / _` / __|
# # |   <  __/ |_| | |_) | | | | | (_| | | | | | (_| \__ \
# # |_|\_\___|\__, |_.__/|_|_| |_|\__,_|_|_| |_|\__, |___/
# #           |___/                             |___/
# #
# -----------------------------------------------------
# Path to keybindings config file
# -----------------------------------------------------

config_file="$HOME/.config/hypr/keybinds.conf"
if [[ ! -f "$config_file" ]]; then
    echo "Keybind config file not found!"
    exit 1
fi

echo "Reading from: $config_file"

# -----------------------------------------------------
# Extract keybindings and format them
# -----------------------------------------------------

KEYBINDS=$(awk -F ', ' '
BEGIN { i = 1 }
{
    if ($0 ~ /^bind[[:space:]]*=+/) {
        gsub(/\$mainMod/, "SUPER", $0) # Replace $mainMod with SUPER
        gsub(/^bind[[:space:]]*=+[[:space:]]*/, "", $0) # Remove "bind =" and extra spaces
        split($0, kbarr, ",") # Split the keybinds using a comma
        if (length(kbarr) >= 3) {
            # Capture the comment at the end for explanation (if available)
            match($0, /# (.*)/, comment)
            explanation = (comment[1] != "") ? toupper(substr(comment[1], 1, 1)) substr(comment[1], 2) : "No Description"
            # Format the output with better spacing and alignment
            printf "%-30s → %-s\n", kbarr[1] " + " kbarr[2], "[" explanation "]"
        }
    }
}' "$config_file")


# -----------------------------------------------------
# Display in Rofi
# -----------------------------------------------------

if [[ -n "$KEYBINDS" ]]; then
    sleep 0.2
    rofi -dmenu -i -markup -eh 2 -replace -p "Keybinds" -config ~/.config/rofi/config-keybinds.rasi <<<"$KEYBINDS"
else
    echo "No keybinds found!"
fi

