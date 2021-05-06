function [SparseMap, frames] = pointManagement(SparseMap, Images, frames, config)
if ~config.smatch.apply; return; end
%% Input
Track                           = SparseMap.Track;
Views                           = SparseMap.Views;

%% Triangulate new points
[Track, Views]                  = triangulateNewpoints(Track, Views, Images, frames, config); 
[Track, Views]                  = updateInliers(Track, Views, frames, config);

%% Output
SparseMap.Track                 = Track;
SparseMap.Views                 = Views;