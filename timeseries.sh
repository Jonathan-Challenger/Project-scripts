# !/bin/bash

timeseries  () {
export SUBJECTS_DIR=/storage/gold/cinn/2019/SRfMRI/JC_MSc/Freesurfer
export FREESURFER_HOME=/usr/share/freesurfer
PROJECT_DIR=/storage/gold/cinn/2019/SRfMRI/JC_MSc
TS_DIR=$PROJECT_DIR/timeseries
MASK_DIR=$PROJECT_DIR/masks

mkdir -p $TS_DIR/${1}
cd ${MASK_DIR}/${1}/func_binarised

for mask in *

do

maskname="${mask%.*}"
echo $maskname

fslmeants -i $PROJECT_DIR/preprocessed/${1}/preprocessing.feat/filtered_func_data.nii.gz -m ${mask} -o $TS_DIR/${1}/${maskname}.txt

done

}

"$@"
