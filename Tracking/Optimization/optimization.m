function [SparseMap, frames] = optimization(SparseMap, frames, config)
if ~config.opt.apply; return; end 
%% Set up parameters
Track                       = SparseMap.Track;
Views                       = SparseMap.Views;
regcams                     = frames.regcams;

[BAConfig, config]          = configureBA(Track, Views, regcams, config);
[BAConfig, config]          = configureLM(BAConfig, config);
BAVar                       = packVariables(Track, Views, frames, BAConfig); 

%% Remove outliers
pres                        = BACalcResidual(BAConfig, BAVar, config);
inliers                     = pres < config.opt.threshold;
pres                        = pres(inliers);
BAConfig.tracks             = BAConfig.tracks(inliers);

BAVar                       = packVariables(Track, Views, frames, BAConfig); 
[BAConfig, config]          = configureLM(BAConfig, config);

%% Optimization
rmse                        = sum(pres)/length(pres);
fprintf('Activated:                                 %d points\n', length(pres)); 
fprintf('Optimization Cost                          = %f\n', rmse);

BAVar                       = solveLM(BAConfig, BAVar, rmse, config);
BAVar                       = interleavedLM(BAConfig, BAVar, rmse, config);
pres                        = BACalcResidual(BAConfig, BAVar, config);
rmse                        = sum(pres)/length(pres);
fprintf('Optimization Cost                          = %f\n', rmse);  if BAConfig.ctrl.display; pause; end
%% Save Data
[Track, Views, frames]      = unpackVariables(Track, Views, frames, BAVar, BAConfig);
[Track, Views]              = updateInliers(Track, Views, frames, config);
SparseMap.Track             = Track;
SparseMap.Views             = Views;
