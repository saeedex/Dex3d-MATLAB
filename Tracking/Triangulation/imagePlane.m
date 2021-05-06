function [uv, iz]   = imagePlane(points)
iz                  = 1./points(3,:);
u                   = points(1,:).*iz;
v                   = points(2,:).*iz;
uv                  = [u; v];