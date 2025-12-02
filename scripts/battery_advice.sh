#!/usr/bin/env bash

# Thresholds
ALERT_20=20
ALERT_10=10
LAST_ALERT=""

# Get battery device path (assumes single battery)
BATTERY=$(upower -e | grep BAT)

while true; do
    # Read current percentage (integer)
    PERCENT=$(upower -i "$BATTERY" | grep -E "percentage" | awk '{print int($2)}')
    STATUS=$(upower -i "$BATTERY" | grep -E "state" | awk '{print $2}')

    # Only alert if discharging
    if [ "$STATUS" = "discharging" ]; then
        if [ "$PERCENT" -le "$ALERT_10" ] && [ "$LAST_ALERT" != "10" ]; then
            notify-send -u critical "Battery low" "Battery at ${PERCENT}%!"
            LAST_ALERT="10"
        elif [ "$PERCENT" -le "$ALERT_20" ] && [ "$LAST_ALERT" != "20" ] && [ "$LAST_ALERT" != "10" ]; then
            notify-send -u normal "Battery warning" "Battery at ${PERCENT}%"
            LAST_ALERT="20"
        elif [ "$PERCENT" -gt "$ALERT_20" ]; then
            LAST_ALERT=""
        fi
    else
        # Reset alert if charging
        LAST_ALERT=""
    fi

    sleep 60
done
