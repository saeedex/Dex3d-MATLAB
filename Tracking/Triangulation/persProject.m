function [prj, uv, iz]  = persProject(K, points, dintr)
if nargin > 2
K           = K + twist2intr(dintr);
end
[uv, iz]    = imagePlane(points);
prj         = cameraIntr(K, uv);
