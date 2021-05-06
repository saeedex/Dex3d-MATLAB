function [Track, Views] = triangulateNewpoints(Track, Views, Images, frames, config)
kf                  = frames.regcams(end);
conimages           = frames.regcams(max(1, end-config.opt.length):end);
conimages           = conimages(conimages ~= kf);

%% FLANN
for i = 1:length(conimages)
mf                  = conimages(i);
midx                = find(~Views{mf}.matched)';
kidx                = find(~Views{kf}.matched)';
if isempty(kidx); return; end
if isempty(midx); return; end
fidx                = knnmatchwrap(Views{mf}.dsc(midx,:), Views{kf}.dsc(kidx,:), config);
if isempty(fidx); return; end
kproj               = frames.K*invertPoses(Views{kf}.pose);
kfeat               = Views{kf}.feat(1:2,kidx(fidx(:,2)));
mproj               = frames.K*invertPoses(Views{mf}.pose);
mfeat               = Views{mf}.feat(1:2,midx(fidx(:,1)));
str                 = cv.triangulatePoints(mproj, kproj, mfeat, kfeat);
str                 = str./str(4,:);

% inliers             = checkStructure(str, Views, frames, mf, midx(fidx(:,1)), config);
% str                 = str(:, inliers);
% fidx                = fidx(inliers,:);
% 
% inliers             = checkStructure(str, Views, frames, kf, kidx(fidx(:,2)), config);
% str                 = str(:, inliers);
% fidx                = fidx(inliers,:);

%% Get color
colimage            = double(Images{kf}.colimage)/255;
str                 = getSparseColor(str, colimage, kfeat);
%% Update tracks
offset              = length(Track);
tTrack              = initSparseMap(str);
tracks              = (1+offset:length(tTrack)+offset)';
Track               = [Track tTrack];
[Track, Views]      = updateTrack(Track, Views, tracks, midx(fidx(:,1)), mf);
[Track, Views]      = updateTrack(Track, Views, tracks, kidx(fidx(:,2)), kf);
end
