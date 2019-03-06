#!/bin/bash
logfile=$(ls -rt *.log 2>/dev/null | tail -1)
[ -z $logfile ] && echo "no log" && exit 1
grep "#@#" $logfile > done_steps
current_step=$(tail -1 done_steps)
current_num=$(wc -l done_steps | cut -f 1 -d " ")
echo "($current_num/50?) $current_step"
tail -1 $logfile

