#!/bin/bash 
export PATH=/usr/local/bin:$PATH
destdir=$1
for file in `ls`
do
	if [ "${file##*.}"x = "proto"x ];then
		protoc $file --lua_out=$destdir
	fi
done

exit 0