function frames = importARCore(frames, config)
if ~config.tracking.arcore; return; end
dirs                            = dir(strcat(frames.path, 'poses\', '*pose.txt'));
frames.arposes                  = {dirs.name};

dirs                            = dir(strcat(frames.path, 'depth\', '*depth.txt'));
frames.ardepth                  = {dirs.name};