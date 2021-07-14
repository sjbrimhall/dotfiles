#!/usr/bin/env zsh

installed_version="$(file /boot/vmlinuz-linux | cut -d',' -f2 | cut -d' ' -f3)"
running_version="$(uname -r)"

if [[ $installed_version == $running_version ]]; then
    exit 1
else
    exit 0
fi
