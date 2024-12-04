#!/bin/bash

args=("$@")
recycle_bin="$HOME/deleted"

if [ -d "$recycle_bin" ];
then
	echo "log - deleted directory does exist"
else
	echo "log - deleted directory does NOT exist, creating directory"
	mkdir $recycle_bin
fi

if [ ${#args} == 0 ];
then
       echo "error - no filename provided"
       exit 1
fi

for file in ${args[@]}
do
	echo "log - processing $file"

	if [ -d $file ]
	then
		echo "error - director name provided"
		exit 1
	elif [ ! -f $file ]
	then
		echo "error - $file does not exist"
		exit 1
	elif [ $(readlink -f $file) == $(readlink -f $HOME/project/remove.sh) ]
	then	
		echo "error - attempting to delete remove - operation aborted"
		exit 1
	else
		read -a file_info <<< $(ls -i $file)
		read orig_file_path <<< $(readlink -f $file)
		new_file_name="${file_info[1]}_${file_info[0]}"
		echo "log - removed file will be called $new_file_name"
		tee -a $HOME/.restore.info <<< "$new_file_name:$orig_file_path"
		mv $file $recycle_bin/$new_file_name
	fi
done

echo "log - end of script"
