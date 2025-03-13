export FREESURFER_HOME=/Applications/freesurfer/7.4.1
# source Freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

export SUBJECTS_DIR_FS=/Users/pcorvilain/Documents/Source_localization/Freesurfer_output/

export SUBJECT=MNI_05-08
freeview -v ${SUBJECTS_DIR_FS}/${SUBJECT}/mri/nu.mgz \
-f ${SUBJECTS_DIR_FS}${SUBJECT}/bem/outer_skin.surf:edgecolor=yellow \
${SUBJECTS_DIR_FS}${SUBJECT}/bem/outer_skull.surf:edgecolor=orange \
${SUBJECTS_DIR_FS}${SUBJECT}/bem/inner_skull.surf:edgecolor=red \
${SUBJECTS_DIR_FS}${SUBJECT}/bem/brain.surf:edgecolor=blue

# compare outer_skin and seghead
export SUBJECT=MNI_02-05
freeview -v ${SUBJECTS_DIR_FS}/${SUBJECT}/mri/nu.mgz \
-f ${SUBJECTS_DIR_FS}${SUBJECT}/bem/stl/${SUBJECT}_outer_skin.stl:edgecolor=yellow \
${SUBJECTS_DIR_FS}${SUBJECT}/bem/stl/${SUBJECT}_seghead.stl:edgecolor=red \
${SUBJECTS_DIR_FS}${SUBJECT}/bem/stl/${SUBJECT}_seghead_rescaled.stl:edgecolor=green

# compare 2 subjects
export SUBJECT1=MNI_02-05
export SUBJECT=MNI_05-08
freeview -v ${SUBJECTS_DIR_FS}/${SUBJECT1}/mri/${SUBJECT1}_nu.mgz \
${SUBJECTS_DIR_FS}/${SUBJECT}/mri/${SUBJECT}_nu.mgz \
-f ${SUBJECTS_DIR_FS}${SUBJECT1}/bem/stl/${SUBJECT1}_brain.stl:edgecolor=yellow \
${SUBJECTS_DIR_FS}${SUBJECT1}/bem/stl/${SUBJECT1}_seghead_rescaled.stl:edgecolor=yellow \
${SUBJECTS_DIR_FS}${SUBJECT1}/bem/stl/${SUBJECT1}_inner_skull.stl:edgecolor=yellow \
${SUBJECTS_DIR_FS}${SUBJECT1}/bem/stl/${SUBJECT1}_outer_skull.stl:edgecolor=yellow \
${SUBJECTS_DIR_FS}${SUBJECT}/bem/stl/${SUBJECT}_brain.stl:edgecolor=red \
${SUBJECTS_DIR_FS}${SUBJECT}/bem/stl/${SUBJECT}_seghead_rescaled.stl:edgecolor=red \
${SUBJECTS_DIR_FS}${SUBJECT}/bem/stl/${SUBJECT}_inner_skull.stl:edgecolor=red \
${SUBJECTS_DIR_FS}${SUBJECT}/bem/stl/${SUBJECT}_outer_skull.stl:edgecolor=red