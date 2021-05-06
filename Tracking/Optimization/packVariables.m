function BAVar      = packVariables(Track, Views, frames, BAConfig)
regcams             = BAConfig.regcams;
tracks              = BAConfig.tracks;
str                 = zeros(3+2*length(regcams),length(tracks));
vis                 = zeros(length(regcams), length(tracks));
cov                 = zeros(3*length(tracks),4);
%% Packing camera poses and intrinsics
BAVar.K             = frames.K;
for i = 1:length(regcams)
BAVar.poses(:,:,i)  = invertPoses(Views{regcams(i)}.pose);
end
%% Packing structure and its observations
for j = 1:length(tracks)
    track           = Track(tracks(j));  
    str(1:3,j)      = track.Str(1:3);    
    obsIdx          = track.obsImages(track.obsInliers);
    featlocs        = track.obsLocs(:,track.obsInliers);  
    if ~isempty(obsIdx)
    for i = 1:length(obsIdx)
        varidx                                  = obsIdx(i);  
        str((varidx-1)*2+4:(varidx-1)*2+5,j)    = featlocs(:,i);
        vis(varidx,j)                           = 1;
    end
    end
end

BAVar.str           = str;
BAVar.vis           = vis;
BAVar.cov           = cov;