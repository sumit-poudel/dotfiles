#!/bin/bash
if [ "$1" = "start" ];then
    pkill mpvpaper
    swww kill
    mpvpaper all -o "--loop --vid no-audio" /home/sumit/Videos/liveWallpaper/purpleEyes.mp4
elif [ "$1" = "stop" ];then
    pkill mpvpaper
    swww-daemon
else
    echo "Usages $0 [start|stop]"
fi 
