
export SCRIPTS=/Users/pcorvilain/Documents/Source_localization/scripts;
export SCRIPTS=/Users/pcorvilain/Documents/eeg_source_loc/;

export SUBJECT=MNI_05-08

blender-2.79 --python $SCRIPTS/coreg.py -- --sub=$SUBJECT

blender-2.93 --python $SCRIPTS/import_meshes.py -- --sub=$SUBJECT

blender-2.93 --python $SCRIPTS/elec_pos.py