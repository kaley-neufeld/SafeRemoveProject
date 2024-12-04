#!/bin/bash

args=("$@")
recycle_bin="$HOME/deleted"
yes_array=("y" "Y" "yes")

if [ ${#args} == 0 ]
then
	echo "error - no filename provided"
	exit 1
fi

for file in ${args[@]}
do
	echo "log - processing $file"
	if [ ! -f $recycle_bin/$file ]
	then
		echo "error - $file does not exist"
		exit 1
	else
		read restore_info <<< $(grep -i $file $HOME/.restore.info)
		read orig_file_path <<< $(cut -d ":" -f2 <<< $restore_info)
		echo "original file path: $orig_file_path"
		if [ -f $orig_file_path ]
		then
			read -p "Do you want to overwrite? y/n " confirm
			echo "you said: $confirm"
			if [[ ${yes_array[@]} =~ $confirm ]]
			then
				echo "log - overwriting"
			else
				echo "log - no overwrite, skipping $file"
			fi

		fi
		
	fi
done
