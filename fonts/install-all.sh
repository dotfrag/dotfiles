#!/bin/bash

./font-patcher.sh install
./geist.sh
./inter.sh
./iosevka.sh
./jetbrains-mono.sh
./symbols.sh

fc-cache -rf
