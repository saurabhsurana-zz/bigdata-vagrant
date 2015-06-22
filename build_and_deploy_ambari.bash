#!/usr/bin/env bash

BIGDATA_SOURCE_DIR=$1
BIGDATA_SYNC_DIR=$2

function check_patch()
{
    sync_target=$1
    pushd $sync_target >> /dev/null 2>&1
    echo "Building ambari docker image"
    docker build -t ambari/build ./dev-support/docker/docker

    echo "Docker image built successfully!!!!"
	echo "Sleep for 30 seconds"
	sleep 30

    echo "Now deploying ambari in the docker container"
    docker run --privileged -t -p 2222:22 -p 3380:80 -p 5005:5005 -p 8080:8080 -h node1.mydomain.com --name ambari1 -v $(pwd):/tmp/ambari ambari/build /tmp/ambari-build-docker/bin/ambaribuild.py deploy

}

for sync_target in $BIGDATA_SYNC_DIR
do
    #check for ambari directory
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
