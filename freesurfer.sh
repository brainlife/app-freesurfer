#!/bin/bash

set -e
set -x

# t1=`jq -r .t1 config.json`
t1=($(jq -r '.t1' config.json  | tr -d '[]," '))
t2=`jq -r .t2 config.json`
hippocampal=`jq -r .hippocampal config.json`
thalamicnuclei=`jq -r .thalamicnuclei config.json`
hires=`jq -r .hires config.json`
notalcheck=`jq -r .notalcheck config.json`
cw256=`jq -r .cw256 config.json`
debug=`jq -r .debug config.json`
jq -r '.expert | select(.!=null)' config.json > expert.opts

export OMP_NUM_THREADS=8
export SUBJECTS_DIR=`pwd`

# this new section will add multiple t1 inputs to the recon-all command if present
cmd=""
if [[ ${#t1[*]} == 1 ]]; then
  cmd="-i $t1"
else
  for i in ${t1[*]}
  do
    cmd="$cmd -i ${i}"
  done
fi

cmd="$cmd -subject output -all -parallel -openmp $OMP_NUM_THREADS"

if [ -f $t2 ]; then
    cmd="$cmd -T2 $t2 -T2pial"
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
if [ `jq -r .localGI config.json` == "true" ]; then
    cmd="$cmd -localGI"
fi

rm -rf output freesurfer
recon-all $cmd

if [ -f $t2 ]; then
  if [ $hippocampal == "true" ]; then
    segmentHA_T2.sh output $t2 T2 1 `pwd`
  fi
else
  if [ $hippocampal == "true" ]; then
    segmentHA_T1.sh output `pwd`
  fi
fi

if [ $thalamicnuclei == "true" ]; then
  segmentThalamicNuclei.sh output `pwd`
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

(
echo "running qatools.sh to generate qa image"
qatools.py --subjects_dir freesurfer --screenshots --subjects output --output_dir qa
) || echo "failed to run qatools"
   

if [ -f qa/screenshots/output/output.png ];
then
        #the image is too big.. so let's resize it
        convert qa/screenshots/output/output.png -resize 50% -trim -quality 90 qa/screenshots/output/output.jpg
        qa="{
            \"type\": \"image/jpg\",
            \"name\": \"qatools\",
            \"base64\": \"$(base64 -w 0 qa/screenshots/output/output.jpg)\"
        }"
else
        qa="{ 
                \"type\": \"error\",
                \"msg\": \"Failed to generate qatools.py image.\"
}"

fi

cat << EOF > product.json
{
    "datatype_tags": [$datatype_tags_str],
    "brainlife": [$qa]
}
EOF
