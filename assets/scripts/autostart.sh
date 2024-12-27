#!/usr/bin/env bash
feh --bg-fill "$XDG_DATA_HOME"/backgrounds/nixstorm.png &
picom --config "$XDG_CONFIG_HOME"/picom/master.conf &
xsetroot -cursor_name left_ptr &
$HOME/.dwm/bar.sh
