export FREESURFER_HOME=/Applications/freesurfer/7.4.1
# source Freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

export SUBJECTS_DIR_FS=/Users/pcorvilain/Documents/Source_localization/Freesurfer_output/

# requires export SUBJECT=MNI_05-08

freeview -v ${SUBJECTS_DIR_FS}/${SUBJECT}/mri/nu.mgz \
-f ${SUBJECTS_DIR_FS}${SUBJECT}/bem/outer_skin.surf:edgecolor=yellow \
${SUBJECTS_DIR_FS}${SUBJECT}/bem/brain.surf:edgecolor=yellow \
${SUBJECTS_DIR_FS}${SUBJECT}/bem/outer_skull.surf:edgecolor=yellow \
${SUBJECTS_DIR_FS}${SUBJECT}/bem/inner_skull.surf:edgecolor=yellow