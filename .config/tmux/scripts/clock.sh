#!/bin/bash

hour="$(date +"%I")"

icons=("󱑋" "󱑌" "󱑍" "󱑎" "󱑏" "󱑐" "󱑑" "󱑒" "󱑓" "󱑔" "󱑕" "󱑖")

echo "${icons[10#$hour - 1]} $(date +"%I:%M %p") "
