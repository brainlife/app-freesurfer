#!/bin/bash

set -e
set -x

t1=`jq -r .t1 config.json`
t2=`jq -r .t2 config.json`
hippocampal=`jq -r .hippocampal config.json`

export OMP_NUM_THREADS=8
export SUBJECTS_DIR=`pwd`

#used fo hippocampal
#export LD_LIBRARY_PATH=/opt/mcr/v80/runtime/glnxa64:/opt/mcr/v80/bin/glnxa64:/opt/mcr/v80/sys/os/glnxa64
#export XAPPLRESDIR=/opt/mcr/v80/X11/app-defaults

#construct command line options
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

rm -rf output freesurfer
recon-all $cmd

#create aparc+aseg.nii.gz to create vtk surfaces later
#mri_convert output/mri/aparc+aseg.mgz --out_orientation RAS aparc+aseg.nii.gz

#converting aparc to nifti
mri_convert output/mri/aparc+aseg.mgz parc/parc.nii.gz
mri_convert output/mri/aparc.a2009s+aseg.mgz parc2009/parc.nii.gz

#put freesurfer output under freesurfer directory
mkdir freesurfer
mv output freesurfer
