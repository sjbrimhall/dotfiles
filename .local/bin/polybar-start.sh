#!/usr/bin/env zsh

export XAUTHORITY="$HOME/.Xauthority"
export DISPLAY=":$(echo $1 | cut -d":" -f1)"
export POLYBAR_MONITOR="$(echo $1 | cut -d":" -f2)"
bar="$(echo $1 | cut -d":" -f3)"

exec polybar $bar
