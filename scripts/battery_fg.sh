#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Include file with general functions.
source "$CURRENT_DIR/helper.sh"

# Default color values.
fg_battery_high_energy_default="#[fg=green]"
fg_battery_medium_energy_default="#[fg=yellow]"
fg_battery_low_energy_default="#[fg=colour202]"
fg_battery_verylow_energy_default="#[fg=red]"

# Returns foreground color indicating battery remain charge.
# Args:
#   $1      percentage of remain energy
get_battery_fg_color() {
    local percentage=$(("$1"))
    if ((percentage <= 20)); then
        tmux_get_option "@batt_verylow_fg" "$fg_battery_verylow_energy_default"
    elif ((percentage <= 50)); then
        tmux_get_option "@batt_low_fg" "$fg_battery_low_energy_default"
    elif ((percentage <= 80)); then
        tmux_get_option "@batt_medium_fg" "$fg_battery_medium_energy_default"
    else
        tmux_get_option "@batt_high_fg" "$fg_battery_high_energy_default"
    fi
}

main() {
    if battery_cmd_exists 'upower'; then
        source "$CURRENT_DIR/upower_proxy.sh"
    else
        return 1
    fi
    get_battery_fg_color $(battery_get_percentage)
}

main
