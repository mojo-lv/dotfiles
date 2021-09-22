#!/bin/bash
set -e

# nm-applet
if pgrep nm-applet; then
	pkill nm-applet
fi
exec nm-applet &

# gebaard
if pgrep gebaard; then
	pkill gebaard
fi
gebaard -b

# Natural Scrolling
_tp="$(xinput list | grep Touchpad)"
_tp=${_tp#*id=}
_tp=${_tp%%[slave*}
xinput set-prop $_tp 315 1

#------------------------------------------------------------------------------
# xmonad
#------------------------------------------------------------------------------
if [ $WINDOWMANAGER == "xmonad" ]; then
	# fix wmctrl -d
	wmctrl -s 1 && wmctrl -s 0

	# picom
	if pgrep picom; then
		pkill picom
	fi
	picom --experimental-backends -b

	# tint2
	if pgrep tint2; then
		pkill tint2
	fi
	for conf in ~/.config/tint2/*.tint2rc
	do
		exec tint2 -c $conf &
	done

	# conky
    if pgrep conky; then
        pkill conky
    fi
	sleep 2
	exec ~/scripts/DailyPoem.sh &
	sleep 2
    for conf in $HOME/.config/conky/*.conf
	do
		exec conky -q -c $conf &
	done
fi

# startup successfully
dunstify "Welcome !"
