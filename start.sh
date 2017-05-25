#!/bin/bash

#allows test execution
if [ -z $SERVICE_DIR ]; then export SERVICE_DIR=`pwd`; fi
if [ -z $TASK_DIR ]; then export TASK_DIR=`pwd`; fi

#find out which environment we are in
hostname | grep karst > /dev/null
if [ $? -eq 0 ]; then
    export PBS_ENV=karst
fi
echo $HOME | grep -i bigred > /dev/null
if [ $? -eq 0 ]; then
    export PBS_ENV=bigred2
fi

echo "Generating submit.pbs"
module load nodejs
node $SERVICE_DIR/genpbs.js > submit.pbs

#clean up previous job (just in case)
rm -f finished
echo "Submitting.."
jobid=`qsub submit.pbs`
echo $jobid > jobid

#curl -s -X POST -H "Content-Type: application/json" -d "{\"status\": \"waiting\", \"msg\":\"Job: $jobid Waiting in PBS queue on $execenv\"}" $SCA_PROGRESS_URL > /dev/null
