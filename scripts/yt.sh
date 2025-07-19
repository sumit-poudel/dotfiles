#!/bin/bash
format=$1

if [ -z "$format" ];then
    echo "pass format "
else
case "$format" in
    audio)
        echo "you choosed $format"
        echo "Enter your url"
        read url
yt-dlp -x --audio-format mp3 -f bestaudio "$url"
        ;;
    video)
        echo "you choosed $format"
        echo "Enter your url"
        read url
yt-dlp -f bestvideo+bestaudio "$url"
        ;;
    *)
        echo "wrong format"
        ;;
esac
fi
