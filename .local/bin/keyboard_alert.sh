#!/usr/bin/env zsh

if [[ $5 == "CRITICAL" ]]; then
    g810-led -fx breathing logo ff8800 1s
    touch ~/.critical_active
elif [[ $5 == "NORMAL" ]] && ( (( $(xprintidle) / 1000 >= 600 )) || pgrep i3lock &> /dev/null ); then
    if ! [[ -a ~/.critical_active ]]; then
	g810-led -fx breathing logo ff8800 5s
    fi
fi

