
export SCRIPTS=/Users/pcorvilain/Documents/eeg_source_loc/;

blender-2.79 --python $SCRIPTS/coreg.py

blender-2.93 --python $SCRIPTS/import_meshes.py

blender-2.93 --python $SCRIPTS/elec_pos.py

blender-2.93 --python $SCRIPTS/plot_electrodes.py

blender-2.93 --python $SCRIPTS/rescale_seghead.py