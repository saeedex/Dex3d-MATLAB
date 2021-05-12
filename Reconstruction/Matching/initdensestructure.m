function dView    = initdensestructure(Images, config)
%% Views structure
depth                       = Images{1}.depth;
pclength                    = numel(depth);
dView.pcl                   = zeros(6,pclength);
dView.cov                   = zeros(12,pclength);
[dView.pos, idx]            = getdepthobs(depth, config);
dView.valid                 = false(1, pclength);
dView.res                   = zeros(1,pclength);
dView.vis                   = ones(1, pclength);
dView.map                   = [zeros(pclength,1) idx];