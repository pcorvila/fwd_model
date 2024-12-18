## Freesurfer ##

# setup
export FREESURFER_HOME=/Applications/freesurfer/7.4.1
# source Freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# define subjects dir
export SUBJECTS_DIR=/Users/pcorvilain/Documents/Source_localization/Freesurfer_output
# define subject
export SUBJECT=UNC_BCP_04Months


freeview -v \
$SUBJECTS_DIR/$SUBJECT/mri/orig.mgz \
-f $SUBJECTS_DIR/$SUBJECT/bem/outer_skin.surf \
-f $SUBJECTS_DIR/$SUBJECT/bem/outer_skull.surf \
-f $SUBJECTS_DIR/$SUBJECT/bem/inner_skull.surf

