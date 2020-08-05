# !/bin/bash

makemasks  () {
export SUBJECTS_DIR=/storage/gold/cinn/2019/SRfMRI/JC_MSc/Freesurfer
export FREESURFER_HOME=/usr/share/freesurfer
PROJECT_DIR=/storage/gold/cinn/2019/SRfMRI/JC_MSc
FS_DIR=$PROJECT_DIR/Freesurfer
FEAT_DIR=$PROJECT_DIR/preprocessed
MASK_DIR=$PROJECT_DIR/masks
BIN_THR=0.5

for i in "$1"

do

echo Creating ${i} masks

mkdir -p $MASK_DIR/${i}/{anat,anat-nii,func,func_binarised}

mri_label2vol --seg $FS_DIR/${i}/mri/lh.hippoAmygLabels-T1.v21.FSvoxelSpace.mgz --temp $FS_DIR/${i}/mri/rawavg.mgz --regheader $FS_DIR/${i}/mri/lh.hippoAmygLabels-T1.v21.FSvoxelSpace.mgz --o $FS_DIR/${i}/mri/lh.hippoAmygLabels-T1.v21.FSvoxelSpace-anat.mgz

mri_label2vol --seg $FS_DIR/${i}/mri/rh.hippoAmygLabels-T1.v21.FSvoxelSpace.mgz --temp $FS_DIR/${i}/mri/rawavg.mgz --regheader $FS_DIR/${i}/mri/rh.hippoAmygLabels-T1.v21.FSvoxelSpace.mgz --o $FS_DIR/${i}/mri/rh.hippoAmygLabels-T1.v21.FSvoxelSpace-anat.mgz

# Extract  masks form freesurfer
mri_binarize --i $FS_DIR/${i}/mri/lh.hippoAmygLabels-T1.v21.HBT.FSvoxelSpace.mgz --o $MASK_DIR/${i}/anat/Left-HP_tail.mgz --match 226
mri_binarize --i $FS_DIR/${i}/mri/lh.hippoAmygLabels-T1.v21.HBT.FSvoxelSpace.mgz --o $MASK_DIR/${i}/anat/Left-HP_body.mgz --match 231
mri_binarize --i $FS_DIR/${i}/mri/lh.hippoAmygLabels-T1.v21.HBT.FSvoxelSpace.mgz --o $MASK_DIR/${i}/anat/Left-HP_head.mgz --match 232
mri_binarize --i $FS_DIR/${i}/mri/rh.hippoAmygLabels-T1.v21.HBT.FSvoxelSpace.mgz --o $MASK_DIR/${i}/anat/Right-HP_tail.mgz --match 226
mri_binarize --i $FS_DIR/${i}/mri/rh.hippoAmygLabels-T1.v21.HBT.FSvoxelSpace.mgz --o $MASK_DIR/${i}/anat/Right-HP_body.mgz --match 231
mri_binarize --i $FS_DIR/${i}/mri/rh.hippoAmygLabels-T1.v21.HBT.FSvoxelSpace.mgz --o $MASK_DIR/${i}/anat/Right-HP_head.mgz --match 232



# Convert mgz masks to nifti

cd $MASK_DIR/${i}/anat

for p in *

do

filename="${p%.*}"

mri_convert --in_type mgz --out_type nii $MASK_DIR/${i}/anat/${p} $MASK_DIR/${i}/anat-nii/${filename}.nii.gz

done

cd $MASK_DIR/${i}/anat-nii

for p in *

do

filename="${p%%.*}"

applywarp --ref=$FEAT_DIR/${i}/preprocessing.feat/reg/example_func --in=${p} --warp=$FEAT_DIR/${i}/preprocessing.feat/reg/highres2example_func_warp.nii.gz --out=$MASK_DIR/${i}/func/${filename}_func_nonbinary.nii.gz

fslmaths $MASK_DIR/${i}/func/${filename}_func_nonbinary.nii.gz  -thr $BIN_THR -bin $MASK_DIR/${i}/func_binarised/${filename}_func_binary${BIN_THR}.nii.gz

done

done

}

"$@"





