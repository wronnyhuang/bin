#!/bin/bash
port=8888
pkill -f jupyter-notebook
sleep 1
nohup jupyter notebook --port=$port 2> /tmp/nohup.out &
echo jupyter notebook at port $port
if [ $1 = "n" ]; then
	pkill -f "ngrok http $port" 
	nohup ngrok http $port 2> /tmp/nohup.out &
	echo tunneling with ngrok
	sleep 1
	curl -s http://localhost:4040/api/tunnels | python3 -c \
    "import sys, json; print(json.load(sys.stdin)['tunnels'][0]['public_url'])"
fi
