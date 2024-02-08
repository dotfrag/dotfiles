#!/bin/bash

case "$1" in
  sep)
    module_file=${HOME}/.config/polybar/modules.ini
    sep=$(grep -oP '(?<=content = ").*(?=")' "${module_file}")
    echo "${sep}"
    ;;
  color)
    config_file=${HOME}/.config/polybar/config.ini
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
