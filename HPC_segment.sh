# !/bin/bash

Surf() {
export FREESURFER_HOME=/usr/local/freesurfer
export SUBJECTS_DIR=/storage/gold/cinn/2019/SRfMRI/JC_MSc/Freesurfer
echo ${1} Hippocampal segmentation beginning
segmentHA_T1.sh ${1}
echo ${1} Hippocampal segmentation finished
}

"$@"

