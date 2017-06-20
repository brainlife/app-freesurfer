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
    if [ -z $jobstate ]; then
        echo "Job removed before completing - maybe timed out?" 
        exit 2
    fi
    if [ $jobstate == "Q" ]; then
        echo "Job:$jobid Waiting in the queue"
        eststart=`showstart $jobid | grep start`
        exit 0 #running!
    fi
    if [ $jobstate == "R" ]; then

	subid=$(cat jobid | cut -d '.' -f 1)
	logname="app-freesurfer.o$subid"

        #get rough estimate of the progress by analyzing the size of output log
        #the algorithm relies on the expecation that final log size will be about 10500 lines
        logsize=$(wc -l $logname | cut -d' ' -f1)
        per=$(echo "scale=2; $logsize/105" | bc) 
        work=$(grep "#@#" $logname | tail -1 | cut -c 5-)

        #TODO - if $per is greater than 1.0, I should trim it at 0.99... 
        echo "$per% Completed .. ($work)"
        exit 0 #running!
    fi

    #assume failed for all other state
    echo "Job:$jobid failed - PBS job state: $jobstate"
    exit 2
fi

if [ -f pid ]; then
    #echo "assume to be running locally"
    tail -1 stdout.log
    exit 0
fi

echo "can't determine the status!"
exit 3


