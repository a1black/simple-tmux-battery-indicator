#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Include file with general functions.
source "$CURRENT_DIR/helper.sh"

# Default battery state icons.
icon_battery_charging_default="\u26a1"
icon_battery_discharging_default=""

# Returns icon depicting battery state.
# Args:
#   $1      battery state string
get_battery_state_icon() {
    local state="$1"
    if [ "$state" = 'charging' ]; then
        tmux_get_option "@batt_charging_icon" "$icon_battery_charging_default"
    elif [ "$state" = 'discharging' ]; then
        tmux_get_option "@batt_discharging_icon" "$icon_battery_discharging_default"
    else
        echo -n ''
    fi
}

main() {
    if battery_cmd_exists 'upower'; then
        source "$CURRENT_DIR/upower_proxy.sh"
    else
        return 1
    fi
    local state=$(battery_get_state)
    local energy_left=$(battery_get_percentage)
    local state_icon=$(get_battery_state_icon "$state")
    if [ "$state" = 'charging' ]; then
        printf "$state_icon%d%%" $energy_left
    else
        local time=$(battery_get_time_left)
        printf "$state_icon%d%% %d:%02d" $energy_left $((time / 60)) $((time % 60))
    fi
}

main
