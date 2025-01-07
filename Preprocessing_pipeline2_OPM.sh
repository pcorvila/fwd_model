# open a bash shell

export SCRIPTS=/media/thecix/toolboxes/OPM_Coreg


# STEP 0: Enter data

# Enter MRI directory of the subject (output folder of freesurfer)
export MRI_DIR=

# Enter Scan directory of the subject (where the Scan.stl and Scan.p3 from the 3D scanner are)
export SCAN_DIR=


## STEP 1: CO-REGISTRATION

# First do the coregistration in blender 2.79 using the add-on developed by Zetter (It uses ICP).
# You can open Blender 2.79 and load the irm and the optic scan using the following command with the appropriate options
# notes: 1. works also without options 2. when passing options, the '--' is required


/opt/blender-2.79/blender --python $SCRIPTS/coreg.py -- --mri_dir=$MRI_DIR --scan_dir=$SCAN_DIR

# Use the addon and save the relevant 4x4 matrix in coreg.transform or coreg_ext.transform with ext of your choice


## STEP 2: import sensors to scan and fill-in matching file


/opt/blender-2.93/blender --python $SCRIPTS/matching.py --  --scan_dir=$SCAN_DIR



## STEP 3: create a h5 file with the sensors positions in IRM coordinates and import sensors to IRM

# Old cap version with option: --old_version


/opt/blender-2.93/blender --python $SCRIPTS/export.py -- --mri_dir=$MRI_DIR --scan_dir=$SCAN_DIR

# new option: --brain, requires first
# mris_convert $MRI_DIR/surf/rh.pial $MRI_DIR/surf/rh.stl
# mris_convert $MRI_DIR/surf/lh.pial $MRI_DIR/surf/lh.stl 

# Old cap version with option: --old_version


## STEP 4: Do fwd modelling

# if you have a different name for your subject in MRI that in MEG 
# export SUBJECT=MRI_SUBJECT_NAME

export SPACE=1
export SOURCESPACE_TYPE=volume # volume or cortex

source $SCRIPTS/fwd_modelling_OPM.sh 


