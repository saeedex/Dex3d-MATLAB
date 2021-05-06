function [Track, Views] = updateInliers(Track, Views, frames, config, tracks)
if nargin < 5
    tracks = [1:length(Track)]';
end
for i = 1:length(tracks)

    for j = 1:size(Track(tracks(i)).obsImages, 2)
    pose            = invertPoses(Views{Track(tracks(i)).obsImages(1, j)}.pose);
    iobs            = Track(tracks(i)).obsLocs(:, j);
    str             = Track(tracks(i)).Str;
    [iprj,~,iz]     = projectPoints(frames.K, pose, str);        
    res             = iprj - iobs;
    pres            = sum(res.^2,1);
    
    if pres > config.opt.threshold
    Track(tracks(i)).obsInliers(j) = false;
    end
    
    if iz <= 0
    Track(tracks(i)).obsInliers(j) = false;
    end
    end     
end
