clear 
headmodel = ft_read_headmodel('standard_bem.mat');
ft_plot_headmodel(headmodel, 'facealpha', 0.6)

%%
mri = ft_read_mri('standard_mri.mat');
cfg = [];
cfg.intersectmesh = {headmodel.bnd(1), headmodel.bnd(2), headmodel.bnd(3)}; % optional, these are from standard_bem.mat
ft_sourceplot(cfg, mri)

%%
cfg = [];
cfg.layout = 'biosemi32.lay';
ft_layoutplot(cfg)