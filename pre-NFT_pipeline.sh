export FREESURFER_HOME=/Applications/freesurfer/7.4.1
source $FREESURFER_HOME/SetUpFreeSurfer.sh

# pre-NFT pipeline
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

# convert mgz from FS to analyze format
declare -a files=("001" "nu" "orig" "orig_nu" "rawavg" "T1")
for FILE in "${files[@]}"
do
  echo " "
  echo "Processing $FILE"
  mri_convert -i ${FILE}.mgz --conform_size 1 --out_orientation PSR -ot spm -o ${FILE}.img
done