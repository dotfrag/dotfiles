#!/bin/bash
# Copyright (C) 2015 Martín Cigorraga <archlinux.us: msx>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the Affero GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

ON=" 󰍬"
OFF=" 󰍭"

# Check mouse event
# shellcheck disable=SC2154
case ${BLOCK_BUTTON} in
  3)
    #/usr/bin/amixer set Capture toggle &>/dev/null;  # AlsaMixer
    /usr/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle # PulseAudio
    ;;
esac

# Determine mic's state
#amixer contents | grep -q "values=off" && [[ $? -eq 0 ]] && state="off";  # If you use AlaMixer
# pactl list sources | grep -q "Mute: yes" && [[ $? -eq 0 ]] && state="off" # If you rather go with PulseAudio
# shellcheck disable=SC2063,SC2181
pacmd list-sources | grep -e "* index:" -e "muted" | sed -n "/index/{n;p}" | grep -q "muted: yes" && [[ $? -eq 0 ]] && state="off"

# Toggle mic's state
case ${state} in
  off)
    echo "${OFF}"
    exit 0
    ;;
  *)
    echo "${ON} OPEN"
    echo
    echo \#EBCB8B
    exit 0
    # exit 33
    ;;
esac

# shellcheck disable=SC2317
exit 0
