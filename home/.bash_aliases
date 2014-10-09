#!/bin/bash
# Author.: Janosch
# Date...: 03.07.2012
# License: Whatever


# make-cd-alias-with-completion <alias> <path>
# eg.  make-cd-alias-with-completion cduni $HOME/Dropbox/UNI
# defines a function called cduni and a function _cduni_alias
# that will complete the 'cduni' alias.

# function make-cd-alias-with-completion () {
# 	local alias_name="$1"
# 	local alias_target="$2"
# 	local function="
#     $alias_name () {
#       local path="$alias_target"
#       cd "'$path'"
#     }"
# 	eval "$function"
# 	function='
#   function _'$alias_name'_alias (){
#       local cur opts saveIFS savedir
#       #savedir=$(pwd)
#       saveIFS=$IFS
#       IFS=$'\'\\n\''
#       cur="${COMP_WORDS[COMP_CWORD]}"
#       cd '$alias_target'
#       opts=$(compgen -d -o plusdirs)
#       COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
#       IFS=$saveIFS
#       #cd $savedir
#     }'
# 	eval "$function"
#   complete -o plusdirs -F _"$alias_name"_alias -o nospace -o plusdirs $alias_name

function make-cd-alias-with-completion () {
	local alias_name="$1"
	local alias_target="$2"
	local function="
    $alias_name () {
      cd $alias_target"/'$1'"
    }"
	eval "$function"
	function='
  function _'$alias_name'_alias (){
     local cur opts saveIFS
     saveIFS=$IFS
     IFS=$'\'\\n\''
     cur="${COMP_WORDS[COMP_CWORD]}"
     opts=$(compgen -o nospace -S "/" -d '$alias_target'/$cur | sed s:'$alias_target'/::)
     COMPREPLY=($(compgen -o nospace -W "${opts}" -- ${cur}))
     IFS=$saveIFS
    }'
	eval "$function"
  complete -o nospace -F _"$alias_name"_alias  $alias_name
}
make-cd-alias-with-completion cduni $HOME/Dropbox/UNI
make-cd-alias-with-completion cdswt $HOME/Dropbox/UNI/Softwaretechnik/swt201204/code
make-cd-alias-with-completion cdconf $HOME/Dropbox/config

alias ..='cd ..'
alias ...="cd ../.."
md () { mkdir -p "$1" && cd "$1"; }
alias searchinstalled='dpkg --get-selections|grep'
alias listfilesinpackage='dpkg -L'
o () { xdg-open "$@" >/dev/null 2>&1 & }
#o () { mimeopen "$@" >/dev/null 2>&1 & }
seto () { mimeopen -d "$@"; }
alias bashreload="reset;exec bash"
alias bashmodevim="set -o vi"
alias bashmodeemacs="set -o emacs"
alias vimbash="vim -o ~/.bash_aliases ~/.bashrc -c 'set syntax=sh'"
alias vimall="vim -o **"
alias vimnonen="vim -u NONE"
alias cds="cdsmart"
cdsmart () {
    local target="$HOME"
    [[ -n $1 ]] && target="$1"
    if [[ -h "$1" ]]; then
        if [ -d "$1" ]; then
            target="$(readlink -f "$1")"
        elif [ -f "$1" ]; then
            target="$(dirname $(readlink -f "$1"))"
        fi
    else
        if [[ -f "$1" ]]; then
            target=$(dirname "$1")
        fi
    fi
    if [[ $- == *i* ]]; then
        echo wd: $(realpath "$target")
    fi
    cd "$target"
}
sourceros () {
  if [ -f /opt/ros/electric/setup.sh ]; then
    source ~/ros_workspace/setup_electric.sh
  fi
  if [ -f /opt/ros/fuerte/setup.sh ]; then
    source ~/ros_workspace/setup_fuerte.sh
  fi
  if [ -f ~/rosjava_workspace/setup.sh ]; then
    source ~/rosjava_workspace/setup.sh
  fi
}

openlink () {
  local link=`cat $1`
  if type chromium > /dev/null
  then
    chromium $link #| tail -1
  else
    xdg-open $link
  fi
}
function printargs { for F in "$@" ; do echo "$F" ; done ; }
function psq { ps ax | grep -i $@ | grep -v grep ; }
function printarray {
for ((i=0;$i<`eval 'echo ${#'$1'[*]}'`;i++)) ; do
    echo $1"[$i]" = `eval 'echo ${'$1'['$i']}'`
done
}
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=critical -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias t='tree'

