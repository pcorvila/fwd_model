function system_test_matlabpart(subjects_dir,subject,space,constr)

matlab_path = userpath;

addpath(genpath(fullfile(matlab_path,'RSN')))
addpath(genpath(fullfile(matlab_path,'MATLAB_compat')))
addpath(genpath(fullfile(matlab_path,'spm12')))

cfg=[];
  cfg.subjects_dir=subjects_dir;
  cfg.subject=subject;
  cfg.space=space;
  cfg.constraint=constr;
mni2subj_spm_morph_src(cfg)
