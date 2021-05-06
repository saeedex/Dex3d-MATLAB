function pose = quat2pose(rotq, t)
rotq                            = quaternion(rotq);
theta                           = pi;
rot                             = [1 0 0; 0 cos(theta) -sin(theta) ; 0 sin(theta) cos(theta)] ;
pose                            = [quat2rotm(rotq)*rot t'];
