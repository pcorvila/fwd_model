export FREESURFER_HOME=/Applications/freesurfer/7.4.1
# source Freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

export SUBJECT=$1

freeview -f ${SUBJECT}_outer_skin.surf \
${SUBJECT}_brain.surf \
${SUBJECT}_outer_skull.surf \
${SUBJECT}_inner_skull.surf