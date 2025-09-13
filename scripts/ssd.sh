#!/bin/bash
status=$(cat /sys/bus/pci/devices/0000:04:00.0/power/control)
if [ "$status" == "on"  ];then
	echo "powering auto ssd"
echo auto | sudo tee /sys/bus/pci/devices/0000:04:00.0/power/control
else
	echo "on powering directly"
echo on | sudo tee /sys/bus/pci/devices/0000:04:00.0/power/control
fi
