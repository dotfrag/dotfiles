#!/bin/bash

config_file=${HOME}/.config/polybar/config.ini
module_file=${HOME}/.config/polybar/modules.ini

case "$1" in
  sep)
    sep=$(grep 'module/sep' "${module_file}" -A3 | grep -oP '(?<=label = ").*(?=")')
    echo "${sep}"
    ;;
  color)
    color_file=$(grep 'include-file.*colors' "${config_file}" | awk '{ print $NF }')
    color_file=${color_file/#\~/${HOME}}
    color=$(grep "$2" "${color_file}" | awk '{ print $NF }')
    echo "${color}"
    ;;
  *)
    echo 'Invalid or unsupported property.'
    exit 1
    ;;
esac
