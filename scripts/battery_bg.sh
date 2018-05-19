#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Include file with general functions.
source "$CURRENT_DIR/helper.sh"

# Default color values.
bg_battery_high_energy_default="#[bg=green,fg=white]"
bg_battery_medium_energy_default="#[bg=yellow,fg=black]"
bg_battery_low_energy_default="#[bg=colour202,fg=black]"
bg_battery_verylow_energy_default="#[bg=red,fg=white]"

# Returns background color indicating battery remain charge.
# Args:
#   $1      percentage of remain energy
get_battery_bg_color() {
    local percentage=$(("$1"))
    if ((percentage <= 20)); then
        tmux_get_option "@batt_verylow_bg" "$bg_battery_verylow_energy_default"
    elif ((percentage <= 50)); then
        tmux_get_option "@batt_low_bg" "$bg_battery_low_energy_default"
    elif ((percentage <= 80)); then
        tmux_get_option "@batt_medium_bg" "$bg_battery_medium_energy_default"
    else
        tmux_get_option "@batt_high_bg" "$bg_battery_high_energy_default"
    fi
}

main() {
    if battery_cmd_exists 'upower'; then
        source "$CURRENT_DIR/upower_proxy.sh"
    else
        return 1
    fi
    get_battery_bg_color $(battery_get_percentage)
}

main
