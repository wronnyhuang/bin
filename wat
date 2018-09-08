#!/bin/bash
if [ $1 = "n" ]; then
	watch -n .1 nvidia-smi
elif [ $1 = "p" ]; then
	watch -n .1 'ps aux | grep log_root'
elif [ $1 = "l" ]; then
	watch -n .1 read_logs.sh $2
fi