# alias l='ls -CF'
# what most people want from od (hexdump)
alias hd='od -Ax -tx1z -v'
strerror() { python -c "\
import os,locale as l; l.setlocale(l.LC_ALL, ''); print os.strerror($1)"; }

### Bash Directory Bookmarks ###################################################

### Create a bookmark for the /var/www directory
# user@host[/var/www/] : m1
### cd into /var/www
# user@host[/etc/apache2] : g1
### list bookmarks
# user@host[/usr/local/] : lma
# g1='cd /var/www/'
# g2='cd /etc/'
### save bookmarks
# mdump
alias m1='alias g1="cd `pwd`"'
alias m2='alias g2="cd `pwd`"'
alias m3='alias g3="cd `pwd`"'
alias m4='alias g4="cd `pwd | sed "s/\ /\\\ /g"`"'
alias m5='alias g5="cd `pwd`"'
alias m6='alias g6="cd `pwd`"'
alias m7='alias g7="cd `pwd`"'
alias m8='alias g8="cd `pwd`"'
alias m9='alias g9="cd `pwd`"'
alias mdump='alias|grep -e "alias g[0-9]"|grep -v "alias m" > ~/.bookmarks'
alias lma='alias | grep -e "alias g[0-9]"|grep -v "alias m"|sed "s/alias //"'
touch ~/.bookmarks
source ~/.bookmarks

