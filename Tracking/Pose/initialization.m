function [SparseMap, frames] = initialization(Views, Images, frames, config)
mf                              = 1;
kf                              = 2;
frames.regcams                  = [mf kf];
frames.K                        = initintr(Images, config);
Views{mf}.pose                  = [eye(3) zeros(3,1)];
Views                           = getARpose(Views, frames, mf, config);

SparseMap.ARTrack.str           = [];
SparseMap.ARTrack.idx           = [];

%% Match features
if config.smatch.apply
fidx                            = knnmatchwrap(Views{mf}.dsc, Views{kf}.dsc, config);
mobs                            = Views{mf}.feat(1:2,fidx(:,1));
kobs                            = Views{kf}.feat(1:2,fidx(:,2));
end

%% Estimate essential matrix
if ~config.tracking.arcore
[E, inliers]                    = cv.findEssentialMat(mobs', kobs', 'CameraMatrix', frames.K, 'Threshold', 0.9, 'Confidence', 0.9999);
inliers                         = logical(inliers);
[R, t]                          = cv.recoverPose(E, mobs(1:2,inliers)', kobs(1:2,inliers)');
Views{kf}.pose                  = invertPoses([R t]);
mobs                            = mobs(:,inliers);
kobs                            = kobs(:,inliers);
fidx                            = fidx(inliers,:);
end
Views                           = getARpose(Views, frames, kf, config);

%% Point management
if config.smatch.apply
[SparseMap, Views, frames]      = initialTriangulation(mobs, kobs, fidx, Views, Images, frames, config);
fprintf('----- INITIALIZED -----\n\n');
end
%% Optimization
SparseMap.Views                 = Views;
[SparseMap, frames]             = optimization(SparseMap, frames, config); 
SparseMap                       = insertARCorepoints(SparseMap, Images, frames, mf, config);
SparseMap                       = insertARCorepoints(SparseMap, Images, frames, kf, config);

%% Visualization
SparseMap.poseGraph          	= poseGraph3D;
pose1                           = SparseMap.Views{kf-1}.pose;
pose2                           = SparseMap.Views{kf}.pose;
pose12                          = concatenateRts(invertPoses(pose1), pose2);
q12                             = [pose12(1:3,4)' rotm2quat(pose12(1:3,1:3))];

addRelativePose(SparseMap.poseGraph,q12);
displayPoints(SparseMap, Images, frames, config, kf);
displayPoses(SparseMap, frames, config, kf);
