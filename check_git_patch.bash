#!/usr/bin/env bash

BIGDATA_SOURCE_DIR=$1
BIGDATA_SYNC_DIR=$2

function check_patch()
{
    sync_target=$1
    pushd $sync_target >> /dev/null 2>&1
    git status | grep modified | grep dev-support/docker/docker/Dockerfile >> /dev/null 2>&1
    if [ $? -ne 0 ];
    then
        echo "Warning: Necessary ambari patches are not found, build might not work"
        echo "For more details refer to Doc in https://github.com/saurabhsurana/ambari-dev"
        exit 1
    fi
    git status | grep modified | grep  dev-support/docker/docker/bin/ambaribuild.py  >> /dev/null 2>&1
    if [ $? -ne 0 ];
    then
        echo "Warning: Necessary ambari patches are not found, build might not work"
        echo "For more details refer to Doc in https://github.com/saurabhsurana/ambari-dev"
        exit 1
    fi
    echo "Great! Necessary patches are available."
    exit 0
}

for sync_target in $BIGDATA_SYNC_DIR
do
    if [ "$sync_target" = 'ambari' ];
    then
        check_patch $sync_target
    else
        for sub_sync_target in `ls $sync_target/`
        do
            if [ "$sub_sync_target" = 'ambari' ];
            then
                check_patch "$sync_target/$sub_sync_target"
            fi
        done
    fi
done
