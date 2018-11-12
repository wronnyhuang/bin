#!/bin/bash
if [ $1 = "n" ]; then
	watch -n .1 nvidia-smi
elif [ $1 = "p" ]; then
	watch -n .1 'ps aux | grep python'
elif [ $1 = "l" ]; then
	watch -n .1 read_logs.sh $2 specreg
elif [ $1 = "a" ]; then
	userhost=( ronny@tricky.cs.umd.edu ronny@tomg3264.cs.umd.edu rhuang@max.cs.umd.edu )
	for uh in "${userhost[@]}"
	do
		ssh -t $uh "nvidia-smi"
	done
fi
