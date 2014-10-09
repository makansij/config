#!/bin/bash

if [ -d "$1" ]; then
    echo "converting all in folder $1"
fi

for p in "$@"; do
    echo $p
done

exit 0
#vlc version
acodec="mp3"
arate="128"
ext="mp3"
mux="ffmpeg"
vlc="/usr/bin/vlc"
fmt="mp4"

#for a in *$fmt; do
$vlc -I dummy -v "$1" --sout "#transcode{acodec=$acodec}:standard{mux=$mux,dst=\"$1.$ext\",access=file}" vlc://quit
#done
