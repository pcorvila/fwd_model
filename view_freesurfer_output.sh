## Freesurfer ##

# setup
export FREESURFER_HOME=/Applications/freesurfer/7.4.1
# source Freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# define subjects dir
export SUBJECTS_DIR=/Users/pcorvilain/Documents/Source_localization/Freesurfer_output
# define subject
export SUBJECT=MNI_5-8_months

freeview -v \
$SUBJECTS_DIR/$SUBJECT/mri/orig.mgz \
-f $SUBJECTS_DIR/$SUBJECT/bem/outer_skin.surf \
-f $SUBJECTS_DIR/$SUBJECT/bem/brain.surf \
-f $SUBJECTS_DIR/$SUBJECT/bem/outer_skull.surf \
-f $SUBJECTS_DIR/$SUBJECT/bem/inner_skull.surf

cd $SUBJECTS_DIR/$SUBJECT
freeview -v mri/brainmask.mgz \
mri/wm.mgz:colormap=heat:opacity=0.4:visible=0 \
-f surf/lh.orig.nofix:visible=1:edgecolor=red \
surf/rh.orig.nofix:visible=1:edgecolor=red \
surf/lh.smoothwm.nofix:visible=1 \
surf/rh.smoothwm.nofix:visible=1

# freeview tips:
# - cmd-shift-s: remove the 2D slices
# - alt-v : check and uncheck the visibility of the volumes

export SUBJECTS_DIR=/Users/pcorvilain/Documents/Source_localization/MNI_05-08_test_FS_output
export SUBJECTS_DIR=/Users/pcorvilain/Documents/Source_localization
export SUBJECT=MNI_05-08_test2;

freeview -v $SUBJECT.img \

export FREESURFER_HOME=/Applications/freesurfer/7.4.1
# source Freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh
export SUBJECT=
freeview -f ${SUBJECT}_outer_skin.surf \
${SUBJECT}_brain.surf \
${SUBJECT}_outer_skull.surf \
${SUBJECT}_inner_skull.surf
