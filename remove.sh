#!/bin/bash

args=("$@")
recycle_bin="$HOME/deleted"

if [ -d "$recycle_bin" ];
then
	echo "deleted directory does exist"
else
	echo "deleted directory does NOT exist"
	echo "creating directory"
	mkdir $recycle_bin
fi

if [ ${#args} == 0 ];
then
       echo "no filename provided"
       exit 1
fi

for file in ${args[@]}
do
	echo $file
	if [ -d $file ]
	then
		echo "directory name provided"
		exit 1
	elif [ ! -f $file ]
	then
		echo "$file does not exist"
		exit 1
	fi
done

echo "end of script"
