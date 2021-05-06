function [Track, Views, frames]      = unpackVariables(Track, Views, frames, BAVar, BAConfig)
tracks              = BAConfig.tracks;
regcams             = BAConfig.regcams;
%% Intrinsic
frames.K                            = BAVar.K;
%% Poses
for i = 1:length(regcams)
Views{regcams(i)}.pose              = (BAVar.poses(:,:,i));
end  
%% Structure
for j = 1:length(tracks)
trackIdx                            = tracks(j);  
Track(trackIdx).Str(1:3)            = BAVar.str(1:3,j);  
end