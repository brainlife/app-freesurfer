#!/bin/bash
#return code 0 = running
#return code 1 = finished successfully
#return code 2 = failed

#allows test execution
if [ -z $ERVICE_DIR ]; then export SERVICE_DIR=`pwd`; fi
if [ -z $PROGRESS_URL ]; then export PROGRESS_URL="https://soichi7.ppa.iu.edu/api/progress/status/_sca.test"; fi

if [ -f finished ]; then
    code=`cat finished`
    if [ $code -eq 0 ]; then
        echo "finished successfully"
        #curl -s -X POST -H "Content-Type: application/json" -d "{\"status\": \"finished\", \"progress\":1, \"msg\":\"Finished Successfully\"}" $PROGRESS_URL > /dev/null
        exit 1 #success!
    else
        echo "finished with code:$code"
        #curl -s -X POST -H "Content-Type: application/json" -d "{\"status\": \"failed\", \"msg\":\"Job Failed\"}" $PROGRESS_URL > /dev/null
        exit 2 #failed
    fi
fi

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
        #curl -s -X POST -H "Content-Type: application/json" -d "{\"msg\":\"Waiting in the PBS queue : $eststart\"}" $PROGRESS_URL > /dev/null
        exit 0 #running!
    fi
    if [ $jobstate == "R" ]; then

        #convert "1234.m2" to "app-freesurfer.o1234"
	subid=$(cat jobid | cut -d '.' -f 1)
	logname="app-freesurfer.o$subid"
	#echo "logname $subid $logname"

        #get rough estimate of the progress by analyzing the size of output log
        #the algorithm relies on the expecation that final log size will be about 10500 lines
        logsize=$(wc -l $logname | cut -d' ' -f1)
        per=$(echo "scale=2; $logsize/105" | bc) 
        work=$(grep "#@#" $logname | tail -1 | cut -c 5-)

        #TODO - if $per is greater than 1.0, I should trim it at 0.99... 
        echo "$per% Completed .. ($work)"
        #curl -s -X POST -H "Content-Type: application/json" -d "{\"status\": \"running\", \"progress\":$per, \"msg\":\"Executing recon_all\"}" $PROGRESS_URL > /dev/null

        exit 0 #running!
    fi

    #assume failed for all other state
    echo "Job:$jobid failed - PBS job state: $jobstate"
    exit 2
fi

echo "can't determine the status!"
exit 3


