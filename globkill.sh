#!/bin/bash
userhost=( ronny@tricky.cs.umd.edu ronny@tomg3264.cs.umd.edu rhuang@max.cs.umd.edu )
for uh in "${userhost[@]}"
do
	ssh -t $uh "pkill -f log_root=$1"
done
