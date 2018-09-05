#!/bin/bash
logdir=${1:-./}
echo tensorboarding directory $logdir
tensorboard --logdir $logdir --port 6009
