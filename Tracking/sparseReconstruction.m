function SparseMap = sparseReconstruction(Views, Images, frames, config)
if ~config.run.srec; load(frames.sparse); return; end

%% Initialization
[SparseMap, frames]	= initialization(Views, Images, frames, config);

%% Incremental Reconstruction 
while length(frames.regcams) < frames.length
%%------ Tracking
kf                              = frames.regcams(end)+1;
SparseMap.Views                 = getARpose(SparseMap.Views, frames, kf, config);
SparseMap                       = trackMap(SparseMap, frames, kf, config);
SparseMap                       = initcampose(SparseMap, frames, kf, config);
frames.regcams                  = [frames.regcams kf];

%%------ Align camera
SparseMap                       = optimizeCam(SparseMap, frames, config); 

%%------ Point Management 
[SparseMap, frames]             = pointManagement(SparseMap, Images, frames, config);

%%------ Optimization   
[SparseMap, frames]             = optimization(SparseMap, frames, config);   



%%------ Visualization
SparseMap                       = insertARCorepoints(SparseMap, Images, frames, frames.regcams(end), config);
pose1                           = SparseMap.Views{kf-1}.pose;
pose2                           = SparseMap.Views{kf}.pose;
pose12                          = concatenateRts(invertPoses(pose1), pose2);
q12                             = [pose12(1:3,4)' rotm2quat(pose12(1:3,1:3))];
addRelativePose(SparseMap.poseGraph,q12);
displayPoints(SparseMap, Images, frames, config, length(frames.regcams));
displayPoses(SparseMap, frames, config, length(frames.regcams));
end
SparseMap.frames                = frames;