if pgrep '^polybar' > /dev/null; then
  pkill --signal sigterm polybar 
elif type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload bar & MONITOR=$m polybar --reload secondarybar & 
  done
else
  polybar --reload bar & polybar --reload secondarybar &
fi
