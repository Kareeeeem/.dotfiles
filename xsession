xset s 300
xxs-lock -- lock &

xset r rate 200 40
setxkbmap -option ctrl:nocaps
pkill xcape 2> /dev/null; xcape -t 200 -e "Control_L=Escape"

exec i3
