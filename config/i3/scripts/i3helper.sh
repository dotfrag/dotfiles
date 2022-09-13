#!/bin/bash

case $1 in
moveToParent)
    i3 mark i3ha
    i3 focus parent
    i3 focus parent
    i3 mark i3hb
    i3 [con_mark="i3ha"] focus
    i3 move window to mark i3hb
    i3 unmark i3ha
    i3 unmark i3hb
    ;;
esac

exit 0
