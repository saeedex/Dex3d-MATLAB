close all; clear all; clc; warning('off')
%% Setting up
config.dataset.path         = 'E:\Work\MATLAB\VSLAM\Platform\Dataset\Dual Pixel\';
config.dataset.name         = 'ARCore'; 
config.dataset.imresize     = 1;

%% Sparse Reconstruction
config.run.srec             = 1;
[frames, config]            = setConfigurations(config);
frames.K                    = [502.81366 0 321.0908; 0 503.23676 240.91353; 0 0 1];
sz                          = frames.K(1,1)*config.camera.alpha*config.camera.pixel_scale;
poseGraph                   = poseGraph3D;

dirs                        = dir(strcat(frames.path,'*.avi'));
frames.video                = {dirs.name};
frames.v                    = VideoReader(strcat(frames.path, frames.video{1}));

frames                      = importARCore(frames);
prepose                     = getARpose(frames, 1);
R0 = prepose(1:3,1:3);
t0 = prepose(1:3,4);
figure(12); hold on; grid minor;
for tidx = 2:10:size(frames.ARposes,1)
curpose                     = getARpose(frames, tidx);
R                           = curpose(1:3,1:3);
t                           = curpose(1:3,4);
rR                          = R0'*R;
rt                          = R0'*(t-t0);
rpose                       = [rR rt];

% relpose                     = concatenateRts(invertPoses(prepose), (curpose));
% relt                        = relpose(1:3,4);
% relR                        = relpose(1:3,1:3);
% relquat                     = [relt' rotm2quat(relR)];

% addRelativePose(poseGraph,relquat);
% prepose                     = curpose;

% figure(10); show(poseGraph); view(-90,0);
% figure(11); imshow(readFrame(frames.v))
rigp            = rigid3d(curpose(:,1:3)', curpose(:,4)');
 plotCamera('AbsolutePose',rigp, 'Size', sz, 'Color', 'blue', 'Opacity', 1);  axis equal; view(0,-90);
drawnow
end

% poseGraph = optimizePoseGraph(poseGraph);
% figure(2); show(poseGraph)