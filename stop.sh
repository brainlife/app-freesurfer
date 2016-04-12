#!/bin/bash

#if [ -f finished ]; then
#    echo "can't stop job that's already finished"
#    exit 1
#fi

jobid=`cat jobid`
echo "running qdel $jobid"
qdel $jobid
