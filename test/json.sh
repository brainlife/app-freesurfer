cd ..
#RunAll.r <basedir> <temp_dir>
rm -rf /usr/local/tmp/DICOM_QC_FreeSurfer/10142_3_RES/Results
mkdir /usr/local/tmp/DICOM_QC_FreeSurfer/10142_3_RES/Results
Rscript statsex/RunAll.r /usr/local/tmp/DICOM_QC_FreeSurfer/10142_3_RES /home/hayashis/git/sca-service-freesurfer/statsex_template
#/usr/local/tmp/DICOM_QC_FreeSurfer/10142_3_RES > /usr/local/tmp/DICOM_QC_FreeSurfer/10142_3_RES/.analyzed.json


