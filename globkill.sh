#!/bin/bash
userhost=( ronny@tricky.cs.umd.edu ronny@tomg3264.cs.umd.edu rhuang@max.cs.umd.edu ronny@dsvm6usdum456zy76.eastus.cloudapp.azure.com)
for uh in "${userhost[@]}"
do
	ssh -t $uh "rek $1"
done
