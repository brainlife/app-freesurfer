#!/bin/bash

#make sure jq is installed on $SCA_SERVICE_DIR (used by status.sh to analyze progress)
if [ ! -f $SCA_SERVICE_DIR/jq ];
then
        echo "installing jq"
        wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O $SCA_SERVICE_DIR/jq
        chmod +x $SCA_SERVICE_DIR/jq
fi

module load nodejs
node $SCA_SERVICE_DIR/genpbs.js > submit.pbs

#clean up previous job (just in case)
rm -f finished

jobid=`qsub submit.pbs`
echo $jobid > jobid
#curl -s -X POST -H "Content-Type: application/json" -d "{\"status\": \"waiting\", \"msg\":\"Job: $jobid Waiting in PBS queue on $execenv\"}" $SCA_PROGRESS_URL > /dev/null
