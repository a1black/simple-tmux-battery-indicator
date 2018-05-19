#!/usr/bin/env
# General purpose functions.

# Checks if provided command is accessible.
# Args:
#   $1      command name
battery_cmd_exists() {
    type "$1" &> /dev/null
}

# Tmux option getter.
# Args:
#   $1      option name
#   $2      value returned if option is not set
tmux_get_option() {
    local value=$(tmux show-option -gqv "$1" 2> /dev/null)
    if [ -z "$value" ]; then
        echo "$2"
    else
        echo "$value"
    fi
}

# Tmux option setter.
# Args:
#   $1      option name
#   $2      option value
tmux_set_option() {
    tmux set-option -gq "$1" "$2" &> /dev/null
}
