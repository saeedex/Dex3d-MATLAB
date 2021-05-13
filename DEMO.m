close all; clear all; clc; warning('off')
%% Setting up
config.dataset.path         = [pwd '\Dataset\'];
config.dataset.name         = 'pagoda'; % 'deskhx' 'dinohx' 'cupshx' 'cupscp' 'cupsdp' 'toysdp' 'bridgezed'
config.dataset.imresize     = 1;
config.dataset.rotate       = -90; 
config.dataset.maxz         = 3;
frames                      = setframepath(config);

%% Sparse Reconstruction
config.run.srec             = 0;
config.save.srec            = 0;
config                      = sparseConfig(config);
frames                      = importARCore(frames, config);
[Images, frames]            = loadFrames(frames, config);
[Views]                     = extractFeatures(Images, config);
SparseMap                   = sparseReconstruction(Views, Images, frames, config);

%% Visualization
config.display              = 1; 
displayPoints(SparseMap, Images, SparseMap.frames, config, length(SparseMap.frames.regcams));
if config.save.srec; save(frames.sparse, 'SparseMap'); end

%% Dense reconstruction
close all; clc;
config.run.drec             = 1;
config                      = denseConfig(config);
[dViews, Images]            = denseReconstruction(Images, SparseMap.frames, SparseMap, config); 

%% Fusion
[pcl, map, Images]          = depthfusion(dViews, SparseMap, Images, config);
ptCloud                     = pointCloud(pcl(1:3,:)', 'Normal', pcl(4:6,:)', 'Color', pcl(7:9,:)');
figure(2); pcshow(ptCloud);

%% Export
savepath                    = [SparseMap.frames.path 'reconstruction\'];
saveOUT(SparseMap, Images, pcl, map);
TSDFExport(SparseMap, Images, config);
% pcwrite(ptCloud,[savepath 'dense']);