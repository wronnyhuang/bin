#!/usr/bin/env bash
userhost=( paperspace@74.82.31.21 paperspace@65.49.81.37 paperspace@184.105.87.14 paperspace@74.82.31.120 )
for uh in "${userhost[@]}"
do
    ssh -t $uh "git clone https://github.com/wronnyhuang/metapoison"
done
