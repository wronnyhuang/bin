#!/bin/bash
log_root=$1
var=$log_root
echo ------------------- TRAIN LOG $var  --------------------
tail -n 5 $var/logtrain.log
var=$(($var+1))
echo ------------------- TRAIN LOG $var  --------------------
tail -n 5 $var/logtrain.log
var=$(($var+1))
echo ------------------- TRAIN LOG $var  --------------------
tail -n 5 $var/logtrain.log
var=$(($var+1))
echo ------------------- TRAIN LOG $var  --------------------
tail -n 5 $var/logtrain.log
var=$log_root
echo ------------------- EVAL LOG $var  --------------------
tail -n 5 $var/logeval.log
var=$(($var+1))
echo ------------------- EVAL LOG $var  --------------------
tail -n 5 $var/logeval.log
var=$(($var+1))
echo ------------------- EVAL LOG $var  --------------------
tail -n 5 $var/logeval.log
var=$(($var+1))
echo ------------------- EVAL LOG $var  --------------------
tail -n 5 $var/logeval.log
