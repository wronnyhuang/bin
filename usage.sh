#!/usr/bin/env bash

while true ; do
    echo -n `date`,\  >> usage.log
    nvidia-smi | grep -oh "[0-9]*\%" | while read perc ; do echo -n $perc,\  >> usage.log ; done
    echo "" >> usage.log
    sleep 60
done
