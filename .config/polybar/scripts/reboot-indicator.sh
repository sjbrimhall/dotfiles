#!/usr/bin/env zsh

INSTALLED_VERSION="$(file /boot/vmlinuz-linux | cut -d',' -f2 | cut -d' ' -f3)"
RUNNING_VERSION="$(uname -r)"

color_red=$(xrdb -query -all | grep "color1:" | cut -f2)

if [[ $INSTALLED_VERSION != $RUNNING_VERSION ]]; then
   echo "%{F${color_red}}Reboot required%{F-}"
fi

