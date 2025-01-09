export FREESURFER_HOME=/Applications/freesurfer/7.4.1
# source Freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

export SUBJECT=$1

freeview -v ${SUBJECT}.img \
-f ${SUBJECT}_outer_skin.surf:edgecolor=yellow \
${SUBJECT}_brain.surf:edgecolor=yellow \
${SUBJECT}_outer_skull.surf:edgecolor=yellow \
${SUBJECT}_inner_skull.surf:edgecolor=yellow