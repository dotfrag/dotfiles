#!/bin/bash

status() {
    DEFAULT_SOURCE_INDEX=$(pacmd list-sources | grep "\* index:" | cut -d' ' -f5)
    volume=$(pacmd list-sources | grep "index: $DEFAULT_SOURCE_INDEX" -A 7 | grep "volume" | awk -F/ '{print $2}')
    muted=$(pacmd list-sources | grep "index: $DEFAULT_SOURCE_INDEX" -A 11 | grep "muted")

    if [ -z "$volume" ]; then
        echo "No Mic Found"
    else
        volume="${volume//[[:blank:]]/}"
        if [[ "$muted" == *"yes"* ]]; then
            echo " MUTED"
        elif [[ "$muted" == *"no"* ]]; then
            echo "%{F#EBCB8B} OPEN%{F-} $volume"
        else
            echo "%{F#EBCB8B} OPEN%{F-} $volume !"
        fi
    fi
}

listen() {
    status

    LANG=EN
    pactl subscribe | while read -r event; do
        if echo "$event" | grep -q "source" || echo "$event" | grep -q "server"; then
            status
        fi
    done
}

toggle() {
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
}

increase() {
    DEFAULT_SOURCE_INDEX=$(pacmd list-sources | grep "\* index:" | cut -d' ' -f5)
    volume=$(pacmd list-sources | grep "index: $DEFAULT_SOURCE_INDEX" -A 7 | grep "volume" | awk -F/ '{print $2}')

    if (( ${volume//%} < 100 )); then
      pactl set-source-volume @DEFAULT_SOURCE@ +5%
    fi
}

decrease() {
    pactl set-source-volume @DEFAULT_SOURCE@ -5%
}

case "$1" in
--toggle)
    toggle
    ;;
--increase)
    increase
    ;;
--decrease)
    decrease
    ;;
*)
    listen
    ;;
esac
