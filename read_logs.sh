#!/bin/bash
log_root=$1
var=$log_root
exptname=$2
logdir=~/ckpt/$exptname
echo ------------------- TRAIN LOG $var  --------------------
tail -n 5 logdir/$var/logtrain.log
var=$(($var+1))
echo ------------------- TRAIN LOG $var  --------------------
tail -n 5 logdir/$var/logtrain.log
var=$(($var+1))
echo ------------------- TRAIN LOG $var  --------------------
tail -n 5 logdir/$var/logtrain.log
var=$(($var+1))
echo ------------------- TRAIN LOG $var  --------------------
tail -n 5 logdir/$var/logtrain.log
var=$log_root
echo ------------------- EVAL LOG $var  --------------------
tail -n 5 logdir/$var/logeval.log
var=$(($var+1))
echo ------------------- EVAL LOG $var  --------------------
tail -n 5 logdir/$var/logeval.log
var=$(($var+1))
echo ------------------- EVAL LOG $var  --------------------
tail -n 5 logdir/$var/logeval.log
var=$(($var+1))
echo ------------------- EVAL LOG $var  --------------------
tail -n 5 logdir/$var/logeval.log
