#/bin/bash
input=$1
username=rhuang
host=max.cs.umd.edu
if [ $input = "t" ]; then
	echo tensorboard port mode
	ssh -L 16006:localhost:6009 $username@$host
elif [ $input = "j" ]; then
	echo jupyter port mode
	ssh -L 8889:localhost:8889 $username@$host
elif [ $input = "x" ]; then
	echo x-windows mode
	ssh -X $username@$host
elif [ $input = "i" ]; then
	scp ~/.vimrc $username@$host:~
	scp ~/.inputrc $username@$host:~
	scp ~/bin/watch_nvidia.sh $username@$host:~/bin
	scp ~/bin/watch_process.sh $username@$host:~/bin
	ssh $username@$host
else
	ssh $username@$host
fi
