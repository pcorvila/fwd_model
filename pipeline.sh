## Freesurfer ##

# setup
export FREESURFER_HOME=/Applications/freesurfer/7.4.1
# source Freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# define subjects dir
export SUBJECTS_DIR=/Users/pcorvilain/Documents/Source_localization/Freesurfer_output
# define subject
export SUBJECT=MNI_02-05

# pre-free surfer NFT pipeline
export AGE_RANGE=02-05;
export FILE=nihpd_asym_${AGE_RANGE}_t1w;
export FILE=mni_icbm152_t1_tal_nlin_asym_55_ext;
# Inhomogeneity correction
mri_nu_correct.mni --i ${FILE}.nii --o ${FILE}_nu_corr.nii --n 2
# Conversion of the input volume to 1 mm volume data:
mri_convert -i ${FILE}_nu_corr.nii --conform_size 1 -o ${FILE}_1mm.nii
# Orient the image:
mri_convert -i ${FILE}_1mm.nii --out_orientation PSR -o ${FILE}_orient.nii
# Save in spm-analyze format:
mri_convert -i ${FILE}_orient.nii -ot spm -o ${FILE}_spm.img
# last 3 lines in one:
mri_convert -i ${FILE}_nu_corr.nii --conform_size 1 --out_orientation PSR -ot spm -o ${FILE}.img

# convert mgs from FS to analyze format
declare -a files=("001" "nu" "orig" "orig_nu" "rawavg" "T1")
for FILE in "${files[@]}"
do
  echo " "
  echo "Processing $FILE"
  mri_convert -i ${FILE}/${FILE}.mgz --conform_size 1 --out_orientation PSR -ot spm -o ${FILE}/${FILE}.img
done



# recon-all
export INPUT=/Users/pcorvilain/Library/CloudStorage/OneDrive-ChildrensHospitalLosAngeles/MNI_infants/MNI_02-05/nihpd_asym_02-05_t1w.nii
recon-all -all -i $INPUT -subjid $SUBJECT
# if FOV > 256
recon-all -all -cw256 -i $INPUT -subjid $SUBJECT
# if just the steps 1-5
recon-all -autorecon1 -i $INPUT -subjid $SUBJECT
# the steps 6-23
recon-all -autorecon2 -subjid $SUBJECT

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
cp $SUBJECTS_DIR/$SUBJECT/bem/watershed/${SUBJECT}_inner_skull_surface $SUBJECTS_DIR/$SUBJECT/bem/inner_skull.surf
# For BEM-3 only
cp $SUBJECTS_DIR/$SUBJECT/bem/watershed/${SUBJECT}_outer_skull_surface $SUBJECTS_DIR/$SUBJECT/bem/outer_skull.surf
cp $SUBJECTS_DIR/$SUBJECT/bem/watershed/${SUBJECT}_outer_skin_surface $SUBJECTS_DIR/$SUBJECT/bem/outer_skin.surf
# For comparison with 4 layers models
cp $SUBJECTS_DIR/$SUBJECT/bem/watershed/${SUBJECT}_brain_surface $SUBJECTS_DIR/$SUBJECT/bem/brain.surf

# convert surfaces to stl (for a blender visualisation)
mris_convert  $SUBJECTS_DIR/$SUBJECT/bem/brain.surf  $SUBJECTS_DIR/$SUBJECT/bem/brain.stl
mris_convert  $SUBJECTS_DIR/$SUBJECT/bem/inner_skull.surf  $SUBJECTS_DIR/$SUBJECT/bem/inner_skull.stl
mris_convert  $SUBJECTS_DIR/$SUBJECT/bem/outer_skull.surf  $SUBJECTS_DIR/$SUBJECT/bem/outer_skull.stl
mris_convert  $SUBJECTS_DIR/$SUBJECT/bem/outer_skin.surf  $SUBJECTS_DIR/$SUBJECT/bem/outer_skin.stl


# BEM-1
# mne_setup_forward_model --subject ${SUBJECT} --surf --ico 4 --homog
# BEM-3
mne_setup_forward_model --subject ${SUBJECT} --surf --ico 4

# stop here
## Deform subject to MNI (Matlab)
#ln -s $SUBJECTS_DIR/MNI ./
export SCRIPTS=/Users/pcorvilain/Documents/Source_localization/scripts
export SOURCESPACE_TYPE=volume # volume or cortex

$MATLAB_ROOT/matlab -nodisplay -r  "cd '${SCRIPTS}'; MNIdeformation_matlabpart('$SUBJECTS_DIR','$SUBJECT',5,'$SOURCESPACE_TYPE'); exit"


# define voxel size in mm
export SPACE=5
# create source space
mne_volume_source_space --surf $SUBJECTS_DIR/$SUBJECT/bem/inner_skull.surf --pos $SUBJECTS_DIR/$SUBJECT/bem/${SUBJECT}_from_MNI-${SOURCESPACE_TYPE}-${SPACE}.pnt --src $SUBJECTS_DIR/${SUBJECT}/bem/${SUBJECT}_from_MNI-${SOURCESPACE_TYPE}-${SPACE}-src.fif
