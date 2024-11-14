#!/bin/bash

args=("$@")

echo "file(s) to remove: ${args[@]}"

recycle_bin="$HOME/deleted"

if [ -d "$recycle_bin" ]; then
	echo "deleted directory does exist"
else
	echo "deleted directory does NOT exist"
	echo "creating directory"
	mkdir $recycle_bin
fi
