#!/usr/bin/env bash
curl -s http://localhost:4040/api/tunnels | python3 -c \
	"import sys, json; address = json.load(sys.stdin)['tunnels'][0]['public_url']; print(address)"
