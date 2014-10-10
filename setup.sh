#!/bin/sh
## options
VBOX=true
CONFIG_PATH=$(dirname $(readlink -f $0))
echo config_path=$CONFIG_PATH

SHELL_LIBRARY=$CONFIG_PATH/shell_functions.sh
if [ ! -f $SHELL_LIBRARY ]
then
  echo "library not found! exiting.."
  exit 1
fi
source $SHELL_LIBRARY

echo "make links? Y/n"
read -n 1 answer
case $answer in
  n*|N*) ;;
      *) for f in $CONFIG_PATH/home/.[!.]*
	 do
	   makeLink $f $HOME
	 done
         mkdir -p $HOME/.vim/bundle
         git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
         ;;
esac
if checkInstall awesome; then
    mkdir -p $HOME/.config
    makeLink $CONFIG_PATH/.config/awesome $HOME/.config
fi
checkInstall xorg-server
checkInstall xorg-xinit
checkInstall xorg-utils
checkInstall xorg-server-utils
if [ "$VBOX" = true ]; then
    checkInstall virtualbox-guest-modules
    checkInstall virtualbox-guest-utils
    MODS_PATH=/etc/modules-load.d
    if [ ! -L $MODS_PATH/virtualbox.conf ]; then
        exesudo makeLink $CONFIG_PATH/etc/modules-load.d/virtualbox.conf $MODS_PATH
    fi
    exesudo systemctl enable vboxservice
fi
