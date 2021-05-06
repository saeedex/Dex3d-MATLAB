function Views = getARpose(Views, frames, kf, config)
if ~config.tracking.arcore; return; end
ARdata                          = importdata([frames.path frames.arposes{kf}]);
t                               = ARdata(1:3);
rotq                            = [ARdata(end) ARdata(4:end-1)];
pose                            = quat2pose(rotq, t);
Views{kf}.pose                  = pose;