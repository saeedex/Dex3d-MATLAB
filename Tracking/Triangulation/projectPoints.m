function [prj, uv, iz]  = projectPoints(K, pose, points, p, dstr)
if size(points, 1) > 3
    points                  = points(1:3,:);
end

if nargin > 4
    points                  = points + dstr;
end

if nargin > 3
    points                  = transformPoints(pose, points, p(5:end));
    
else
    points                  = transformPoints(pose, points);
end

if nargin > 3 && length(p) > 6
    [prj, uv, iz]           = persProject(K, points, p(1:4));
else
    [prj, uv, iz]           = persProject(K, points);
end