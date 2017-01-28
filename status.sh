#!/bin/bash
#return code 0 = running
#return code 1 = finished successfully
#return code 2 = failed

#allows test execution
if [ -z $SCA_WORKFLOW_DIR ]; then export SCA_WORKFLOW_DIR=`pwd`; fi
if [ -z $SCA_TASK_DIR ]; then export SCA_TASK_DIR=`pwd`; fi
if [ -z $SCA_SERVICE_DIR ]; then export SCA_SERVICE_DIR=`pwd`; fi
if [ -z $SCA_PROGRESS_URL ]; then export SCA_PROGRESS_URL="https://soichi7.ppa.iu.edu/api/progress/status/_sca.test"; fi

if [ -f finished ]; then
    code=`cat finished`
    if [ $code -eq 0 ]; then
        echo "finished successfully"
        curl -s -X POST -H "Content-Type: application/json" -d "{\"status\": \"finished\", \"progress\":1, \"msg\":\"Finished Successfully\"}" $SCA_PROGRESS_URL > /dev/null
        exit 1 #success!
    else
        echo "finished with code:$code"
        curl -s -X POST -H "Content-Type: application/json" -d "{\"status\": \"failed\", \"msg\":\"Job Failed\"}" $SCA_PROGRESS_URL > /dev/null
        exit 2 #failed
    fi
fi

#used to analyze the progress
#TODO instead of using _upload, use config/input_task_id
#input_task_id=`$SCA_SERVICE_DIR/jq -r '.input_task_id' config.json`
#input_size=`du -sL ../$input_task_id | cut -f1`
t1=`$SCA_SERVICE_DIR/jq -r '.t1' config.json`
input_size=`ls -l $t1 | cut -f5 -d" "`

if [ -f jobid ]; then
    jobid=`cat jobid`
    jobstate=`qstat -f $jobid | grep job_state | cut -b17`
    if [ -z $jobstate ]; then
        echo "Job removed before completing - maybe timed out?" 
        exit 2
    fi
    if [ $jobstate == "Q" ]; then
        echo "Job:$jobid Waiting in the queue"
        eststart=`showstart $jobid | grep start`
        curl -s -X POST -H "Content-Type: application/json" -d "{\"msg\":\"Waiting in the PBS queue : $eststart\"}" $SCA_PROGRESS_URL > /dev/null
        exit 0 #running!
    fi
    if [ $jobstate == "R" ]; then

        #get rough estimate of the progress by analyzing the size of output log
        logsize=$(wc -l sca-freesurfer.o$jobid | cut -d' ' -f1)
        per=$(echo "scale=2; $logsize/55" | bc) 
        work=$(grep "#@#" sca-freesurfer.o$jobid | tail -1 | cut -c 5-)

        #TODO - if $per is greater than 1.0, I should trim it at 0.99... 
        echo "$per% Completed .. ($work)"
        curl -s -X POST -H "Content-Type: application/json" -d "{\"status\": \"running\", \"progress\":$per, \"msg\":\"Executing recon_all\"}" $SCA_PROGRESS_URL > /dev/null

        exit 0 #running!
    fi

    #assume failed for all other state
    echo "Job:$jobid failed - PBS job state: $jobstate"
    exit 2
fi

echo "can't determine the status!"
exit 3


