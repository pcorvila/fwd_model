%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CREATE SENSOR FILE FOR FORWARD MODELING %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function convert_fif(scan_dir)

%% Load paths

addpath(genpath('/media/thecix/toolboxes/MATLAB_compat'))
addpath(genpath('/media/thecix/toolboxes/RSN'))
addpath(genpath('/media/thecix/toolboxes/spm12'))


%% Load sensors positions

sensor_file = fullfile(scan_dir,'sensors.h5');

sensor_center = h5read(sensor_file,'/sensor_center').';
sensor_X = h5read(sensor_file,'/sensor_X').';
sensor_Y = h5read(sensor_file,'/sensor_Y').';
sensor_Z = h5read(sensor_file,'/sensor_Z').';

%sensor_label = convertStringsToChars(h5read(sensor_file,'/sensor_label')).';
sensor_label = h5read(sensor_file,'/sensor_label').';
%disp(sensor_label)
landmarks = h5read(sensor_file,'/landmarks');
% load(fullfile(root, project, subject, date, folder, "sensors.mat"))

    
%% CREATE MEASUREMENT FIFF FOR FORWARD MODELING


%Define output file 
meas_file = fullfile(scan_dir, 'sensors.fif');

% Get FIFF constants
global FIFF
FIFF = fiff_define_constants();
    
% Create measurement info structure
meas=[];
    meas.nchan=3*size(sensor_center,1);
    meas.sfreq=1200; % copied from OPMdig fiff [irrelevant]
    meas.highpass=40; % copied from OPMdig fiff [irrelevant]
    meas.lowpass=1; % copied from OPMdig fiff [irrelevant]
    meas.dev_head_t=[];
    meas.dev_head_t.from=1; % device frame
    meas.dev_head_t.to=4; % head frame
    meas.dev_head_t.trans=eye(4); % identity means that device frame = head frame
    meas.dig=[];
    meas.chs = [];
    k=0;
    for n=1:size(sensor_center,1)
        for xyz=1:3
            k=k+1;
            meas.chs(k).scanno=k;
            meas.chs(k).logno=k;
            meas.chs(k).kind=1;
            meas.chs(k).range=1;
            meas.chs(k).cal=1e-9/2.7; % calibration factor from V to T
            meas.chs(k).coil_type=3022; % magnetometer
            meas.chs(k).eeg_loc=[];
            meas.chs(k).coord_frame=1; % device frame = head frame
            meas.chs(k).unit=112; % T
            meas.chs(k).unit_mul=0;
            if xyz==1, sX=sensor_Y(n,:); sY=sensor_Z(n,:); sZ=sensor_X(n,:); sname='x';
            elseif xyz==2, sX=sensor_Z(n,:); sY=sensor_X(n,:); sZ=sensor_Y(n,:); sname='y';
            elseif xyz==3, sX=sensor_X(n,:); sY=sensor_Y(n,:); sZ=sensor_Z(n,:); sname='z';
            end
            meas.chs(k).loc=[sensor_center(n,:),sX,sY,sZ]';
            meas.chs(k).coil_trans=[[sX;sY;sZ;zeros(1,3)]';[0 0 0 1]];
            meas.chs(k).ch_name=[sensor_label{n}(6:end) sname]; % remove 'QZFM-' from name
        end
    end


% Start writeout of OPM measurement info fiff
fid = fiff_start_file(meas_file);
fiff_start_block(fid,FIFF.FIFFB_MEAS);
fiff_write_id(fid,FIFF.FIFF_BLOCK_ID);

% Write OPM measurement info
fiff_start_block(fid,FIFF.FIFFB_MEAS_INFO);
fiff_write_int(fid,FIFF.FIFF_NCHAN,meas.nchan);
fiff_write_float(fid,FIFF.FIFF_SFREQ,meas.sfreq);
fiff_write_float(fid,FIFF.FIFF_HIGHPASS,meas.highpass);
fiff_write_float(fid,FIFF.FIFF_LOWPASS,meas.lowpass);
fiff_write_coord_trans(fid,meas.dev_head_t);
for k=1:numel(meas.chs)
    fiff_write_ch_info(fid,meas.chs(k));
end
fiff_end_block(fid,FIFF.FIFFB_MEAS_INFO);
fiff_end_block(fid,FIFF.FIFFB_MEAS);

disp('sensors.fif was written')
    
