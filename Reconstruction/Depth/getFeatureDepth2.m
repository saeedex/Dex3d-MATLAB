function [depth, vpnt, depthmap] = getFeatureDepth2(depthmap, pos, config)
size(depthmap)
[M,N]                   = size(depthmap);
vpnt                    = false(size(pos,1),1);
vind                    = 1:length(vpnt);
pos                     = round(pos/config.sdepth.sparsity);
vind                    = vind(inBB(pos, M, N));  
pidx                    = (pos(vind,1)-1)*M+pos(vind,2);
depth                   = depthmap(pidx);

vind                    = vind(depth~=0);
vpnt(vind)              = true;
depth                   = depth(depth~=0);

depthmap(pidx)          = 0;