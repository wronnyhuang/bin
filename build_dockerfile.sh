#!/usr/bin/env bash
ssh -t ronny@tomg3264.cs.umd.edu sh -c "cd \$HOME/bin && git pull && cd dockerfile && docker build -t wrhuang/add . && docker push wrhuang/add"