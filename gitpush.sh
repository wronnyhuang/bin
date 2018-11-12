#!/bin/bash
message=${1:wip}
git add .
git commit -m $message
git push
