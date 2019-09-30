#!/usr/bin/env bash

while true ; do
    echo -ne `date`,\t >> usage.log
    nvidia-smi | grep -oh "[0-9]*\%" | while read perc ; do echo -ne $perc,\t >> usage.log ; done
    echo "" >> usage.log
    sleep 1
done
