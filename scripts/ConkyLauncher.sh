#!/bin/bash
sleep 2

for conf in $HOME/.config/conky/*
do
	conky -q -c $conf &
done
