function [BAConfig, config] = configureBA(Track, Views, regcams, config)
BAConfig.regcams            = regcams;
%% Extract Data    
if strcmp(config.opt.method, 'global')
    BAConfig.poses          = regcams;
    BAConfig.tracks         = [1:length(Track)]';
    config.opt.threshold    = 3;
else
    BAConfig.poses          = regcams(max(1, end-config.opt.length):end);
    BAConfig.poses          = BAConfig.poses(2:end);
    tracks                  = [];
    for i = 1:length(BAConfig.poses)
    tracks                  = [tracks; Views{BAConfig.poses(i)}.tracks(:, 1)];
    end
    BAConfig.tracks         = unique(tracks); 
end

BAConfig.fixposes           = setdiff(BAConfig.regcams, BAConfig.poses);
