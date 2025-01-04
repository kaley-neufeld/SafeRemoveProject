#!/bin/bash

# variables, arguments, flags
recycle_bin="$HOME/deleted"
i_flag=''
v_flag=''
yes_array=("y" "yes" "Y")

while getopts 'iv' flag; do
	case $flag in
		i) i_flag='true';;
		v) v_flag='true';;
		\?) echo "invalid flag $flag";;
	esac
done
shift $((OPTIND - 1))
args=("$@")


# helper functions
function remove () {
	
	read basefilename <<< $(basename $1)
	read -a file_info <<< $(ls -i $1)
	file_inode=${file_info[0]}
	read orig_file_path <<< $(readlink -f $1)
	new_file_name="${basefilename}_${file_inode}"
	echo "log - removed file will be called $new_file_name in recycle bin"
	mv $1 $recycle_bin/$new_file_name
	tee -a $HOME/.restore.info <<< "$new_file_name:$orig_file_path"
	if [ $v_flag ]
	then
		echo "removed $1"
	fi
}

function main () {
	if [ ! -d "$recycle_bin" ];
	then
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
			echo "error - directory name provided"
			exit 1
		elif [ ! -f $file ]
		then
			echo "error - $file does not exist"
			exit 1
		elif [ $(readlink -f $file) == $(readlink -f $HOME/project/remove.sh) ]
		then	
			echo "error - attempting to delete remove - operation aborted"
			exit 1
		elif [ $(readlink -f $file) == $(readlink -f $HOME/project/restore.sh) ]
		then
			echo "error - attemping to delete restore - operation aborted"
			exit 1	
		else
			if [ $i_flag ]
			then
				read -p "remove file $file ? y/n " response
				confirm="\<$response\>"
				if [[ ${yes_array[@]} =~ $confirm ]]
				then 
					remove $file
				else
					echo "skipping $file"
				fi
			else
				remove $file
			fi
		fi
	done
}

main
echo "log - end of script"
