#!/bin/bash

if command -v termux-battery-status &>/dev/null; then
	status="$(termux-battery-status)"
	percentage="$(echo "$status" | sed -n 's/^\s*"percentage": \(.*\),$/\1/p')"
	is_charging="$(
		[ "$(echo "$status" | sed -n 's/^\s*"status": "\(.*\)",$/\1/p')" != "DISCHARGING" ]
		echo "$?"
	)"
else
	battery="$(find /sys/class/power_supply/BAT* | head -n1)"
	if [ -z "$battery" ]; then
		return
	fi
	percentage="$(cat "$battery/capacity")"
	is_charging="$(
		[ "$(cat "$battery/status")" != "Discharging" ]
		echo "$?"
	)"
fi

if [ "$percentage" -gt 100 ]; then
	percentage="100"
fi

if [ "$is_charging" -eq 0 ]; then
	icons=("󰢟" "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅")
else
	icons=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
fi

echo "${icons[percentage * (${#icons[@]} - 1) / 100]} $percentage% "
