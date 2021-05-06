function [SparseMap, Views, frames] = initialTriangulation(mobs, kobs, fidx, Views, Images, frames, config)
%% Setting up
mf                              = frames.regcams(end-1);
kf                              = frames.regcams(end);

%% Triangulate
mproj                           = frames.K*invertPoses(Views{mf}.pose);
kproj                           = frames.K*invertPoses(Views{kf}.pose);
str                             = cv.triangulatePoints(mproj, kproj, mobs, kobs);
str                             = str./str(4,:);

%% Get color
colimage                        = double(Images{mf}.colimage)/255;
str                             = getSparseColor(str, colimage, mobs);

%% Save tracks
Track                           = initSparseMap(str);
offset                          = 0;
tracks                          = (1+offset:length(Track)+offset)';
[Track, Views]                  = updateTrack(Track, Views, tracks, fidx(:,1), mf);
[Track, Views]                  = updateTrack(Track, Views, tracks, fidx(:,2), kf);
[Track, Views]                  = updateInliers(Track, Views, frames, config);
SparseMap.Track                 = Track;