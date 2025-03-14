#!/usr/bin/env bash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=5
has_battery=1

black=#2E3440
green=#A3BE8C
white=#D8DEE9
grey=#373d49
blue=#81A1C1
red=#BF616A
darkblue=#7292b2

cpu_usage() {
  cpu_usage="$(mpstat 2 1 | awk 'END{print 100-$NF}')"
  printf "^c$green^ ^b$grey^ %.2f" $cpu_usage
}

cpu() {
  printf "^c$black^ ^b$green^ "
  cpu_usage
}

battery1() {
  if [ $has_battery -eq 1 ]; then
    if cat /sys/class/power_supply/BAT1/capacity; then
      get_capacity="$(cat /sys/class/power_supply/BAT1/capacity)"
    else
      has_battery=0;
      get_capacity="no battery"
    fi
  fi 

  printf "^c$red^   $get_capacity "
}

battery() {
  # Ensure `has_battery` is set
  if [ -z "${has_battery+x}" ]; then
    has_battery=1
  fi

  if [ "$has_battery" -eq 1 ]; then
    battery_path="/sys/class/power_supply/BAT1/capacity"

    if [ -r "$battery_path" ]; then
      get_capacity=$(<"$battery_path")
    else
      has_battery=0
      get_capacity="no battery"
    fi
  else
    get_capacity="no battery"
  fi

  printf "^c$red^   %s " "$get_capacity"
}

brightness() {
  printf "^b$black^"
  printf "^c$red^ 󰃠 "
  curr_brightness=$(cat /sys/class/backlight/*/brightness)
  curr_brightness=$(awk "BEGIN {print 100 * ($curr_brightness / $max_brightness)}")
  printf "^c$red^%.0f" $curr_brightness
}

mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

bandwidth() {
  RX1=$(cat /sys/class/net/enp8s0/statistics/rx_bytes)
  TX1=$(cat /sys/class/net/enp8s0/statistics/tx_bytes)
  sleep 1
  RX2=$(cat /sys/class/net/enp8s0/statistics/rx_bytes)
  TX2=$(cat /sys/class/net/enp8s0/statistics/tx_bytes)
  RX_RATE=$(($RX2 - $RX1)) # kB/s
  TX_RATE=$(($TX2 - $TX1)) # kB/s
  RX_RATE=$(awk "BEGIN {print $RX_RATE / 1024}")
  TX_RATE=$(awk "BEGIN {print $TX_RATE / 1024}")

  printf "^c$blue^ 󰮏 %.2fkb | 󰸇 %.2fkb" $RX_RATE $TX_RATE
}

wlan() {
  case "$(cat /sys/class/net/enp8s0/operstate)" in
  up)
    printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^"
    bandwidth
    ;;
  down)
    printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected"
    ;;
  esac
}

clock() {
  printf "^c$black^ ^b$darkblue^ 󱑆 "
  printf "^c$black^ ^b$blue^ $(date '+%H:%M ') "
  printf "^b$black^"
}

prev_idle=0
prev_total=0
max_brightness=$(cat /sys/class/backlight/*/max_brightness)

while true; do
  cpu_usage &>/dev/null
  stdbuf -i0 -o0 -e0 xsetroot -name "$(wlan) $(cpu) $(mem) $(clock) $(brightness) $(battery)"
  sleep $interval
  #wlan && cpu && mem && clock && brightness && battery && printf '\n'
done
