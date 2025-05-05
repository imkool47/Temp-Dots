#!/bin/bash

echo ":: Restarting Waybar"

# Kill existing Waybar instances
killall waybar 2>/dev/null

# Wait for Waybar to stop completely
sleep 1

# Launch Waybar in the background
waybar >/dev/null 2>&1 &

echo ":: Waybar launched successfully!"
