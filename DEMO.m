close all; clear all; clc; warning('off')
%% Setting up
config.dataset.path         = [pwd '\Dataset\'];
config.dataset.name         = 'statue01'; % 'deskhx' 'dinohx' 'cupshx' 'cupscp' 'cupsdp' 'toysdp' 'bridgezed'
config.dataset.imresize     = 1;
config.dataset.rotate       = -90; 
config.dataset.maxz         = 3;
frames                      = setframepath(config);

%% Sparse Reconstruction
config.run.srec             = 1;
config.save.srec            = 1;
config                      = sparseConfig(config);
frames                      = importARCore(frames, config);
[Images, frames]            = loadFrames(frames, config);
Views                       = extractFeatures(Images, config);
SparseMap                   = sparseReconstruction(Views, Images, frames, config);

%% Visualization
config.display              = 1; 
displayPoints(SparseMap, Images, SparseMap.frames, config, length(SparseMap.frames.regcams));
if config.save.srec; save(frames.sparse, 'SparseMap'); saveXML(SparseMap, Images); end
%% Dense reconstruction
close all
config.run.drec             = 1;
config                      = denseConfig(config);
[dViews, Images]            = denseReconstruction(Images, SparseMap.frames, SparseMap, config); 

%% Fusion
[ptCloud, Images]           = depthfusion(dViews, SparseMap.Views, Images, SparseMap.frames, config);
TSDFExport(SparseMap, Images, config)

savepath                    = [SparseMap.frames.path 'reconstruction\'];
pcwrite(ptCloud,[savepath 'dense']);