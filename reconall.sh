#!/bin/bash

set -e
set -x

t1=`jq -r .t1 config.json`
t2=`jq -r .t2 config.json`
hippocampal=`jq -r .hippocampal config.json`

export OMP_NUM_THREADS=8
export SUBJECTS_DIR=`pwd`

#used fo hippocampal
export LD_LIBRARY_PATH=/opt/mcr/v80/runtime/glnxa64:/opt/mcr/v80/bin/glnxa64:/opt/mcr/v80/sys/os/glnxa64
export XAPPLRESDIR=/opt/mcr/v80/X11/app-defaults

cmd="recon-all -i $t1 -subject output -all -parallel -openmp $OMP_NUM_THREADS"
if [ -f $t2 ]; then
    cmd="$cmd -T2 $t2 -T2pial"

    #https://surfer.nmr.mgh.harvard.edu/fswiki/HippocampalSubfields
    #https://surfer.nmr.mgh.harvard.edu/fswiki/HippocampalSubfieldsAndNucleiOfAmygdala

    if [ $hippocampal == "true" ]; then
        cmd="$cmd -hippocampal-subfields-T1T2 $t2 t1t2"
    fi
else
    if [ $hippocampal == "true" ]; then
        cmd="$cmd -hippocampal-subfields-T1"
    fi
fi

exec $cmd
ret=$?

if [ ! $ret -eq 0 ];
then
    echo "failed($ret) to run recon-all"
    exit $ret
fi

#TODO - I think this is only used by /eval UI.. should deprecate?
#(warehouse can use freeview to visualize the entire freesurfer output)
echo "generate brain vtk model (for visualization purpose)"
mris_decimate -d 0.1 output/surf/lh.pial lh.10.pial
mris_convert lh.10.pial lh.10.vtk

mris_decimate -d 0.1 output/surf/rh.pial rh.10.pial
mris_convert rh.10.pial rh.10.vtk


