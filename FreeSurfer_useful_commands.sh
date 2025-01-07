#MNE setup
export MNE_ROOT=/Users/pcorvilain/Documents/MNE-2.7.4-3420-MacOSX-x86_64
# zsh (default in macOS)
emulate sh -c 'source $MNE_ROOT/bin/mne_setup_sh'
## bash (switch to bash: type 'bash' in terminal)
# source $MNE_ROOT/bin/mne_setup_sh
## csh / tcsh
# setenv MNE_ROOT /Users/pcorvilain/Documents/MNE-2.7.4-3420-MacOSX-x86_64
# setenv MATLAB_ROOT /Applications/MATLAB_R2024b.app/bin
# source $MNE_ROOT/bin/mne_setup


recon-all -all -i $INPUT -subjid $SUBJECT
# if FOV > 256
recon-all -all -cw256 -i $INPUT -subjid $SUBJECT

