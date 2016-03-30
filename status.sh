#!/bin/bash
#return code 0 = running
#return code 1 = finished successfully
#return code 2 = failed

if [ -f finished ]; then
    code=`cat finished`
    if [ $code -eq 0 ]; then
        echo "finished successfully"
        exit 1 #success!
    else
        echo "finished with code:$code"
        exit 2 #failed
    fi
fi

if [ -f jobid ]; then
    jobid=`cat jobid`
    jobstate=`qstat -f $jobid | grep job_state | cut -b17`
    if [ $jobstate == "Q" ]; then
        echo "Waiting in the queue"
        eststart=`showstart $jobid | grep start`
        curl -X POST -H "Content-Type: application/json" -d "{\"msg\":\"Waiting in the PBS queue : $eststart\"}" $SCA_PROGRESS_URL
        exit 0 #running!
    fi
    if [ $jobstate == "R" ]; then
        echo "Running"
        exit 0 #running!
    fi

    #assume failed for all other state
    echo "Jobs failed - PBS job state: $jobstate"
    exit 2
fi

echo "can't determine the status!"
exit 3


