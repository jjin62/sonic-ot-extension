#!/bin/bash

SUB_DIRS='device
          dockers/docker-orchagent
          files/image_config
          platform
          rules
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
BUILD_PATH=$(dirname $CUR_PATH)/sonic-buildimage
OPTION='build'
DIR_IDX=0


check_args()
{
    argc=$1

    if [ $argc -eq 0 ]; then
        return
    fi

    if [ $argc -eq 1 ]; then
        if [ $2 == "?" -o $2 == "help" ]; then
            echo "extension arguments description:"
            echo "argv 1: optional, path for sonic-buildimage, in the same directory by default."
            echo "argv 2: optional, processing type, build|clean, build by default."
            exit -1
        fi

        if [ $2 == "build" -o $2 == "clean" ]; then
            OPTION=$2
        else
            BUILD_PATH=$2
        fi

        return
    fi

    if [ $argc -eq 2 ]; then
        if [ $3 == 'build' -o $3 == 'clean' ]; then
            OPTION=$3
        else
            echo -e "\e[31mIncorrect argument '$3'!\e[0m"
            echo "please type ? or help for help"
            exit -1
        fi

        BUILD_PATH=$2
        return
    fi

    echo -e "\e[31mInvalid arguments!\e[0m"
    echo "please type '?' or 'help' for help"
    exit -1
}

check_path()
{
    echo $BUILD_PATH
    if [ -d "$BUILD_PATH" ]; then
        echo "run ot extension [sonic-buildimage: $BUILD_PATH][option: $OPTION]..."
    else
        echo $BUILD_PATH
        echo -e "\e[31mCannot find the directory for sonic-buildimage!\e[0m"
        exit -1
    fi
}

check_args $# $@
check_path

for dir in $SUB_DIRS; do
    let DIR_IDX=DIR_IDX+1
    if test -e $dir/$SCRIPT_FILE; then
        cd $dir
        echo "-------------------------$DIR_IDX:$dir-------------------------"
        python3 $SCRIPT_FILE $BUILD_PATH $OPTION
        cd $CUR_PATH
    fi
done

#do snapshot
echo "-------------------------diff snapshot-------------------------"
cd snapshot
python3 gen.py $BUILD_PATH $OPTION ${CUR_PATH}/snapshot
cd $CUR_PATH

echo "complete ot extension"
