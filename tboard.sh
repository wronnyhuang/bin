#!/bin/bash
pkill -f 'tensorboard --port=6006'
logdir=${1:-~/ckpt/}
nohup tensorboard --port=6006 --logdir=$logdir 2> /tmp/nohup.out &
echo tensorboarding directory $logdir
if [ $2 = "n" ]; then
	pkill -f "ngrok http 6006"
	nohup ngrok http 6006 2> /tmp/nohup.out &
	echo tunneling with ngrok
	sleep 1
	curl -s http://localhost:4040/api/tunnels | python3 -c \
    "import sys, json; print(json.load(sys.stdin)['tunnels'][0]['public_url'])"
fi
