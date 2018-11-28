#!/usr/bin/env bash
cd /root/bin/dockerfile
docker build -t --build-arg CACHEBUST=$(date +%s) wrhuang/default .
cd -