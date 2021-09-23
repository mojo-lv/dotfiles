#!/bin/bash
_ws=$(wmctrl -d | grep \* | cut -b 1)

case "$1" in
    Next)
        _ws=$(($(($_ws + 1)) % 9))
		wmctrl -s $_ws
		;;
    Prev)
        _ws=$(($(($_ws + 8)) % 9))
		wmctrl -s $_ws
		;;
 esac
