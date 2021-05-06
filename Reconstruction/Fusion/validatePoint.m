function valid = validatePoint(skpos, kimage, config)
[M,N]               = size(kimage);
inidx               = 1:size(skpos,1);
valid               = false(size(skpos,1),1);
kpos                = round(skpos(inidx,:)/config.sdepth.sparsity);
M                   = M/config.sdepth.sparsity;
N                   = N/config.sdepth.sparsity;
%% image bounding box
inidx               = inidx(inBB(kpos(inidx,:), M, N));   

%% duplicates
kidx                = (kpos(inidx,1)-1)*M+kpos(inidx,2);
[~,ic]              = unique(kidx);      
inidx               = inidx(ic);
%% Output
valid(inidx)        = true;
