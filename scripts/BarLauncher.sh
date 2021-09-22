#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar tint2

# Launch polybar
glxinfo | grep "GeForce" > /tmp/GeForce
polybar bar1 2>&1 | tee /tmp/polybar.log & disown

# Launch tint2
tint2 2>&1 | tee /tmp/tint2.log & disown
