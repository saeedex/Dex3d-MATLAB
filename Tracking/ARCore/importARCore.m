function frames = importARCore(frames, config)
if ~config.tracking.arcore; return; end
dirs                            = dir(strcat(frames.path, '*pose.txt'));
frames.arposes                  = {dirs.name};
dirs                            = dir(strcat(frames.path, '*depth_points.txt'));
frames.arpoints                 = {dirs.name};