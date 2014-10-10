# vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{{,}}} foldmethod=marker:
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#{{{  bash cheatsheet - src http://tldp.org/LDP/abs/html/

#{{{ File test operators
# Returns true if...
##-e (file exists)
##-f (file is a regular file (not a directory or device file))
##-s (file is not zero size)
##-d (file is a directory)
##-b (file is a block device)
##-c (file is a character device)
##-p (file is a pipe)
##-h (file is a symbolic link)
##-L (file is a symbolic link)
##-S (file is a socket)
##-t (file (descriptor) is associated with a terminal device) :'
#This test option may be used to check whether the stdin [ -t 0 ] or
#stdout [ -t 1 ] in a given script is a terminal.
##-r (file has read permission (for the user running the test))
##-w (file has write permission (for the user running the test))
##-x (file has execute permission (for the user running the test))
##-g (set-group-id (sgid) flag set on file or directory)
##-u (set-user-id (suid) flag set on file)
##-k (sticky bit set)
##-O (you are owner of file)
##-G (group-id of file same as yours)
##-N (file modified since it was last read)
##f1 -nt f2 (file f1 is newer than f2)
##f1 -ot f2 (file f1 is older than f2)
##f1 -ef f2 (files f1 and f2 are hard links to the same file)
##! ( "not" -- reverses the sense of the tests above (returns true if condition absent).)
#}}}
#{{{ binary comparison operator
#{{{ integer comparison
##-eq (is equal to)      ex.: if [ "$a" -eq "$b" ]
##-ne (is not equal to)
##-gt (is greater than)
##-ge (is greater than or equal to)
##-lt (is less than)
##-le (is less than or equal to)
##< (is less than (within double parentheses)) ex.: (("$a" < "$b"))
##<= (is less than or equal to (within double parentheses))
##> (is greater than (within double parentheses))
##>= (is greater than or equal to (within double parentheses))
#}}}
#{{{ string comparison

##= (is equal to) ex.: if [ "$a" = "$b" ]
#Note the whitespace framing the =.

##== (is equal to)
#This is a synonym for =.
#The == comparison operator behaves differently within a double-brackets test than within single brackets.
#[[ $a == z* ]]   # True if $a starts with an "z" (pattern matching).
#[[ $a == "z*" ]] # True if $a is equal to z* (literal matching).
#[ $a == z* ]     # File globbing and word splitting take place.
#[ "$a" == "z*" ] # True if $a is equal to z* (literal matching).

##!= (is not equal to) ex.: if [ "$a" != "$b" ]
#This operator uses pattern matching within a [[ ... ]] construct.

##<,> (is less/greater than, in ASCII alphabetical order) ex.: if [[ "$a" < "$b" ]]   if [ "$a" \< "$b" ]
# Note that the "<" needs to be escaped within a [ ] construct.

##-z (test string is null resp. has zero length) ex.: if [ -z "$String" ]; then echo "\$String is null."; else echo "\$String is NOT null."; fi

## -n (test string is not null.)
#The -n test requires that the string be quoted within the test brackets.
#Using an unquoted string with ! -z, or even just the unquoted string alone
#within test brackets normally works, however, this is an unsafe practice.
#Always quote a tested string.

##=~ (regex matching) ex.:if [[ "$input" =~ "[0-9][0-9]" ]]
#}}}
#}}}
#Positional Parameters#{{{

## $0, $1, $2, etc.
# Positional parameters, passed from command line to script, passed to a
# function, or set to a variable (see Example 4-5 and Example 15-16)

## $#
# Number of command-line arguments [4] or positional parameters (see Example 36-2)

## $*
# All of the positional parameters, seen as a single word
# "$*" must be quoted.

## $@
# Same as $*, but each parameter is a quoted string, that is, the parameters are
# passed on intact, without interpretation or expansion. This means, among other
# things, that each parameter in the argument list is seen as a separate word.
# Of course, "$@" should be quoted.
#}}}
# Shell expansion #{{{
# from first to last:
# Brace#{{{
# foo{foo,bar,baz}cat -> foofoocat foobarcat foobazcat
#}}}
# Tilde#{{{
# ~ -> $HOME
# ~+ -> $PWD
# ~- -> $OLDPWD
#}}}
# variable and parameters#{{{
# $? -> return/exit code of last command
# ${SHELL} -> bin/bash
# ${!H*} -> HG HISTCMD HISTCONTROL HISTFILE HISTFILESIZE HISTSIZE HOME HOSTNAME HOSTTYPE
## creation of the named variable if it does not yet exist:
# ${FOO:=bar}

#}}}
# command substitution#{{{
# `command` or $(command) # (`` is obsolete)

## word splitting:
# COMMAND `echo a b`     # 2 args: a and b
# COMMAND "`echo a b`"   # 1 arg: "a b"
# COMMAND `echo`         # no arg
# COMMAND "`echo`"       # one empty arg

