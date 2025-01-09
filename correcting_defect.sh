export FREESURFER_HOME=/Applications/freesurfer/7.4.1
source $FREESURFER_HOME/SetUpFreeSurfer.sh
export SUBJECTS_DIR=/Users/pcorvilain/Documents/Source_localization/Freesurfer_output
export SUBJECT=MNI_00-02

freeview -v $SUBJECTS_DIR/$SUBJECT/mri/brainmask.mgz \
$SUBJECTS_DIR/$SUBJECT/mri/wm.mgz:colormap=heat:opacity=0.4:visible=0 \
-f $SUBJECTS_DIR/$SUBJECT/surf/lh.white:edgecolor=yellow \
$SUBJECTS_DIR/$SUBJECT/surf/lh.pial:edgecolor=red \
$SUBJECTS_DIR/$SUBJECT/surf/rh.white:edgecolor=yellow \
$SUBJECTS_DIR/$SUBJECT/surf/rh.pial:edgecolor=red \
$SUBJECTS_DIR/$SUBJECT/surf/lh.orig.nofix:visible=0