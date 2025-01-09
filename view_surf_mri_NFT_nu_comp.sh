export FREESURFER_HOME=/Applications/freesurfer/7.4.1
# source Freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

cd $1

freeview -v mri/orig.mgz \
nu/nu.mgz \
-f bem/outer_skin.surf:edgecolor=yellow \
bem/brain.surf:edgecolor=yellow \
bem/outer_skull.surf:edgecolor=yellow \
bem/inner_skull.surf:edgecolor=yellow \
nu/nu_scalp.surf:edgecolor=red \
nu/nu_skull.surf:edgecolor=red \
nu/nu_csf.surf:edgecolor=red \
nu/nu_brain.surf:edgecolor=red