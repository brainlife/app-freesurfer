#!/bin/bash
#return code 0 = running
#return code 1 = finished successfully
#return code 2 = failed

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
input_task_id=`$SCA_SERVICE_DIR/jq -r '.input_task_id' config.json`
input_size=`du -sL ../$input_task_id | cut -f1`

if [ -f jobid ]; then
    jobid=`cat jobid`
    jobstate=`qstat -f $jobid | grep job_state | cut -b17`
    if [ $jobstate == "Q" ]; then
        echo "Job:$jobid Waiting in the queue"
        eststart=`showstart $jobid | grep start`
        curl -s -X POST -H "Content-Type: application/json" -d "{\"msg\":\"Waiting in the PBS queue : $eststart\"}" $SCA_PROGRESS_URL > /dev/null
        exit 0 #running!
    fi
    if [ $jobstate == "R" ]; then

        #get rough estimate of the progress by analyzing the size of input and output directory
        taskdir_size=`du -s . | cut -f1`
        per=`bc -l <<< $taskdir_size/$input_size/10` #output directory should roughly about 10 times the size of input
        per=`printf %.4f $per` #round it
        echo "Running $per"
        curl -s -X POST -H "Content-Type: application/json" -d "{\"status\": \"running\", \"progress\":$per, \"msg\":\"Executing recon_all\"}" $SCA_PROGRESS_URL > /dev/null

        exit 0 #running!
    fi

    #assume failed for all other state
    echo "Job:$jobid failed - PBS job state: $jobstate"
    exit 2
fi

echo "can't determine the status!"
exit 3


