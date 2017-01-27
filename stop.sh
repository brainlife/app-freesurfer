#!/bin/bash

#if [ -f finished ]; then
#    echo "can't stop job that's already finished"
#    exit 1
#fi

#allows test execution
if [ -z $SCA_WORKFLOW_DIR ]; then export SCA_WORKFLOW_DIR=`pwd`; fi
if [ -z $SCA_TASK_DIR ]; then export SCA_TASK_DIR=`pwd`; fi
if [ -z $SCA_SERVICE_DIR ]; then export SCA_SERVICE_DIR=`pwd`; fi
if [ -z $SCA_PROGRESS_URL ]; then export SCA_PROGRESS_URL="https://soichi7.ppa.iu.edu/api/progress/status/_sca.test"; fi

jobid=`cat jobid`
echo "running qdel $jobid"
qdel $jobid
