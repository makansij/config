#!/bin/sh

## OPTIONS
VBOX=true

## VARIABLES
ARCHLINUX_FR_SERVER=$(cat <<\EOF
[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
EOF
)

CONFIG_PATH=$(dirname $(readlink -f $0))

SHELL_LIBRARY=$CONFIG_PATH/shell_functions.sh

## MAIN
if [ ! -f $SHELL_LIBRARY ]
then
  echo "library not found! exiting.."
  exit 1
fi
source $SHELL_LIBRARY
if ! pacman -Q sudo > /dev/null 2>&1; then
    echo "please install sudo first!"
    exit 1
fi
if ! pacman -Q yaourt > /dev/null 2>&1; then
    echo "adding archlinuxfr repo to pacman.conf"
    echo "$ARCHLINUX_FR_SERVER" | sudo tee --append /etc/pacman.conf
    sudo pacman -Syu
    sudo pacman -S yaourt
fi
if ! pacman -Qg base-devel > /dev/null 2>&1; then
    sudo pacman -S base-devel
fi

checkInstall vim

echo "make links? Y/n"
read -n 1 answer
case $answer in
  n*|N*) ;;
      *) for f in $CONFIG_PATH/home/.[!.]*
	 do
	   makeLink $f $HOME
	 done
         if [ ! -e $HOME/.vim/bundle/ ];then
            mkdir -p $HOME/.vim/bundle
            git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
         fi
         ;;
esac

if checkInstall awesome; then
    checkInstall xorg-server
    checkInstall xorg-xinit
    checkInstall xorg-utils
    checkInstall xorg-server-utils
    checkInstall vicious
    checkInstall xterm
    checkInstall ttf-dejavu
    mkdir -p $HOME/.config
    makeLink $CONFIG_PATH/.config/awesome $HOME/.config
fi
if checkInstall openbox; then
    checkInstall xorg-server
    checkInstall xorg-xinit
    checkInstall xorg-utils
    checkInstall xorg-server-utils
    checkInstall xterm
    checkInstall ttf-dejavu
    checkInstall obconf
    checkInstall obmenu
    mkdir -p $HOME/.config
    makeLink $CONFIG_PATH/.config/openbox $HOME/.config
fi
if [ "$VBOX" = true ]; then
    checkInstall virtualbox-guest-modules
    checkInstall virtualbox-guest-utils
    MODS_PATH=/etc/modules-load.d
    exesudo makeLink $CONFIG_PATH/etc/modules-load.d/virtualbox.conf $MODS_PATH
    exesudo systemctl enable vboxservice
fi
