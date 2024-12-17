export FREESURFER_HOME=/opt/freesurfer/
source $FREESURFER_HOME/SetUpFreeSurfer.sh

export SUBJECTS_DIR=/home/pcorvila/Documents/MRI/freesurfer

export SUBJID=BCP1mo
export INPUT=/home/pcorvila/Documents/MRI/sources/nihpd_asym_00-02_t1w.nii

export SUBJID=MNI02mo
export INPUT=/home/pcorvila/Documents/MRI/sources/BCP-01M-T1.nii.gz

export SUBJID=MNI

recon-all # stand for reconstruction, all prep
-s   # subject_name 
-i   # input file 
-all # do all prepro
-qcache # smoothes things, better for group analysis

# more info on recon-all
# https://surfer.nmr.mgh.harvard.edu/fswiki/recon-all
# https://surfer.nmr.mgh.harvard.edu/fswiki/OtherUsefulFlags

usefull option
-wsthresh pct 
-wsatlas
-wsmore

# chech tailarach transform 
tkregister2 --mgz --s $SUBJID --fstal 
# if error with tailarach but looks fine 
-notal-check


# example 
recon-all -s $SUBJID -autorecon1 -qcache -i $INPUT

# redo the skullstrip?
recon-all -skullstrip -wsmore -s $SUBJID -clean-bm
recon-all -skullstrip -wsatlas -s $SUBJID -clean-bm
recon-all -skullstrip -wsthresh 90 -s $SUBJID -clean-bm


# possible parralel mode, using package  
ls *.nii | parallel --jobs 8 recon-all -s {.} -i {} -all -qcache
# 8 -> nb of cores 
# {.} strip file from extensions
# {} all files founds


recon-all -skullstrip -wsthresh 100 -s $SUBJID -clean-bm
# freeview 
freeview -v \
$SUBJECTS_DIR/$SUBJID/mri/T1.mgz \
$SUBJECTS_DIR/$SUBJID/mri/brainmask.mgz:opacity=0.5 \
$SUBJECTS_DIR/$SUBJID/mri/brainmask.auto.mgz:opacity=0.5 \
-f $SUBJECTS_DIR/$SUBJID/bem/inner_skull.surf




