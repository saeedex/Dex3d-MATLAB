function [pos, idx] = getdepthobs(depth, config)
[M,N]        = size(depth);
[X, Y]       = meshgrid(double(1:N), double(1:M));
pos(:,1)     = X(:);
pos(:,2)     = Y(:);
idx          = (pos(:,1)-1)*M+pos(:,2);
pos          = config.sdepth.sparsity*pos;
