#!/bin/bash

args=("$@")
recycle_bin="$HOME/deleted"

if [ ${#args} == 0 ]
then
	echo "error - no filename provided"
	exit 1
fi

for file in ${args[@]}
do
	echo "log - processing $file"
	if [ ! -f $file ]
	then
		echo "error - $file does not exist"
		exit 1
	fi
done
