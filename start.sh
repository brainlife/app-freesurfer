#!/bin/bash

#allows test execution
if [ -z $SCA_WORKFLOW_DIR ]; then export SCA_WORKFLOW_DIR=`pwd`; fi
if [ -z $SCA_TASK_DIR ]; then export SCA_TASK_DIR=`pwd`; fi
if [ -z $SCA_SERVICE_DIR ]; then export SCA_SERVICE_DIR=`pwd`; fi
if [ -z $SCA_PROGRESS_URL ]; then export SCA_PROGRESS_URL="https://soichi7.ppa.iu.edu/api/progress/status/_sca.test"; fi

#jq is part of the repo now
#make sure jq is installed on $SCA_SERVICE_DIR (used by status.sh to analyze progress)
#if [ ! -f $SCA_SERVICE_DIR/jq ];
#then
#        echo "installing jq"
#        wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O $SCA_SERVICE_DIR/jq
#        chmod +x $SCA_SERVICE_DIR/jq
#fi

#mainly to debug locally
if [ -z $SCA_WORKFLOW_DIR ]; then export SCA_WORKFLOW_DIR=`pwd`; fi
if [ -z $SCA_TASK_DIR ]; then export SCA_TASK_DIR=`pwd`; fi
if [ -z $SCA_SERVICE_DIR ]; then export SCA_SERVICE_DIR=`pwd`; fi

module load nodejs
echo "Generating submit.pbs"
node $SCA_SERVICE_DIR/genpbs.js > submit.pbs

#clean up previous job (just in case)
rm -f finished
echo "Submitting.."
jobid=`qsub submit.pbs`
echo $jobid > jobid

#curl -s -X POST -H "Content-Type: application/json" -d "{\"status\": \"waiting\", \"msg\":\"Job: $jobid Waiting in PBS queue on $execenv\"}" $SCA_PROGRESS_URL > /dev/null
