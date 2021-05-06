function SparseMap = optimizeCam(SparseMap, frames, config)
if ~config.opt.apply; return; end 
if ~config.smatch.apply; return; end
%% Set up parameters
Track                       = SparseMap.Track;
Views                       = SparseMap.Views;
config.opt.length           = 1;
config.opt.var.cam          = 0; 
config.opt.var.pos          = 1; 
config.opt.var.str          = 0; 
config.opt.solver           = 'builtin'; 

BAConfig.regcams            = frames.regcams;
BAConfig.poses              = frames.regcams(end); 
BAConfig.tracks             = Views{BAConfig.poses}.tracks; 
BAConfig.fixposes           = setdiff(BAConfig.regcams, BAConfig.poses);
[BAConfig, config]          = configureLM(BAConfig, config);
BAVar                       = packVariables(Track, Views, frames, BAConfig); 

%% Remove outliers
pres                        = BACalcResidual(BAConfig, BAVar, config);
inliers                     = pres < median(pres); %config.opt.threshold;
pres                        = pres(inliers);
BAConfig.tracks             = BAConfig.tracks(inliers);
[BAConfig, config]          = configureLM(BAConfig, config);
BAVar                       = packVariables(Track, Views, frames, BAConfig); 

%% Optimization
rmse                        = sum(pres)/length(pres);
% fprintf('Activated:                                 %d points\n', length(pres)); 
% fprintf('Optimization Cost                          = %f\n', rmse);

BAVar                       = solveLM(BAConfig, BAVar, rmse, config);

% pres                        = BACalcResidual(BAConfig, BAVar, config);
% rmse                        = sum(pres)/length(pres);
% fprintf('Optimization Cost                          = %f\n', rmse);  if BAConfig.ctrl.display; pause; end
%% Save Data
for i = 1:length(frames.regcams)
Views{frames.regcams(i)}.pose              = invertPoses(BAVar.poses(:,:,i));
end  
SparseMap.Views             = Views;