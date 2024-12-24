#!/usr/bin/env bash

# ^c$var^ = fg color
# ^b$var^ = bg color

# interval=0
black=#2E3440
green=#A3BE8C
white=#D8DEE9
grey=#373d49
blue=#81A1C1
red=#BF616A
darkblue=#7292b2

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$black^ ^b$green^ "
  printf "^c$green^ ^b$grey^ $cpu_val"
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT1/capacity)"
  printf "^c$blue^   $get_capacity"
}

brightness() {
  printf "^b$black^"
  printf "^c$red^ 󰃠 "
  printf "^c$red^%.0f  \n" $(cat /sys/class/backlight/*/brightness)
}

mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
  case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
  up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
  down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
  esac
}

clock() {
  printf "^c$black^ ^b$darkblue^ 󱑆 "
  printf "^c$black^ ^b$blue^ $(date '+%H:%M ') "
  printf "^b$black^"
}

while true; do
  sleep 1 && xsetroot -name "$(battery) $(cpu) $(mem) $(wlan) $(clock) $(brightness)"
done
