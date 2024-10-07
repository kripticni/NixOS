#!/usr/bin/env bash
picom --config /home/aleksic/NixOS/sys/picom/pijulius.conf &
feh --bg-fill /home/aleksic/NixOS/assets/backgrounds/mountains-mono.png &
xsetroot -cursor_name left_ptr &
polybar --config=/home/aleksic/NixOS/sys/polybar/nord/nord.ini mel-bar
