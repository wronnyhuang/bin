#!/usr/bin/env bash
imagename=$1
docker build -t $imagename -f Dockerfile .