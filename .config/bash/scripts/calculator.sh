#!/bin/bash

# check if calculator is open
if wmctrl -lx | grep -i kcalc.Kcalc >/dev/null; then
	# unminimize it
	wmctrl -xa kcalc.Kcalc
else
	# otherwise, launch it
	kcalc &
fi
