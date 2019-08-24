#!/bin/bash

set -e
set -x

t1=`jq -r .t1 config.json`
t2=`jq -r .t2 config.json`
hippocampal=`jq -r .hippocampal config.json`
hires=`jq -r .hires config.json`
notalcheck=`jq -r .notalcheck config.json`

export OMP_NUM_THREADS=8
export SUBJECTS_DIR=`pwd`

cmd="-i $t1 -subject output -all -parallel -openmp $OMP_NUM_THREADS"
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

if [ $hires == "true" ]; then
    cmd="$cmd -hires"
fi
if [ $notalcheck == "true" ]; then
    cmd="$cmd -notal-check"
fi

rm -rf output
recon-all $cmd
#output output under freesurfer
mkdir freesurfer
mv output freesurfer

#converting aparc to nifti
mri_convert output/mri/aparc+aseg.mgz parc/parc.nii.gz
mri_convert output/mri/aparc.a2009s+aseg.mgz parc2009/parc.nii.gz

