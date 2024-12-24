#!/usr/bin/env bash
picom --config "$XDG_CONFIG_HOME"/picom/pijulius.conf &
feh --bg-fill "$XDG_DATA_HOME"/backgrounds/mountains-mono.png &
xsetroot -cursor_name left_ptr &
polybar --config="$XDG_CONFIG_HOME"/polybar/nord/nord.ini mel-bar
