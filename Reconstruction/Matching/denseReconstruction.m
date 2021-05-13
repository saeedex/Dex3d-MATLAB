function [dViews, Images] = denseReconstruction(Images, frames, SparseMap, config) 
if ~config.run.drec; return; end
load MyColormaps;
Views                               = SparseMap.Views;
dirs                                = dir(strcat(frames.path, '*depth.txt'));
frames.ardepth                      = {dirs.name};

%% Stacy Depth
for j = 1:length(frames.regcams)
kf                                  = frames.regcams(j);
Images{kf}.depth                    = importARdepth(Images, frames, kf, config);
end

%% Rescale depth
% [Images, frames]                    = depthrescale2(Images, SparseMap.Track, Views, frames, config);

%% Initialization
kf                                  = frames.regcams(1);
dViews{kf}                          = initdensestructure(Images, config);
dViews                              = depth2pcl(dViews, Views, Images, frames, kf, config);
dViews                              = computeIDSRcov(dViews, Views, frames, kf, config); 

%% Dense reconstruction
for j = 2:length(frames.regcams)
kf                                  = frames.regcams(j);
mf                                  = kf - 1;
dViews{kf}                          = initdensestructure(Images, config);

%%--- Dense matching
dViews                              = denseMatching(dViews, Views, Images, frames, kf, mf, config);

%%---- Refine pcl
dViews                              = depth2pcl(dViews, Views, Images, frames, kf, config);
dViews                              = computeIDSRcov(dViews, Views, frames, kf, config); 
dViews                              = refinepoints(dViews, Views, frames, kf, mf, config);
dViews                              = costGeometric(dViews, Views, frames, kf);
end
