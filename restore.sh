#!/bin/bash

# arguments, flags, variables
args=("$@")
recycle_bin="$HOME/deleted"
yes_array=("y" "Y" "yes")

# helper functions
# restore arg1 filename to arg2 filepath and remove file info from .restore.info
function restore () {
	echo "log - restoring $1 to $2"
	mv $recycle_bin/$1 $2
	sed -i '/'$1'/d' .restore.info
}

function main () {
	if [ ${#args} == 0 ]
	then
		echo "error - no filename provided"
		exit 1
	fi
	
	for file in ${args[@]}
	do
		echo "log - processing $file"
		# check that file to restore exists in recycle bin
		if [ ! -f $recycle_bin/$file ]
		then
			echo "error - $file does not exist"
			exit 1
		else
			read restore_info <<< $(grep -i $file $HOME/.restore.info)
			read orig_file_name <<< $(cut -d ":" -f1 <<< $restore_info)
			read orig_file_path <<< $(cut -d ":" -f2 <<< $restore_info)
				
			# check if file exists in target directory
			if [ -f $orig_file_path ]
			then
				read -p "$orig_file_path exists, do you want to overwrite? y/n " confirm
				if [[ ${yes_array[@]} =~ $confirm ]]
				then
					echo "log - overwriting"
					restore $file $orig_file_path
				else
					echo "log - no overwrite, skipping $file"
				fi
			else
				echo "log - now restoring $file"
				restore $file $orig_file_path
	
			fi
			
		fi
	done
}

main
echo "log - end of restore script"
