#!/bin/bash

cat <<EOT > task.pbs
#!/bin/bash
#PBS -k o
#PBS -l nodes=1:ppn=16:dc2,mem=12000mb,walltime=20:00:00
#PBS -M hayashis@iu.edu
#PBS -m abe
##PBS -N recon-all_14018_1to14071_1
##PBS -o recon-all_14018_1to14071_1.log
#PBS -j oe

#module unload freesurfer
module load freesurfer/5.3.0
#export SUBJECTS_DIR=/N/dc2/scratch/pkgandhi/subjects/AIRTD_FREESURFER_DATA
source /N/soft/cle4/freesurfer/5.3.0/FreeSurferEnv.sh
EOT

module load nodejs
export PATH=$PATH:~/.sca/node_modules/underscore-cli/bin #TODO - who installs this?

#echo pull nifti files to process
for file in `cat config.json | underscore select '.filename' --outfmt text`; do
cat <<EOT >> task.pbs
    recon-all -i $file -subject $index -all -hippo-subfields &
EOT
done



