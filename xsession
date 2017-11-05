# activate screensaver after 1.5 minutes.
xset s 180 180
xss-lock -- i3lock -c 262626 -n &

# 200 ms delay and 40 ms repeat for keyboard auto-repeat
xset r rate 200 40

# Capslock is Ctrl.
setxkbmap -option ctrl:nocaps

# Left Ctrl is Escape when tapped, Ctrl when held..
pkill xcape 2> /dev/null
xcape -t 200 -e "Control_L=Escape"

# Enable tap to click.
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1

# $HOME/bin/monitors
monitors

exec i3
