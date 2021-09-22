#!/bin/sh
_vol="$(amixer get Master | tail -n1 | grep '\[on\]')"
if test -z "$_vol"; then
    printf "   MUTE"
else
	_vol="$(echo $_vol | sed -r 's/.*\[(.*)%\].*/\1/')"
    printf "  $_vol%%"
fi
