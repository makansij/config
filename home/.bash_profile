#
# ~/.bash_profile
#
[[ -f ~/.bashrc ]] && . ~/.bashrc
inotifywait -d -e create -e delete --timefmt "%c" --format "%T, %e %w%f" \
    --exclude "fasd|Xauthority" -o $HOME/homedir.log $HOME
eval $(ssh-agent)
if type startx >/dev/null 2>&1; then
    [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
fi
