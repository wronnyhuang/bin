#!/usr/bin/env bash

while true ; do
    echo -n -e `date`,\t >> usage.log
    nvidia-smi | grep -oh "[0-9]*\%" | while read perc ; do echo -n -e $perc,\t >> usage.log ; done
    echo "" >> usage.log
    sleep 1
done
