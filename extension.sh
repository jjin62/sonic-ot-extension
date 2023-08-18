#!/bin/bash

SUB_DIRS='dockers/docker-orchagent
          src/sonic-swss-common
          src/sonic-sairedis/debian
          src/sonic-sairedis/lib
          src/sonic-sairedis/meta
          src/sonic-sairedis/syncd
          src/sonic-sairedis/vslib
          src/sonic-sairedis/OTAI
          src/sonic-swss/cfgmgr
          src/sonic-swss/orchagent'

SCRIPT_FILE='extension.py'
CUR_PATH=`pwd`
BUILD_PATH=$1
OPTION='build'
DIR_IDX=0

if [ $# -lt 1 ]; then
	echo -e "\e[31mError!!! Please input argument!\e[0m"
	echo "argv 1: mandatory, path of sonic-buildimage directory"
	echo "argv 2: optional, clean"
	exit -1
fi

if [ $# -eq 2 ]; then
	OPTION=$2
fi

echo "run ot extension [sonic-buildimage: $BUILD_PATH][option: $OPTION]..."

for dir in $SUB_DIRS; do
	let DIR_IDX=DIR_IDX+1
	if test -e $dir/$SCRIPT_FILE; then
		cd $dir
		echo "-------------------------$DIR_IDX:$dir-------------------------"
		python3 $SCRIPT_FILE $BUILD_PATH $OPTION
		cd $CUR_PATH
	fi
done

echo "complete ot extension"
