#!/bin/bash

. colors
. genMKF

ADD="xmonad xmobar xinit dmenu feh"

for i in $ADD; do
	if [ -x "$(command -v $i)" ]; then
		echo -e "[$GREEN ok $NO_COL]\t- $i found"
	else
		echo -e "[$RED err $NO_COL]\t- Error: $i not installed"
		echo -e " \t  on debian-like distribution try: apt install $i"
		exit 1
		stop
	fi
done

genmakefile
echo "Installing xmobar configuration..."
sleep 2

WRES=`xrandr | grep + | grep ^" " | awk '{print $1}' | awk -F "x" '{print $1}'`
HRES=`xrandr | grep + | grep ^" " | awk '{print $1}' | awk -F "x" {'print $2'}`


clear

echo "- Start Basic Configuration -"
echo ""
echo -n "I found a monirot resolution of $WRES x $HRES. Is correct? (y/n): "
read RESCH

echo -n "Insert name of Gb Ethernet Interface: "
read ETHN

echo -n "Insert name of Wireless Interface   : "
read WIFI

sed -i -- "s/eth0/$ETHN/g" "../xmobarrc"
sed -i -- "s/wlan0/$WIFI/g" "../xmobarrc"

cp ../xmobarrc ~/.xmobarrc
cd ..
make
cd -





exit 0