alias rsync="rsync -P"
## fast copy
copy () {
    rm -rf /tmp/.copyBuffer
    mkdir /tmp/.copyBuffer
    cp -r "$@" /tmp/.copyBuffer
}
copypaste () {
    if [ "$#" -ne 1 ]; then
        echo "only one destination allowed"
        return
    fi
    shopt -q dotglob
    local dotglobwasset=$?

    shopt -s dotglob
    cp -r /tmp/.copyBuffer/* "$1"

    if [ $dotglobwasset -ne 0 ];then
        #dotglob was not set before"
        shopt -u dotglob
    fi
}

# garchdeps aliases
garchdepsgraph () {
    local ret=$(garchdeps.py -f "$1" -g /tmp/graph.dot)
    if [ "$ret" = "Package not found" ]; then
        echo "package not found"
        return
    fi
    tred /tmp/graph.dot | dot -Tpng  -o /tmp/graph.png
    feh /tmp/graph.png
}
garchdepsreverse () {
    garchdeps.py -f "$1" -r -s totalsize
}
alias garchdepssummary='garchdeps.py -i'
alias garchdepsinfo='garchdeps.py'

alias y='yaourt'
alias yforce='yaourt --noconfirm'
alias ysearchinstalled='yaourt -Qs'
alias ylistfilesinpackage='yaourt -Ql'
alias yfullupdate='yaourt -Syua'
alias pacmanfullupdate='sudo pacman -Syu --noconfirm'
alias yfullupdateforce='yaourt -Syua --noconfirm'
alias ylistinstalledbydate='yaourt -Q --date'
alias ylistexplicitbydate='yaourt -Qe --date'
alias ydownloadpkgbuild='yaourt -G'

# Pacman alias
alias pacupg='sudo pacman -Syu'         # Synchronize with repositories before upgrading packages that are out of date on the local system.
alias pacin='sudo pacman -S'            # Install specific package(s) from the repositories
alias pacins='sudo pacman -U'           # Install specific package not from the repositories but from a file
alias pacremwodepconf='sudo pacman -R'  # Remove the specified package(s), retaining its configuration(s) and required dependencies
alias pacremwodep='sudo pacman -Rn'     # Remove the specified package(s) and unneeded dependencies
alias pacrem='sudo pacman -Rns'         # Remove the specified package(s), its configuration(s) and unneeded dependencies
alias pacremcascade='sudo pacman -Rsnc' # Remove package and all that depend on it and dependencies and configfiles
alias pacrep='pacman -Si'               # Display information about a given package in the repositories
alias pacreps='pacman -Ss'              # Search for package(s) in the repositories
alias pacloc='pacman -Qi'               # Display information about a given package in the local database
alias paclocs='pacman -Qs'              # Search for package(s) in the local database
alias pacwhatprovides='pkgfile'
alias pacwhich='pacman -Qo'

# Additional pacman alias
alias pacupd='sudo pacman -Sy && sudo abs'     # Update and refresh the local package and ABS databases against repositories
alias pacinsd='sudo pacman -S --asdeps'        # Install given package(s) as dependencies of another package
alias pacmir='sudo pacman -Syy'                # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist
alias paclistaur='pacman -Qqm'                 # lists foreign packages; which, for most users, means AUR
alias paclistexplicitely='pacman -Qqe'         # lists packages that were explicitely installed.
alias pacbackuplist='pacman -Qqe | grep -v "$(pacman -Qqm)" > pacman_backup.lst'
alias pacinstallbackup='cat pacman_backup.lst | xargs pacman -S --needed --noconfirm'
alias paccheckpackage='pacman -Qkk'

pac_rem_orphans() {
  if [[ ! -n $(pacman -Qdt) ]]; then
      echo "No orphans to remove."
  else
      sudo pacman -Rs $(pacman -Qdtq)
  fi
}

alias archstartsshdeamon='systemctl enable sshd.service'
alias tunneltouni='ssh -N -R 10042:localhost:22 doblerj@login.informatik.uni-freiburg.de'
#alias tunnelconnect='ssh h4ct1c@localhost -p 10042'
alias tunnelfromuni='ssh -N -L 10042:localhost:10042 doblerj@login.informatik.uni-freiburg.de &'
alias tunnelconnect='ssh localhost -p 10042'
alias sshuni='ssh doblerj@login.informatik.uni-freiburg.de'
alias sshdyndns='ssh h4ct1c.mooo.com'
alias sshraspberrypi='ssh h4ct1c.mooo.com'
alias speedometer='speedometer -r wlan0 -t wlan0'
alias wifireset='sudo systemctl restart netctl-auto@wlan0.service'

alias mountuni='sshfs jd105@login.uni-freiburg.de:/home/jd105 ~/temp/uni'
alias umountuni='fusermount -u ~/temp/uni'
alias mountunitf='sshfs doblerj@login.informatik.uni-freiburg.de:/home/doblerj ~/temp/uni_tf'
alias umountunitf='fusermount -u ~/temp/uni_tf'
#alias mountasuser='sudo mount -o gid=users,fmask=113,dmask=002'
alias mountasuser='sudo mount -o gid=users,uid=$USER,dmask=007,fmask=117'
alias mountasuserntfs='sudo mount -t ntfs-3g -o gid=users,uid=$USER'
alias mountdata='sudo mount -o \
    defaults,discard,noatime,ssd,compress-force=zlib,subvol=__active /dev/sda7 \
        /mnt/data/'
# note the usermapping file can be generated with the tool ntfs-3g.usermap
alias mountwin='sudo mount -t ntfs-3g -o \
    usermapping=~/.usermapping /dev/sda2 /mnt/win/'
alias mountbtrfsroot='sudo mount -o \
    defaults,discard,noatime,ssd /dev/sdb2 /mnt/btrfs-root'
alias mountubuntu='sudo mount /dev/sda6 /mnt/ubuntu'
alias mountall='mountubuntu; mountbtrfsroot; mountwin; mountdata'
alias umountall='sudo umount /mnt/*'

alias inotifywaitcreatedelete='inotifywait -m -r -e create -e delete --timefmt "%c" --format "%T, %e %w%f"'
start2ndxsessionwithwm() {
  echo "exec $1" > /tmp/.start_qtile ; xinit /tmp/.start_qtile -- :2
}

alias screenlock='xscreensaver-command --lock'
alias screenoff='xset dpms force off'
alias screenofflock='screenoff; screenlock'
alias webserver='python2 -m SimpleHTTPServer 8080'
alias jabber='gajim'

alias mousereset='sudo rmmod psmouse && sudo modprobe psmouse'
alias dropboxconflictslist='find ~/Dropbox/ -regex .*[CK]onfli[ck]t.*'
alias dropboxconflictsremove='find ~/Dropbox/ -regex .*[CK]onfli[ck]t.* -exec rm -r {}\; 2>/dev/null'


#type -t pavucontrol 2>&1 > /dev/null
#if [$? -eq 0]; then
#  alias sound='pavucontrol'
#else
#  alias sound='alsamixer'
#fi

alias sound='alsamixer'
hash pavucontrol 2>/dev/null && alias sound='pavucontrol' #overwrite alias if pavucontrol available


alias showuskeyboard='geeqie -t ~/us_layout.png'
alias ports='netstat -tulanp'
alias ips='netstat -an | grep ESTABLISHED'
alias cyberghost_ru='sudo openvpn --config /etc/openvpn/cyberghost_ru.ovpn'
alias cyberghost_uk='sudo openvpn --config /etc/openvpn/cyberghost_uk.ovpn'
alias cyberghost_us='sudo openvpn --config /etc/openvpn/cyberghost_us.ovpn'

alias chownclone='chown --reference=$1 $2'
alias chmodclone='chmod --reference=$1 $2'

# A shortcut function that simplifies usage of xclip.
# - Accepts input from either stdin (pipe), or params.
# ------------------------------------------------
cb() {
  local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'
  # Check that xclip is installed.
  if ! type xclip > /dev/null 2>&1; then
    echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
  # Check user is not root (root doesn't have access to user xorg server)
  elif [[ "$USER" == "root" ]]; then
    echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
  else
    # If no tty, data should be available on stdin
    if ! [[ "$( tty )" == /dev/* ]]; then
      input="$(< /dev/stdin)"
    # Else, fetch input from params
    else
      input="$*"
    fi
    if [ -z "$input" ]; then  # If no input, print usage message.
      echo "Copies a string to the clipboard."
      echo "Usage: cb <string>"
      echo "       echo <string> | cb"
    else
      # Copy input to clipboard
      echo -n "$input" | xclip -selection c
      # Truncate text for status
      if [ ${#input} -gt 80 ]; then input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"; fi
      # Print status.
      echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
    fi
  fi
}
function runWithAppendedShebang() {
    # This function reads and returns the shebang from given file if exist.
    #
    # Examples:
    #
    # # /usr/bin/env python -O /path/to/script.py
    # >>> appendShebang -O -- /path/to/script.py
    # ...
    #
    # # /usr/bin/env python -O /path/to/script.py argument1 argument2
    # >>> runWithAppendedShebang -O -- /path/to/script.py argument1 argument2
    # ...
    local shebangArguments='' && \
    local arguments='' && \
    local applicationPath='' && \
    local shebangArgumentsEnded=false && \
    while true; do
        case "$1" in
            --)
                shebangArgumentsEnded=true
                shift
                ;;
            '')
                shift
                break
                ;;
            *)
                if ! $shebangArgumentsEnded; then
                    shebangArguments+=" $(validateBashArgument "$1")"
                elif [[ ! "$applicationPath" ]]; then
                    applicationPath="$1"
                else
                    arguments+=" $(validateBashArgument "$1")"
                fi
                shift
                ;;
        esac
    done
    local applicationRunCommand="$(head --lines 1 "$applicationPath" | sed \
        --regexp-extended \
        's/^#!(.+)$/\1/g')${shebangArguments} ${applicationPath}
$arguments" && \
    # NOTE: The following line could be useful for debugging scenarios.
    #echo "Run: \"$applicationRunCommand\"" && \
    eval "$applicationRunCommand"
    return $?
}
validateBashArgument() {
    # Validates a given bash argument.
    #
    # Examples:
    #
    # >>> validateBashArgument hans
    # 'hans'
    #
    # >>> validateBashArgument ha'n's
    # "ha'n's"
    #
    # >>> validateBashArgument h"a"'n's
    # 'h"a"\'n\'s'
    if [[ ! "$(grep "'" <<< "$1")" ]]; then
        echo "'$1'"
    elif [[ ! "$(grep '"' <<< "$1")" ]]; then
        echo "\"$1\""
    else
        echo "'$(sed "s/'/\\'/g" <<< "$1")'"
    fi
    return $?
}
# Aliases / functions leveraging the cb() function
# ------------------------------------------------
# Copy contents of a file
function cbf() { cat "$1" | cb; }
# Copy SSH public key
alias cbssh="cbf ~/.ssh/id_rsa.pub"
# Copy current working directory
alias cbwd="pwd | cb"
# Copy most recent command in bash history
alias cbhs="cat $HISTFILE | tail -n 1 | cb"

#project specific

alias boostWebServer='python2 -O ~/Dropbox/projects/boostNode/runnable/server.py'
alias rmChangeDirectory='cd ~/Dropbox/projects/remindme/'
alias rmStartDevelopmentServer='reset;rmChangeDirectory && runWithAppendedShebang -O -d -- __init__.py -l debug'
