export FREESURFER_HOME=/opt/freesurfer/
source $FREESURFER_HOME/SetUpFreeSurfer.sh

export SUBJID=MNI
export SUBJID=MNI_rescaled
export SUBJID2=BCP1mo
export SUBJID3=MNI02mo
export SUBJECTS_DIR=/home/pcorvila/Documents/MRI/freesurfer

freeview -v /home/pcorvila/Documents/MRI/rescaled/MNIbrainrescaled.nii:opacity=0.5
# $SUBJECTS_DIR/MNI/mri/orig.nii:opacity=0.5 \
/home/pcorvila/Documents/MRI/rescaled/MNIbrainrescaled.nii:opacity=0.5


# $SUBJECTS_DIR/BCP1mo/mri/T1.mgz:opacity=0.5 \
# $SUBJECTS_DIR/MNI02mo/mri/T1.mgz:opacity=0.5

freeview -v \
/home/pcorvila/Documents/MRI/sources/$SUBJECT.nii:opacity=0.5 \
/home/pcorvila/Documents/MRI/rescaled/${SUBJECT}_rescaled.nii:opacity=0.5



freeview -v \
$SUBJECTS_DIR/$SUBJID/mri/T1.mgz:opacity=0.5 \
$SUBJECTS_DIR/$SUBJID2/mri/T1.mgz:opacity=0.5 \
$SUBJECTS_DIR/$SUBJID3/mri/T1.mgz:opacity=0.5 \
-f $SUBJECTS_DIR/$SUBJID/bem/inner_skull.surf:edgecolor=red \
-f $SUBJECTS_DIR/$SUBJID/surf/lh.seghead:edgecolor=yellow


freeview -v \
$SUBJECTS_DIR/$SUBJID2/mri/T1.mgz:opacity=0.5 \
-f /home/pcorvila/Documents/MRI/rescaled/MNI_brain_surface_rescaled2.stl \
/home/pcorvila/Documents/MRI/rescaled/MNI_inner_skull_rescaled.stl:edgecolor=red \


mris_convert $SUBJECTS_DIR/$SUBJID/bem/inner_skull.surf $SUBJECTS_DIR/$SUBJID/bem/inner_skull.stl

freeview -v \
$SUBJECTS_DIR/$SUBJID2/mri/T1.mgz:opacity=0.5 \
-f $SUBJECTS_DIR/$SUBJID/bem/inner_skull.surf:edgecolor=red \
$SUBJECTS_DIR/$SUBJID/bem/inner_skull_blender_export.surf
