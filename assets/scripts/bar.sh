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

cpu_usage() {
  cpu_info=($(head -n 1 /proc/stat))
  user=${cpu_info[1]}
  nice=${cpu_info[2]}
  system=${cpu_info[3]}
  idle=${cpu_info[4]}
  iowait=${cpu_info[5]}
  irq=${cpu_info[6]}
  softirq=${cpu_info[7]}

  total=$((user + nice + system + idle + iowait + irq + softirq))
  idle_total=$((idle + iowait))

  total_delta=$((total - prev_total))
  idle_delta=$((idle_total - prev_idle))

  if [ $total_delta -gt 0 ]; then
    cpu_usage=$(awk "BEGIN {print 100 * ($total_delta - $idle_delta) / $total_delta}")
  else
    cpu_usage=0
  fi

  printf "^c$green^ ^b$grey^ %.2f" $cpu_usage

  prev_total=$total
  prev_idle=$idle_total
}

cpu() {
  printf "^c$black^ ^b$green^ "
  cpu_usage
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT1/capacity)"
  printf "^c$red^   $get_capacity "
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
  case "$(cat /sys/class/net/enp8s0/operstate 2>/dev/null)" in
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
  #wlan && cpu && mem && clock && brightness && battery && printf '\n'
done
