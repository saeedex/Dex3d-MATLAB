function frames = setframepath(config)
%% Frames path
frames.path                         = strcat(config.dataset.path, config.dataset.name, '\');
dirs                                = dir([frames.path '*IMG*.jpg']);
frames.color                        = {dirs.name};
frames.length                       = length(frames.color);
frames.sparse                       = [frames.path 'SparseMap_' config.dataset.name '.mat'];
