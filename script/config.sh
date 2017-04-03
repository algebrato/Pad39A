#!/bin/bash

. colors
. genMKF

ADD="xmonad xmobar xinit dmenu feh xbacklight"

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
echo -n "I found a monitor resolution of $WRES x $HRES. Is correct? (y/n): "
read RESCH

if [ $RESCH == 'n' ]; then
	echo -n -e "\tWidth: "
	read WRES
	echo -n -e "\tWidth: "
	read HRES
fi

SCALE=`echo "($HRES/768*15)/5" | bc -l`
SCALE=`echo ${SCALE%.*}`
FONTSZ=`echo "$SCALE*5*0.85" | bc -l`
HBAR=`echo "$SCALE*5" | bc -l`
WRES=`echo "($WRES-100)" | bc -l`

echo -n "Insert name of Ethernet Interface : "
read ETHN

echo -n "Insert name of Wireless Interface : "
read WIFI



cp ../xmobarrc ~/.xmobarrc
sed -i -- "s/ETH/$ETHN/g"   "$HOME/.xmobarrc"
sed -i -- "s/WLAN/$WIFI/g"  "$HOME/.xmobarrc"
sed -i -- "s/FONT/$FONTSZ/g" "$HOME/.xmobarrc"
sed -i -- "s/HBAR/$HBAR/g" "$HOME/.xmobarrc"
sed -i -- "s/WIDTHB/$WRES/g" "$HOME/.xmobarrc"

cd ..
make
cd -




exit 0





