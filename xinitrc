feh --bg-fill --randomize --no-fehbg ~/bg/*
xscreensaver &
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand false --width 90 --widthtype pixel --transparent true --tint 0x300FF --alpha 0 --height 15 &
nm-applet  &
exec dbus-launch --exit-with-session xmonad 

