#!/bin/bash

BATTERY="/sys/class/power_supply/BAT0"
THRESHOLD=80

while true; do
    capacity=$(<"$BATTERY/capacity")
    status=$(<"$BATTERY/status")

    if [[ "$capacity" -ge "$THRESHOLD" && "$status" == "Charging" ]]; then

        while [[ "$( <"$BATTERY/status")" == "Charging" ]]; do
            capacity=$(<"$BATTERY/capacity")

            notify-send -u critical \
                "Battery Alert" \
                "Battery at ${capacity}% — Unplug charger"

            if command -v paplay >/dev/null 2>&1; then
                paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga \
                    2>/dev/null
            fi

            sleep 20
        done
    fi

    sleep 10
done
