##### WRAPUP CODE FOR FORWARD MODELING
#####
##### REQUIRES: - Preprocessing_pipeline1.sh complete
#####           - Coregistered MRI using Preprocessing_pipeline2_OPM



##### LOAD FREESURFER SOFTWARE SUITE (hardcoded paths)
export FREESURFER_HOME=/opt/freesurfer/
source ${FREESURFER_HOME}/SetUpFreeSurfer.sh
export MNE_ROOT=/opt/MNE/
source ${MNE_ROOT}/bin/mne_setup_sh

export MATLAB_DIR=/opt/MATLAB/R2016a/bin


# MEG_FIF is the .fif file containing the sensors location

export MEG_FIF=${SCAN_DIR}/sensors.fif
# first convert to fif using Matlab

if [ -f "${MEG_FIF}" ]; then
  echo "sensors.fif exists already"
else
#   ${MATLAB_DIR}/matlab -batch "convert_fif('')"
    ${MATLAB_DIR}/matlab -nodisplay -r "cd '$SCRIPTS'; convert_fif('${SCAN_DIR}'); exit"
fi


# COR_FIF if the file where the coreg matrix is stored if sensors locations in their own frame
# by default it contains an identity matrix, which we need
# in the optic scanner case, the sensors.fif are directly in the correct frame

##### MNE: COMPUTE BEM-1 FORWARD MODEL
mne_do_forward_solution --subject ${SUBJECT} --meas ${MEG_FIF} --megonly --mri $SCRIPTS/COR.fif --src ${SUBJECTS_DIR}/${SUBJECT}/bem/${SUBJECT}_from_MNI-${SOURCESPACE_TYPE}-${SPACE}-src.fif --fwd ${SCAN_DIR}/fwd_model-${SPACE}mm.fif --all

##### INFORM USER OF NEXT STEPS
echo 'forward modelling for' "${SUBJECT}" 'is done!'
