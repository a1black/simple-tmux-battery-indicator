#!/usr/bin/env bash
# Wrap for upower command line tool.
# Script must implement following methods:
#   battery_get_percentage      - remain energy in percents
#   battery_get_state           - battery state (charge/discharge/etc)
#   battery_get_time_left       - remain time (in minutes) before full discharge/charge

# Get battery full information.
battery_call_upower() {
    local id=$(upower -e 2> /dev/null | grep -m 1 'battery')
    [ -z "$id" ] && return 1
    upower -i "$id" 2> /dev/null
}

# Returns percentage (decimal value) of remain energy.
battery_get_percentage() {
    local percentage=$(battery_call_upower | awk '/percentage:/ {print 0+$2}')
    printf "%.0f" $percentage
}

# Returns lowercase string describing battery state (charging/discharging/etc).
battery_get_state() {
    battery_call_upower | awk '/state:/ {print $2}' | tr '[:upper:]' '[:lower:]'
}

# Returns number of minutes until full charge/discharge.
battery_get_time_left() {
    local time_to=$(battery_call_upower | grep -m 1 -E '(remain|time to [a-z]+)' | cut -d: -f2)
    [ -z "$time_to" ] && return 1
    local time_left=$(echo "$time_to" | awk '{print 0+$1}')
    if echo "$time_to" | grep -q 'hours'; then
        awk -v left=$time_left 'BEGIN{printf "%.0f", left*60}'
    else
        printf "%.0f" $time_left
    fi
}
