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



echo "make links?"
read answer
case $answer in
  n*|N*) ;;
      *) makeLink $CONFIG_PATH/home/.vimrc $HOME
	     makeLink $CONFIG_PATH/home/.vim $HOME
         makeLink $CONFIG_PATH/home/.bashrc $HOME
         makeLink $CONFIG_PATH/home/.bash_aliases $HOME
      	 makeLink $CONFIG_PATH/home/.bin $HOME
		 makeLink $CONFIG_PATH/home/.inputrc $HOME
         ;;
esac