# $( <FILE ) is the same as $(cat FILE)

## get error output (command subst. only catches stdout)
# $(cp file.txt /some/where 2>&1)
#}}}
# arithmetic expansion


## operators:#{{{
# Operator                | Meaning
# VAR++ and VAR--         | variable post-increment and post-decrement
# ++VAR and --VAR         | variable pre-increment and pre-decrement
# - and +                 | unary minus and plus
# ! and ~                 | logical and bitwise negation
# **                      | exponentiation
# *, / and %              | multiplication, division, remainder
# + and -                 | addition, subtraction
# << and >>               | left and right bitwise shifts
# <=, >=, < and >         | comparison operators
# == and !=               | equality and inequality
# &                       | bitwise AND
# ^                       | bitwise exclusive OR
# |                       | bitwise OR
# &&                      | logical AND
# ||                      | logical OR
# expr ? expr : expr      | conditional evaluation
# =, *=, /=, %=, +=, -=,  |
# <<=, >>=, &=, ^= and |= | assignments
# ,                       | separator between expressions
#}}}
# word splitting#{{{
# TODO
#}}}
# file name expansion#{{{
# TODO
#}}}
#}}}
# usefull unix commands #{{{
# basename - strip directory and suffix from filenames
# dirname - strip last component from file name
#}}}
#}}}
export PATH="~/.bin:$PATH"
export PATH="/usr/lib/colorgcc/bin:$PATH"
#export PATH="`ruby -rubygems -e 'puts Gem.user_dir'`/bin:$PATH"
# If not running interactively, exit
[ -z "$PS1" ] && return
# If not running interactively, exit
[[ $- != *i* ]] && return
#timestart=$(($(date +%s%N)/1000000))

#{{{ get system variables
#HOSTNAME=$(hostname)
#USERNAME=$(whoami)
THIS_TTY=tty
SESS_SRC=`who | grep $THIS_TTY | awk '{ print $6 }'` # screen "(:0)" or conn src
SSH_FLAG=0 #are we in a ssh session?
SSH_IP=`echo $SSH_CLIENT | awk '{ print $1 }'`
if [ $SSH_IP ] ; then
  SSH_FLAG=1
