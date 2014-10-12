#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi
xrdb -merge ~/.Xresources
#xmodmap ~/.Xmodmap # doesnt work for mapping capslock to esc
setxkbmap -option terminate:ctrl_alt_bksp -option ctrl:nocaps
xbindkeys &
# see /usr/share/X11/xkb/rules/base.lst for options
# commented out because now done with xbindkeys
#setxkbmap -option grp:shifts_toggle,grp_led:scroll us,de

dropbox start &
cat ~/.encfspassword | encfs -S ~/git/encfs/ ~/.encfs/ &
if lspci | grep VirtualBox; then
    VBoxClient-all &
fi


#exec gnome-session
#exec startkde
#exec startxfce4
if type awesome > /dev/null 2>&1; then
    exec awesome
elif type openbox-session > /dev/null 2>&1; then
    exec openbox-session
fi
# exec qtile
