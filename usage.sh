#!/usr/bin/env bash

while true ; do
    echo `date` >> usage.log
    nvidia-smi | grep -oh "[0-9]*\%" | while read perc ; do echo -n $perc,\  >> usage.log ; done && printf "\n"
    sleep 1
done
