#!/bin/bash

if command -v termux-battery-status &>/dev/null; then
	status="$(termux-battery-status)"
	percentage="$(echo "$status" | sed -n 's/^\s*"percentage": \(.*\),$/\1/p')"
	is_charging="$(
		[ "$(echo "$status" | sed -n 's/^\s*"status": "\(.*\)",$/\1/p')" != "DISCHARGING" ]
		echo "$?"
	)"
else
	battery="$(find /sys/class/power_supply/{BAT,axp288_fuel_gauge,CMB}* | head -n1)"
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

colors=("#f38ba8" "#f9e2af" "#a6e3a1")

# Function to convert a hex color to its RGB components
hex_to_rgb() {
	echo $((16#${1:1:2})) $((16#${1:3:2})) $((16#${1:5:2}))
}

# Function to convert RGB back to a hex color
rgb_to_hex() {
	printf "#%02x%02x%02x\n" "$1" "$2" "$3"
}

# Function to linearly interpolate between two values
lerp() {
	awk -v start="$1" -v end="$2" -v t="$3" 'BEGIN { print start + (end - start) * t }'
}

# Function to get the color at a specific value in the gradient
color_at_value() {
	local value=$1
	shift
	local colors=("$@")

	# Determine the number of color stops
	local color_count=${#colors[@]}

	# Ensure the value is between 0 and 100
	if [ "$value" -lt 0 ]; then
		value="0"
	fi
	if [ "$value" -gt 100 ]; then
		value="100"
	fi

	# Scale value to a fraction between 0 and 1
	value=$(awk -v value="$value" 'BEGIN { print value / 100 }')

	# Calculate the segment in the gradient this value falls into
	local size index fraction
	size="$(awk -v color_count="$color_count" 'BEGIN { print 1 / color_count }')"
	index="$(
		awk -v value="$value" \
			-v size="$size" \
			'BEGIN { print int(value / size) }'
	)"
	fraction="$(
		awk -v value="$value" \
			-v index="$index" \
			-v size="$size" \
			'BEGIN { print (value - (index * size)) / size }'
	)"

	if [ "$index" -eq "$color_count" ]; then
		((--index))
	fi

	# Get the two colors between which to interpolate
	local color1="${colors[$index]}"
	local color2="${colors[$((index + 1))]}"

	# Convert hex colors to RGB
	local rgb1 rgb2
	rgb1=($(hex_to_rgb "$color1"))
	rgb2=($(hex_to_rgb "$color2"))

	# Interpolate each RGB component
	local r g b
	r="$(lerp "${rgb1[0]}" "${rgb2[0]}" "$fraction")"
	g="$(lerp "${rgb1[1]}" "${rgb2[1]}" "$fraction")"
	b="$(lerp "${rgb1[2]}" "${rgb2[2]}" "$fraction")"

	# Convert back to hex and return the result
	rgb_to_hex "${r%.*}" "${g%.*}" "${b%.*}"
}

if [ "$is_charging" -ne 0 ]; then
	echo -n "#[fg=$(color_at_value "$percentage" "${colors[@]}")]"
fi

if [ "$is_charging" -eq 0 ]; then
	icons=("󰢟" "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅")
else
	icons=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
fi

echo -n "${icons[percentage * (${#icons[@]} - 1) / 100]} $percentage% #[default]"
