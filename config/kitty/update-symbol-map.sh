#!/bin/bash

charset=$(fc-match --format='%{charset}\n' 'Symbols Nerd Font Mono' |
  perl -pe 's/(2665|26a1) //g;
            s/([\w\d]{4})/U+$1/g;
            s/ /,/g')

echo "symbol_map ${charset} Symbols Nerd Font Mono" >symbol-map.conf
