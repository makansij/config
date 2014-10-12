#!/bin/sh

## OPTIONS
if lspci | grep VirtualBox >/dev/null; then
    VBOX=true
fi

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
    echo "please install and configure sudo first!"
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
checkInstall bash-completion
for f in $CONFIG_PATH/home/.[!.]*; do
    makeLink $f $HOME
done
if checkInstall git; then
    git config --global push.default simple
    git config --global user.name "jandob"
    git config --global user.email "***REMOVED***"
fi

if [ "$VBOX" = true ]; then
    checkInstall virtualbox-guest-modules
    checkInstall virtualbox-guest-utils
    MODS_PATH=/etc/modules-load.d
    exesudo makeLink $CONFIG_PATH/etc/modules-load.d/virtualbox.conf $MODS_PATH
    sudo mkdir /media
    exesudo systemctl start vboxservice
    exesudo systemctl enable vboxservice
    sudo usermod -aG vboxsf $(whoami)
fi

if checkInstall encfs; then
    if [ ! -e $HOME/.encfspassword ]; then
        echo "WARNING: please add .encfspassword to home folder and rerun"
        echo "You probably need to reboot before filesharing with the host works"
        exit 0
    else
        if [ ! -e $HOME/.encfs ]; then
            mkdir -p $HOME/.encfs
            git clone https://github.com/jandob/encfs $CONFIG_PATH/../encfs
            cat ~/.encfspassword | encfs -S $CONFIG_PATH/../encfs/ ~/.encfs/
        fi
        makeLink $HOME/.encfs/.ssh $HOME
        if checkInstall openssh; then
            ssh-add $HOME/.ssh/id_rsa
            CWD=$(pwd)
            cd $CONFIG_PATH/../encfs
            git remote set-url origin git@github.com:jandob/encfs.git
            cd $CONFIG_PATH/
            git remote set-url origin git@github.com:jandob/config.git
            cd $dir
        fi
    fi
fi


if checkInstall vim; then
    if [ ! -e $HOME/.vim/bundle/ ];then
        mkdir -p $HOME/.vim/bundle
        git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
    fi
    makeLink $CONFIG_PATH/bundle.local $HOME/.vim
    makeLink $HOME/.encfs/wiki $HOME/.vim
fi
if checkInstall cronie; then
    exesudo makeLink $CONFIG_PATH/etc/cron.hourly/pacmansync /etc/cron.hourly
fi

if checkInstall awesome; then
    checkInstall xorg-server
    checkInstall xorg-xinit
    checkInstall xorg-utils
    checkInstall xorg-server-utils
    checkInstall xterm
    checkInstall ttf-dejavu
    checkInstall vicious
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
