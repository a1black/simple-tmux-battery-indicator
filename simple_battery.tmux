#!/usr/bin/env bash

# Fetch the directory where plugin is installed.
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Include file with general functions.
source "$CURRENT_DIR/scripts/helper.sh"

# Available Tmux status line placeholders.
battery_indicator_hook=(
    '\#{battery_status_fg}'
    '\#{battery_status_bg}'
    '\#{battery_percentage}'
)

# Placeholder handler script.
battery_indicator_cmd=(
    "#($CURRENT_DIR/scripts/battery_fg.sh)"
    "#($CURRENT_DIR/scripts/battery_bg.sh)"
    "#($CURRENT_DIR/scripts/battery_percentage.sh)"
)

# Search and replace plugin placeholders in Tmux option.
# Args:
#   $1      option name
update_tmux_option() {
    local option="$1"
    local value=$(tmux_get_option $option)
    for ((i=0; i<${#battery_indicator_cmd[@]}; i++)); do
        value=${value//${battery_indicator_hook[$i]}/${battery_indicator_cmd[$i]}}
    done
    tmux_set_option "$option" "$value"
}

main() {
    update_tmux_option "status-right"
    update_tmux_option "status-left"
}

main

#vi: ft=sh
