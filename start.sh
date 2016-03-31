#!/bin/bash

module load nodejs
node $SCA_SERVICE_DIR/genpbs.js > submit.pbs
jobid=`qsub submit.pbs`
echo $jobid > jobid
#curl -s -X POST -H "Content-Type: application/json" -d "{\"status\": \"waiting\", \"msg\":\"Job: $jobid Waiting in PBS queue on $execenv\"}" $SCA_PROGRESS_URL > /dev/null
