#!/bin/sh

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
read answer
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
checkInstall awesome
checkInstall xorg-server
checkInstall xorg-xinit
checkInstall xorg-utils
checkInstall xorg-server-utils
