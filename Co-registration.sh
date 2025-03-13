
# Step 1: locate the electrodes using Matlab script loc_electrodes.m

export SCRIPTS=/Users/pcorvilain/Documents/eeg_source_loc/

#blender-2.93 --python $SCRIPTS/rescale_seghead.py

blender-2.79 --python $SCRIPTS/coreg.py

blender-2.93 --python $SCRIPTS/plot_electrodes.py

