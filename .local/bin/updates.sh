#!/usr/bin/env zsh

repo_count=$(checkupdates | wc --lines)
aur_count=$(checkupdates-aur | wc --lines)
total_count=$((( ${repo_count} + ${aur_count} )))
notif_id=13370

if (( ${total_count} == 0 )); then
    exit
fi

title=""
body=""

if (( $total_count == 1 )); then
    title="Update Available"
else
    title="Updates Available"
fi

if (( $repo_count == 1 )); then
    body="There is ${repo_count} repository update"
elif (( $repo_count > 1 )); then
    body="There are ${repo_count} repository updates"
fi

if (( $aur_count == 1 )) && (( $repo_count == 0 )); then
    body="There is ${aur_count} AUR update"
elif (( $aur_count == 1 )); then
    body="${body} and ${aur_count} AUR update"
elif (( $aur_count > 1 )); then
    body="${body} and ${aur_count} AUR updates"
fi

body="${body} available."

dunstify -h string:x-canonical-private-synchronous:updates \
	 --appname=System --urgency=normal --timeout=0 \
	 "${title}" \
	 "${body}"

if is-reboot-needed.sh; then
    dunstify -h string:x-canonical-private-synchronous:reboot \
	     --appname=System --urgency=critical \
	     "Reboot Required" \
	     "You are running an outdated kernel. A reboot is required. Click to reboot." \
	     -A default,Reboot
fi