fi
SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`
if [ $SSH2_IP ] ; then
  SSH_FLAG=1
fi
ROOT_FLAG=0 #are we root?
if [ `whoami` = "root" ] ; then
  ROOT_FLAG=1
fi

#}}}
#{{{ set prompt
PS1='[\u \W]\$ ' #normal
#PS1='[\u@\h \W]\$ ' #normal with host (archlinux std)

COLOR_NOCOLOR='\[\033[0m\]'
COLOR_RED='\[\033[0;31m\]'
COLOR_REDBRIGHT='\[\033[1;31m\]'
COLOR_GREEN='\[\033[0;32m\]'
COLOR_GREENBRIGHT='\[\033[1;32m\]'
COLOR_YELLOW='\[\033[1;33m\]'

if [[ $ROOT_FLAG = 0 && $SSH_FLAG = 0 ]] ; then
  PS1="$COLOR_GREEN$PS1$COLOR_NOCOLOR"
elif [[ $ROOT_FLAG = 0 && $SSH_FLAG = 1 ]] ; then
  PS1="$COLOR_YELLOW$PS1$COLOR_NOCOLOR"
elif [[ $ROOT_FLAG = 1 && $SSH_FLAG = 0 ]] ; then
  PS1="$COLOR_RED$PS1$COLOR_NOCOLOR"
elif [[ $ROOT_FLAG = 1 && $SSH_FLAG = 1 ]] ; then
  PS1="$COLOR_REDBRIGHT$PS1$COLOR_NOCOLOR"
fi

#}}}

#BASHDEBUG='yes'
BASHDEBUG=${KBWDEBUG:-no}

function dprint {
if [[ "$BASHDEBUG" == "yes" && "$-" == *i* ]]; then
    #date "+%H:%M:%S $*"
    echo $SECONDS $*
fi
}
dprint alive
if [ -r "${HOME}/.bashrc.local.preload" ]; then
    dprint "Loading bashrc preload"
    source "${HOME}/.bashrc.local.preload"
fi

function have { type "$1" &>/dev/null ; }

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend


# after each command, save and reload history. This enables one history for all
# shells
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
#export PROMPT_COMMAND="history -a; history -c; history -r"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=100000

shopt -s checkwinsize # don't get confused by resizing
shopt -s checkhash # if hash is broken, doublecheck it
shopt -s cdspell # be tolerant of cd spelling mistakes

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#    ;;
#*)
#    ;;
#esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi





# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#     . /etc/bash_completion
# fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    alias sudo='sudo '
    . ~/.bash_aliases
fi



### my stuff
export EDITOR=vim
export SUDO_EDITOR="/usr/bin/vim -p -X"
set show-all-if-ambiguous on # show completion on first hit
export EDITOR=vim
export GOPATH=~/go
#export PATH=~/go/bin:$PATH
#export CDPATH="./:~/Dropbox/"

#setup fasd
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache
alias oo='a -e xdg-open' # quick opening files with xdg-open
alias v='f -e vim' # quick opening files with vim
alias vv='f -i -e vim' # quick opening files with vim
alias j='fasd_cd -d'     # cd, same functionality as j in autojump
alias jj='fasd_cd -d -i' # cd with interactive selection
_fasd_bash_hook_cmd_complete v vv j jj oo

#setup machine specific things {{{

if [ "$HOSTNAME" == 'vieste' ]; then
    sourceros
fi
if [ "$HOSTNAME" == 'ubuntu-leelo' ]; then
    source ~/rosjava_workspace/setup.bash
    #source ~/ros_workspace/setup.bash
fi

extract () {
     if [ -f "$1" ] ; then
         case $1 in
           *.tar.bz2)   tar xvjf "$1" ;;
           *.tarbz2)    tar xvjf "$1" ;;
           *.tbz2)      tar xvjf "$1" ;;
           *.tar.xz)    tar Jxvf "$1" ;;
           *.xz)        unxz     "$1" ;;
           *.tar.gz)    tar xvzf "$1" ;;
           *.tgz)       tar xvzf "$1" ;;
           *.tar)       tar xvf  "$1" ;;
           *.bz2)       bunzip2  "$1" ;;
           *.rar)       unrar x  "$1" ;;
           *.gz)        gunzip   "$1" ;;
           *.zip)       unzip    "$1" ;;
           *.Z)      uncompress  "$1" ;;
           *.7z)        7z x     "$1" ;;
           *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
function splitpdf() {
    if [ $# -lt 4 ]
    then
            echo "Usage: pdfsplit input.pdf first_page last_page output.pdf"
            exit 1
    fi
    yes | gs -dBATCH -sOutputFile="$4" -dFirstPage=$2 -dLastPage=$3 -sDEVICE=pdfwrite "$1" >& /dev/null
}
function mergepdf() {
    if [ ! "$2" ]; then
        echo ":: Not enough input files"
        return 1
    else
        gs -sDEVICE=pdfwrite -sOutputFile=merged.pdf -dBATCH -dNOPAUSE "$@"
        return 0
    fi
}

function dos2unix() {
    if [ "$#" -lt "2" ]; then
        echo ":: Not enough input files"
        echo ":: Usage: dos2unix input output"
        return 1
    else
        tr -d '\r' < $1 > $2 && mv $2 $1
        iconv -f ISO-8859-1 -t UTF-8 $1 > $2 && mv $2 $1
    fi
}

function sperren() {
  sleep 10
  export COORDINS=`xdotool getmouselocation 2>/dev/null | sed 's/x:\([0-9]\+\)[
  \t]y:\([0-9]\+\)[ \t].*/\1;\2/'`
  export XPOS=${COORDINS/;*/}
  export YPOS=${COORDINS/*;/}
  xdotool
  read -n 1
  _sperr_fork &
  zenity --warning --text="not this time! :)"
}

function _sperr_fork() {
  sleep 10
  gnome-screensaver-command -l
}

function waitForMouseMove() {
  getMouseCoord
  XPOSOLD = $XPOS
  YPOSOLD = $YPOS
  while [ $XPOSOLD != $XPOSOLD ]; do
    sleep 0.1
  done
}
function getMouseCoord() {
  export COORDINS=`xdotool getmouselocation 2>/dev/null | sed 's/x:\([0-9]\+\)[\t]y:\([0-9]\+\)[ \t].*/\1;\2/'`
  export XPOS=${COORDINS/;*/}
  export YPOS=${COORDINS/*;/}
}
function addtocdpath() {
  cp ~/.bashrc ~/.bashrc_backup
  local tempfilename=$RANDOM
  local pathtoadd="$1"
  local bashrcpath=~/.bashrc
  local cdpath=$(grep '^export CDPATH=' "$bashrcpath" | sed 's/.*CDPATH="\(.*\)".*/\1/')
  local cdpathlinecount=$(grep '^export CDPATH=' "$bashrcpath" | wc -l)
  if [ $cdpathlinecount != 1 ]; then
    echo $cdpathlinecount 'occurences of "^export CDPATH" in bashrc found, aborting...'
  else
    sed -i 's/\(^export CDPATH="\)\(.*\)/\1:\2/'$pathtoadd $bashrcpath
    export CDPATH=$cdpath:$pathtoadd
    echo "new CDPATH=$CDPATH"
    cat tmpfilecdpath
  fi

}
#timenow=$(($(date +%s%N)/1000000))
#awk "BEGIN{print $timenow-$timestart}"
# vim: set fdm=marker
