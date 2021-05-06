function points = transformPoints(pose, points, p)
if nargin > 2
    pose                = concatenateRts(twist2pose(p), pose);
end
points                  = pose*[points; ones(1, size(points,2))];

