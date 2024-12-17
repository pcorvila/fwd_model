function system_test_matlabpart(subjects_dir,subject,space,constr)

addpath(genpath('/media/thecix/toolboxes/MATLAB_compat'))
addpath(genpath('/media/thecix/toolboxes/RSN'))
addpath(genpath('/media/thecix/toolboxes/spm12'))

cfg=[];
  cfg.subjects_dir=subjects_dir;
  cfg.subject=subject;
  cfg.space=space;
  cfg.constraint=constr;
mni2subj_spm_morph_src(cfg)
