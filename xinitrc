#!/bin/sh
# ~/.xinitrc
# Executed by startx

# Multiple screen setup for my i3 chroot.
# It's being really annoying about resolutions so this seems really messy but
# it works properly unline a one liner command.
IN="eDP1"
EXT="HDMI1"

if (xrandr | grep "$EXT connected"); then

    # turn off the internal screen first otherwise I can't get the external 
    # to be recognized as primary.
    xrandr --output $IN --off
    xrandr --output $EXT --primary

    # turn the internal screen back on left of the external with the right 
    # resolutions.
    xrandr --output $IN --auto --left-of $EXT
    xrandr --output $EXT --auto --right-of $IN
fi

if [ -f ~/.Xresources ]; then
    xrdb -merge ~/.Xresources
fi

# Make touchpad work like in Chromeos.
synclient TapButton1=1
synclient TapButton2=3
synclient VertScrollDelta=-19
synclient HorizScrollDelta=-19
synclient PalmDetect=1

# Start i3 window manager
exec i3
