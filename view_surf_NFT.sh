export FREESURFER_HOME=/Applications/freesurfer/7.4.1
# source Freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

export SUBJECTS_DIR_NFT=/Users/pcorvilain/Documents/Source_localization/NFT_output/

freeview -v ${SUBJECTS_DIR_NFT}/$SUBJECT/mri/nu.mgz \
-f ${SUBJECTS_DIR_NFT}/$SUBJECT/surf/scalp.surf:edgecolor=red \
${SUBJECTS_DIR_NFT}/$SUBJECT/surf/skull.surf:edgecolor=red \
${SUBJECTS_DIR_NFT}/$SUBJECT/surf/csf.surf:edgecolor=red \
${SUBJECTS_DIR_NFT}/$SUBJECT/surf/brain.surf:edgecolor=red