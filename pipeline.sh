## Freesurfer ##

# setup
export FREESURFER_HOME=/Applications/freesurfer/7.4.1
# define subjects dir
export SUBJECTS_DIR=/Users/pcorvilain/Documents/Source_localization/Freesurfer_output
# define subject
export SUBJECT=MNI

# source Freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# recon-all
export INPUT=/Users/pcorvilain/Documents/Source_localization/source_MRI/MNI/orig.nii
recon-all -all -i $INPUT -subjid $SUBJECT



# make head surfaces
mkheadsurf -s $SUBJECT
mris_convert  $SUBJECTS_DIR/$SUBJECT/surf/lh.seghead  $SUBJECTS_DIR/$SUBJECT/surf/lh.seghead.stl

## MNE ##

# setup
export MNE_ROOT=/Users/pcorvilain/Documents/MNE-2.7.4-3420-MacOSX-x86_64
export MATLAB_ROOT=/Applications/MATLAB_R2024b.app/bin
# zsh (default in macOS)
emulate sh -c 'source $MNE_ROOT/bin/mne_setup_sh'
## bash (switch to bash: type 'bash' in terminal)
# source $MNE_ROOT/bin/mne_setup_sh
## csh / tcsh
# setenv MNE_ROOT /Users/pcorvilain/Documents/MNE-2.7.4-3420-MacOSX-x86_64
# setenv MATLAB_ROOT /Applications/MATLAB_R2024b.app/bin
# source $MNE_ROOT/bin/mne_setup

# set up mri subject
mne_setup_mri --subject $SUBJECT

# convert mgz to nii (freesurfer)
mri_convert -it mgz -ot nii -i $SUBJECTS_DIR/$SUBJECT/mri/orig.mgz -o $SUBJECTS_DIR/$SUBJECT/mri/orig.nii
mri_convert -it mgz -ot nii -i $SUBJECTS_DIR/$SUBJECT/mri/brain.mgz -o $SUBJECTS_DIR/$SUBJECT/mri/brain.nii


# creation of BEM
mne_watershed_bem --subject $SUBJECT
cp $SUBJECTS_DIR/$SUBJECT/bem/watershed/$SUBJECT_inner_skull_surface $SUBJECT/bem/inner_skull.surf

#mne_setup_forward_model --subject ${SUBJECT} --surf --ico 4 --homog # BEM-1
mne_setup_forward_model --subject ${SUBJECT} --surf --ico 4 # BEM-3

## Deform subject to MNI and nake source space
ln -s /Users/pcorvilain/Documents/Source_localization/Freesurfer_output/MNI ./
$MATLAB_ROOT/matlab -nodisplay