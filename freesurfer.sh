#!/bin/bash

set -e
set -x

t1=`jq -r .t1 config.json`
t2=`jq -r .t2 config.json`
hippocampal=`jq -r .hippocampal config.json`
thalamicnuclei=`jq -r .thalamicnuclei config.json`
hires=`jq -r .hires config.json`
notalcheck=`jq -r .notalcheck config.json`
cw256=`jq -r .cw256 config.json`
debug=`jq -r .debug config.json`
version=`jq -r .version config.json`
jq -r '.expert | select(.!=null)' config.json > expert.opts

export OMP_NUM_THREADS=8
export SUBJECTS_DIR=`pwd`

cmd="-i $t1 -subject output -all -parallel -openmp $OMP_NUM_THREADS"
if [ -f $t2 ]; then
    cmd="$cmd -T2 $t2 -T2pial"
    #https://surfer.nmr.mgh.harvard.edu/fswiki/HippocampalSubfields
    #https://surfer.nmr.mgh.harvard.edu/fswiki/HippocampalSubfieldsAndNucleiOfAmygdala
    if [ $hippocampal == "true" ]; then
        case $version in
        6.0.0 | 6.0.1 | dev)
            cmd="$cmd -hippocampal-subfields-T1T2 $t2 t1t2"
            ;;
        *)
            echo "t2 hippocampal-subfields is no longer handled via recon-all"
            ;;
        esac
    fi
else
    if [ $hippocampal == "true" ]; then
        case $version in
        6.0.0 | 6.0.1 | dev)
            cmd="$cmd -hippocampal-subfields-T1"
            ;;
        *)
            echo "t1 hippocampal-subfields is no longer handled via recon-all"
            ;;
        esac
    fi
fi

if [ $hires == "true" ]; then
    cmd="$cmd -hires"
fi
if [ $notalcheck == "true" ]; then
    cmd="$cmd -notal-check"
fi
if [ $cw256 == "true" ]; then
    cmd="$cmd -cw256"
fi
if [ $debug == "true" ]; then
    cmd="$cmd -debug"
fi
if [ -s expert.opts ]; then
    cmd="$cmd -expert expert.opts"
fi

rm -rf output freesurfer
recon-all $cmd

if [ -f $t2 ]; then
    if [ $hippocampal == "true" ]; then
        case $version in
        6.0.0 | 6.0.1 | dev)
            echo "already processed hippocampal-subfields"
            ;;
        *)
            segmentHA_T2.sh output $t2 T2 1 `pwd`
            ;;
        esac
    fi
else
    if [ $hippocampal == "true" ]; then
        case $version in
        6.0.0 | 6.0.1 | dev)
            echo "already processed hippocampal-subfields"
            ;;
        *)
            segmentHA_T2.sh output $t2 T2 1 `pwd`
        esac
    fi
fi

if [ $thalamicnuclei == "true" ]; then
    case $version in
    6.0.0 | 6.0.1)
        echo "thalamicnuclei is only available for freesurfer >7"
        exit 1
        ;;
    *)
        segmentThalamicNuclei.sh output `pwd`
    esac
fi

#converting aparc to nifti
mri_convert output/mri/aparc+aseg.mgz parc/parc.nii.gz
mri_convert output/mri/aparc.a2009s+aseg.mgz parc2009/parc.nii.gz
mri_convert output/mri/aparc.DKTatlas+aseg.mgz parcDKT/parc.nii.gz

#put freesurfer output under freesurfer directory
mkdir freesurfer
mv output freesurfer

datatype_tags=()
echo "writing out product.json"
if [ "$hippocampal" == "true" ]; then
    datatype_tags+=('"hippocampal"')
fi
if [ "$thalamicnuclei" == "true" ]; then
    datatype_tags+=('"thalamic_nuclei"')
fi

function join_by { local d=$1; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}"; }
datatype_tags_str=$(join_by , "${datatype_tags[@]}")

meta="{\"freesurfer_version\": \"$version\"}"
echo "{\"datatype_tags\": [$datatype_tags_str], \"meta\": $meta}" > product.json


