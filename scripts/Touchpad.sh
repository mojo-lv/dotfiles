#!/bin/bash
_tp="$(xinput list | grep Touchpad)"
_tp=${_tp#*id=}
_tp=${_tp%%[slave*}

xinput set-prop $_tp "Device Enabled" $1
dunstify "Touchpad Enabled set $1"
