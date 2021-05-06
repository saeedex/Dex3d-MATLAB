function SparseMap = trackMap(SparseMap, frames, kf, config)
if ~config.smatch.apply; return; end
%% Tracking map points
Track                           = SparseMap.Track;
Views                           = SparseMap.Views;
[BAConfig, config]              = configureBA(Track, Views, frames.regcams, config);
tracks                          = BAConfig.tracks;
fidx                            = knnmatchwrap(Views{kf}.dsc, cat(1, Track(tracks(:, 1)).fDesc), config);
kidx                            = fidx(:,1);
tracks                          = tracks(fidx(:,2),1);
[Track, Views]                  = updateTrack(Track, Views, tracks, kidx, kf);
SparseMap.Track                 = Track;
SparseMap.Views                 = Views;