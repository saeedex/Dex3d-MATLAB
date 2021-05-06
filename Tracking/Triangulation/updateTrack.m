function [Track, Views] = updateTrack(Track, Views, tracks, kidx, kf)
%% Save view
Views{kf}.matched(kidx)         = true;

if ~isfield(Views{kf},'tracks')
Views{kf}.tracks                = [tracks kidx];
else
Views{kf}.tracks                = [Views{kf}.tracks; [tracks kidx]];
end

%% Save track
for j = 1:length(tracks)    
i                               = tracks(j);
Track(i).obsImages              = [Track(i).obsImages kf];
Track(i).obsInliers             = logical([Track(i).obsInliers 1]);
Track(i).obsLocs                = [Track(i).obsLocs Views{kf}.feat(1:2,kidx(j))];
Track(i).fidx                   = [Track(i).fidx kidx(j)];
Track(i).fDesc                  = Views{kf}.dsc(kidx(j),:);
end
