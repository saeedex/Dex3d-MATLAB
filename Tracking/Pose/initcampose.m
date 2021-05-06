function SparseMap     = initcampose(SparseMap, frames, kf, config)
if isfield(frames,'v'); return; end
if config.tracking.arcore; return; end
%% Input
Track                           = SparseMap.Track;
Views                           = SparseMap.Views;

%% Tracking map points
fidx                            = Views{kf}.tracks;
kobs                            = Views{kf}.feat(1:2,fidx(:,2));
points                          = cat(2, Track(fidx(:,1)).Str);

%% Estimating camera pose
if config.display
fprintf('Tracking:                                  %d points\n', size(points,2));
end
[w, t]                          = cv.solvePnPRansac(points(1:3,:)', kobs', frames.K, 'ReprojectionError', config.opt.threshold, 'Method', 'EPnP', 'Confidence', 0.9999);
R                               = cv.Rodrigues(w);
Views{kf}.pose                  = invertPoses([R t]);

%% Output
SparseMap.Views                 = Views;
SparseMap.Track                 = Track;