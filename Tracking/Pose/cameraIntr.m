function prj = cameraIntr(K, uv)
prj       = K*[uv; ones(1, size(uv,2))];
prj       = prj(1:2,:);