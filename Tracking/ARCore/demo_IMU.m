close all; clear all; clc; warning('off')
%% Setting up
config.dataset.path         = 'E:\Work\MATLAB\VSLAM\Platform\Dataset\Dual Pixel\';
config.dataset.name         = 'ARCore'; 
config.dataset.imresize     = 1;

%% Sparse Reconstruction
config.run.srec             = 1;
[frames, config]            = setConfigurations(config);
frames.K                    = [502.81366 0 321.0908; 0 503.23676 240.91353; 0 0 1];
sz                          = 0.1*frames.K(1,1)*config.camera.alpha*config.camera.pixel_scale;
poseGraph                   = poseGraph3D;
FUSE                        = imufilter;

dirs                        = dir(strcat(frames.path,'*.avi'));
frames.video                = {dirs.name};
frames.v                    = VideoReader(strcat(frames.path, frames.video{1}));

frames                      = importIMU(frames);
sampleRate                  = 100;
filt                        = insfilterErrorState('IMUSampleRate', sampleRate, 'ReferenceFrame', 'ENU');
prepose                     = [eye(3) zeros(3,1)];
for tidx = 1:size(frames.IMU,1)
accelMeas                   = frames.IMU(tidx,2:4);
gyroMeas                    = frames.IMU(tidx,5:end);
[orientation,angularVelocity] = FUSE(accelMeas,gyroMeas);
predict(filt, accelMeas, gyroMeas);

[t,quat, vt]                = pose(filt); 

curpose                     = [quat2rotm(quat) t'];

relpose                     = concatenateRts(invertPoses(curpose),prepose);
relt                        = relpose(1:3,4);
relR                        = relpose(1:3,1:3);
relquat                     = [relt' rotm2quat(relR)];

addRelativePose(poseGraph,relquat);
prepose                     = curpose;

% figure(10); show(poseGraph); view(-90,0);
% figure(11); imshow(readFrame(frames.v))
% drawnow
% addRelativePose(poseGraph,relquat);
% pose1                       = pose2;
% figure(10); show(poseGraph); view(-90,0);
% figure(11); imshow(readFrame(frames.v))
% drawnow
% rigp            = rigid3d(pose(:,1:3)', pose(:,4)');
% plotCamera('AbsolutePose',rigp, 'Size', sz, 'Color', 'black', 'Opacity', 0);  gcf;
end
show(poseGraph);