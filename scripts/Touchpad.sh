#!/bin/bash
_tp="$(xinput list | grep Touchpad)"
_tp=${_tp#*id=}
_tp=${_tp%%[slave*}

case "$1" in
    Natural)
		xinput set-prop $_tp 315 $2
        ;;
    Enabled)
		xinput set-prop $_tp "Device Enabled" $2
		dunstify "Touchpad Enabled set $2"
        ;;
 esac
