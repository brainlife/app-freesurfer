#!/bin/bash

jobid=`cat jobid`
echo "running qdel $jobid"
qdel $jobid
