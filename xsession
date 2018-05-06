# activate screensaver after 1.5 minutes.
xset s 300 300
xss-lock -- i3lock -c 262626 -n &

# x ms delay and y ms repeat for keyboard auto-repeat
xset r rate 180 80

# Capslock is Ctrl.
setxkbmap -option ctrl:nocaps

# Left Ctrl is Escape when tapped, Ctrl when held..
pkill xcape 2> /dev/null
xcape -t 200 -e "Control_L=Escape"

# Enable tap to click.
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1

# $HOME/bin/monitors
monitors

redshift  -O 3700K

exec i3
