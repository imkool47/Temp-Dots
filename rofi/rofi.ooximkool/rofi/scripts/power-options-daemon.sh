#!/bin/bash

# Define command shortcuts
PDM="power-daemon-mgr -q"
SET="$PDM set-profile-override"

# Cache file to store last selected option
CACHE_FILE="$HOME/.cache/last_power_profile"

# Define menu options
options=(
  "Powersave++"
  "Powersave"
  "Balanced"
  "Performance"
  "Performance++"
  "Reset Override"
)

# Load last selected option if exists
if [[ -f "$CACHE_FILE" ]]; then
  last_selected=$(<"$CACHE_FILE")
else
  last_selected=""
fi

# Use rofi to show menu and preselect the last selected option
selected_option=$(printf '%s\n' "${options[@]}" |
  rofi -dmenu \
       -mesg "🔋 Power Profile" \
       -theme-str 'configuration {show-icons: false;} window {location: north east; x-offset: -260; y-offset: 226; width: 225px;} inputbar {enabled: false;} element-text {vertical-align: 0.50; horizontal-align: 0.50;} mode-switcher {enabled: false;}' \
       -format 's' \
       -selected-row "$(printf "%s\n" "${options[@]}" | grep -nx "$last_selected" | cut -d: -f1 | awk '{print $1-1}')"
)

# Perform action based on selection
case "$selected_option" in
  "Powersave++") $SET Powersave++ ;;
  "Powersave") $SET Powersave ;;
  "Balanced") $SET Balanced ;;
  "Performance") $SET Performance ;;
  "Performance++") $SET Performance++ ;;
  "Reset Override") $PDM reset-profile-override ;;
  "") exit 0 ;;  # User exited without selection
  *) echo "Invalid selection." ;;
esac

# Save selection for next time (except reset)
if [[ "$selected_option" != "Reset Override" && -n "$selected_option" ]]; then
  echo "$selected_option" > "$CACHE_FILE"
fi
