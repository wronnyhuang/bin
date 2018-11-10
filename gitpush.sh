#!/bin/bash
message=${1:wip}
gitcommit.sh
git add .
git commit -m $message
git push
