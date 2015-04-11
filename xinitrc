#!/bin/sh
# ~/.xinitrc
# Executed by startx

if [ -f ~/.Xresources ]; then
    xrdb -merge ~/.Xresources
fi

# Make touchpad work like in Chromeos.
synclient TapButton1=1
synclient TapButton2=3
synclient TapButton3=2
synclient VertScrollDelta=-19
synclient HorizScrollDelta=-19
synclient PalmDetect=1

# Start i3 window manager
exec i3
