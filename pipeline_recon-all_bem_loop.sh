## Freesurfer ##

# setup
export FREESURFER_HOME=/Applications/freesurfer/7.4.1
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# define subjects dir
export SUBJECTS_DIR=/Users/pcorvilain/Documents/Source_localization/Freesurfer_output
# define subject
export SUBJECT=MNI_08-11

# recon-all
export INPUT=/Users/pcorvilain/Library/CloudStorage/OneDrive-ChildrensHospitalLosAngeles/MNI_infants/MNI_08-11/nihpd_asym_08-11_t1w.nii
# if just the steps 1-5
recon-all -autorecon1 -i $INPUT -subjid $SUBJECT
# the steps 6-23
recon-all -autorecon2 -subjid $SUBJECT

# make head surfaces
mkheadsurf -s $SUBJECT
mris_convert  $SUBJECTS_DIR/$SUBJECT/surf/lh.seghead  $SUBJECTS_DIR/$SUBJECT/surf/lh.seghead.stl

## MNE ##
# setup
export MNE_ROOT=/Applications/MNE-2.7.4-3420-MacOSX-x86_64
export MATLAB_ROOT=/Applications/MATLAB_R2024b.app/bin
emulate sh -c 'source $MNE_ROOT/bin/mne_setup_sh'

# set up mri subject
mne_setup_mri --subject $SUBJECT

# convert mgz to nii (freesurfer)
mri_convert -it mgz -ot nii -i $SUBJECTS_DIR/$SUBJECT/mri/orig.mgz -o $SUBJECTS_DIR/$SUBJECT/mri/orig.nii
mri_convert -it mgz -ot nii -i $SUBJECTS_DIR/$SUBJECT/mri/brain.mgz -o $SUBJECTS_DIR/$SUBJECT/mri/brain.nii

# creation of BEM
mne_watershed_bem --subject $SUBJECT
cp $SUBJECTS_DIR/$SUBJECT/bem/watershed/${SUBJECT}_inner_skull_surface $SUBJECTS_DIR/$SUBJECT/bem/inner_skull.surf
# For BEM-3 only
cp $SUBJECTS_DIR/$SUBJECT/bem/watershed/${SUBJECT}_outer_skull_surface $SUBJECTS_DIR/$SUBJECT/bem/outer_skull.surf
cp $SUBJECTS_DIR/$SUBJECT/bem/watershed/${SUBJECT}_outer_skin_surface $SUBJECTS_DIR/$SUBJECT/bem/outer_skin.surf
# For comparison with 4 layers models
cp $SUBJECTS_DIR/$SUBJECT/bem/watershed/${SUBJECT}_brain_surface $SUBJECTS_DIR/$SUBJECT/bem/brain.surf
cp $SUBJECTS_DIR/$SUBJECT/surf/lh.seghead $SUBJECTS_DIR/$SUBJECT/bem/seghead.surf

# convert surfaces to stl (for a blender visualisation)
mkdir $SUBJECTS_DIR/$SUBJECT/bem/stl
mris_convert  $SUBJECTS_DIR/$SUBJECT/bem/brain.surf  $SUBJECTS_DIR/$SUBJECT/bem/stl/brain.stl
mris_convert  $SUBJECTS_DIR/$SUBJECT/bem/inner_skull.surf  $SUBJECTS_DIR/$SUBJECT/bem/stl/inner_skull.stl
mris_convert  $SUBJECTS_DIR/$SUBJECT/bem/outer_skull.surf  $SUBJECTS_DIR/$SUBJECT/bem/stl/outer_skull.stl
mris_convert  $SUBJECTS_DIR/$SUBJECT/bem/outer_skin.surf  $SUBJECTS_DIR/$SUBJECT/bem/stl/outer_skin.stl
mris_convert  $SUBJECTS_DIR/$SUBJECT/bem/seghead.surf  $SUBJECTS_DIR/$SUBJECT/bem/stl/seghead.stl

# view output
freeview -v $SUBJECTS_DIR/$SUBJECT/mri/orig.mgz \
-f $SUBJECTS_DIR/$SUBJECT/bem/brain.surf \
$SUBJECTS_DIR/$SUBJECT/bem/outer_skull.surf \
$SUBJECTS_DIR/$SUBJECT/bem/inner_skull.surf \
$SUBJECTS_DIR/$SUBJECT/bem/outer_skin.surf \
$SUBJECTS_DIR/$SUBJECT/bem/seghead.surf
