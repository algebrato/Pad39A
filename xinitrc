#!/bin/bash

exec dbus-run-session -- bash -c '
feh --bg-fill --randomize --no-fehbg ~/bg/*
xscreensaver &
/usr/libexec/gnome-terminal-server >/dev/null 2>&1 &
for _ in $(seq 1 50); do
  pgrep -u "$USER" -x gnome-terminal-server >/dev/null && break
  sleep 0.1
done
nm-applet &
xmobar &
exec ~/.xmonad/xmonad-x86_64-linux
'
