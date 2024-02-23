#!/bin/bash

LO=" 󰕿 "
HI=" 󰕾 "
MO=" 󰖀 "
MU=" 󰝟"

VOL=$(awk -F"[][]" '/Front Left:/ { print $2 }' <(amixer sget Speaker))
VO=$(echo "${VOL}" | cut -d'%' -f1)
V=$(echo "${VO}" | rev | cut -c 2- | rev)

get_vol_icon() {
  if [[ ${VO} -gt 50 ]]; then
    echo "${HI}${V} "
  elif [[ ${VO} -gt 25 ]]; then
    echo "${MO}${V} "
  else
    echo "${LO}${V} "
  fi
}

if amixer get Speaker | grep -q '\[on\]'; then
  get_vol_icon
else
  echo "${MU} "
fi
