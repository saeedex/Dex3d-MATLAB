function valid = validatePoint(skpos, kimage, config)
[M,N]               = size(kimage);
inidx               = 1:size(skpos,1);
valid               = false(size(skpos,1),1);
kpos                = round(skpos(inidx,:)/config.sdepth.sparsity);
M                   = M/config.sdepth.sparsity;
N                   = N/config.sdepth.sparsity;
%% image bounding box
inidx               = inidx(inBB(kpos(inidx,:), M, N));   

%% Output
valid(inidx)        = true;
