##### WRAPUP CODE FOR MRI SEGMENTATION AND HEAD MODELING
#####
##### REQUIRES: - MNI subject folder in SUBJECTS_DIR
#####           - 

##### LOAD FREESURFER SOFTWARE SUITE (hardcoded paths)

export FREESURFER_HOME=/opt/freesurfer/
source ${FREESURFER_HOME}/SetUpFreeSurfer.sh
export MNE_ROOT=/opt/MNE/
source ${MNE_ROOT}/bin/mne_setup_sh

# locate matlab folder 
export MATLAB_DIR=/opt/MATLAB/R2016a/bin

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
##### SET UP PREDEFINED  PARAMETERS (hardcorded!)
export EXP_NAME=OPM
export SUBJECTS_DIR=/data/PierreC/MRI # <--------------------------------

export SUBJECT= # <------------------ SUBJECT NAME

export INPUT=  # <------------- First Dicom or nifti location

export SPACE=1
export SOURCESPACE_TYPE=volume # volume or cortex


export SCRIPTS=/media/thecix/toolboxes/OPM_Coreg


#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#
##### GO TO SUBJECTS DIRECTORY FOR CONVENIENCE
cd ${SUBJECTS_DIR}

##### FREESURFER: MRI SEGMENTATION (takes a while!!!)
recon-all -all -i $INPUT -subjid ${SUBJECT}


mkheadsurf -s ${SUBJECT}
mris_convert  ${SUBJECTS_DIR}/${SUBJECT}/surf/lh.seghead  ${SUBJECTS_DIR}${SUBJECT}/surf/lh.seghead.stl

##### MNE: CONVERT MRI INTO VARIOUS FORMATS

mne_setup_mri --subject ${SUBJECT} 
mri_convert -it mgz -ot nii -i ${SUBJECTS_DIR}/${SUBJECT}/mri/orig.mgz -o ${SUBJECTS_DIR}/${SUBJECT}/mri/orig.nii
mri_convert -it mgz -ot nii -i ${SUBJECTS_DIR}/${SUBJECT}/mri/brain.mgz -o ${SUBJECTS_DIR}/${SUBJECT}/mri/brain.nii

##### MNE: CREATION OF BEM HEAD MODEL

mne_watershed_bem --subject ${SUBJECT}
cp ${SUBJECTS_DIR}/${SUBJECT}/bem/watershed/${SUBJECT}_inner_skull_surface ${SUBJECTS_DIR}/${SUBJECT}/bem/inner_skull.surf
#cp ${SUBJECTS_DIR}/${SUBJECT}/bem/watershed/${SUBJECT}_outer_skull_surface ${SUBJECT}/bem/outer_skull.surf # needed for BEM-3 only
#cp ${SUBJECTS_DIR}/${SUBJECT}/bem/watershed/${SUBJECT}_outer_skin_surface ${SUBJECT}/bem/outer_skin.surf # needed for BEM-3 only

mne_setup_forward_model --subject ${SUBJECT} --surf --ico 4 --homog # BEM-1
#mne_setup_forward_model --subject ${SUBJECT} --surf --ico 4 # BEM-3

##### MATLAB: SETUP MNI-BASED DEFORMATION AND SOURCE-SPACE ( !!! SPACE IS HARDCODED HERE !!!)

#ln -s /data/PierreC/MNI ./
#ln -s ${SUBJECTS_DIR}/../MNI ./
ln -s $SCRIPTS/MNI ./
${MATLAB_DIR}/matlab -nodisplay -r "cd '${SCRIPTS}'; MNIdeformation_matlabpart('${SUBJECTS_DIR}','${SUBJECT}',5,'${SOURCESPACE_TYPE}'); exit"

##### MNE: CREATE SOURCE SPACE FROM MNI-DEFORMED GRID

mne_volume_source_space --surf ${SUBJECT}/bem/inner_skull.surf --pos ${SUBJECT}/bem/${SUBJECT}_from_MNI-${SOURCESPACE_TYPE}-${SPACE}.pnt --src ${SUBJECT}/bem/${SUBJECT}_from_MNI-${SOURCESPACE_TYPE}-${SPACE}-src.fif

#mne_volume_source_space --surf ${SUBJECT}/bem/rh.inner_skull_1000.surf --grid ${SPACE} --exclude 30 --src ${SUBJECT}/bem/${SUBJECT}_from_MNI-${SOURCESPACE_TYPE}-${SPACE}-src.fif

##### INFORM USER OF NEXT STEPS

echo 'MRI SEGMENTATION AND HEAD MODELING FOR ${SUBJECT} IS NOW COMPLETE !'
echo 'NOW TO COREGISTRATION BEFORE FINAL HEAD MODELING USING PIPELINE2...'

