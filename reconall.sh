#!/bin/bash

t1=`jq -r .t1 config.json`
export OMP_NUM_THREADS=8
export SUBJECTS_DIR=`pwd`
recon-all -i $t1 -subject output -all -parallel -openmp $OMP_NUM_THREADS
ret=$?

if [ ! $ret -eq 0 ];
then
    echo "failed($ret) to run recon-all"
    exit $ret
fi

#TODO - I think this is only used by /eval UI.. should deprecate?
echo "generate brain vtk model (for visualization purpose)"
mris_decimate -d 0.1 output/surf/lh.pial lh.10.pial
mris_convert lh.10.pial lh.10.vtk

mris_decimate -d 0.1 output/surf/rh.pial rh.10.pial
mris_convert rh.10.pial rh.10.vtk


