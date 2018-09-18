#!/bin/bash
pkill -f 'tensorboard --port=6006'
logdir=${1:-~/ckpt/specreg/}
echo $logdir
nohup tensorboard --port=6006 --logdir=$logdir &
echo tensorboarding directory $logdir
if [ $2 = "n" ]; then
	pkill -f ngrok
	nohup ngrok http 6006 &
	echo tunneling with ngrok
	sleep 1
	curl -s http://localhost:4040/api/tunnels | python3 -c \
    "import sys, json; print(json.load(sys.stdin)['tunnels'][0]['public_url'])"
fi
