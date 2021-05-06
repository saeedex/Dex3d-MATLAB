function SparseMap = insertARCorepoints(SparseMap, Images, frames, kf, config)
if config.smatch.apply; return; end
%% Get structure
ARdata                          = importdata([frames.path frames.arpoints{kf}]);
kstr                            = ARdata(:,1:3);
kidx                            = ARdata(:,5);

%% Project to get observations
pose                            = invertPoses(SparseMap.Views{kf}.pose);
[kpos,~,iz]                     = projectPoints(frames.K, pose, kstr');
indepth                         = logical(iz > (1/config.dataset.maxz));
kpos                            = kpos(:,indepth);
kstr                            = kstr(indepth,:);
kidx                            = kidx(indepth);
%% Check if common or new
[~,ckidx, ctracks]              = intersect(kidx,SparseMap.ARTrack.idx);
nidx                            = true(size(kidx));
nidx(ckidx)                     = false;
tidx                            = true(size(SparseMap.ARTrack.idx));
tidx(ctracks)                   = false;

ckpos                           = kpos(:,~nidx);
SparseMap.Views{kf}.feat        = ckpos;
SparseMap.Views{kf}.tracks      = SparseMap.ARTrack.idx(~tidx);

%% Get color for new 
nstr                            = kstr(nidx,:)';
colimage                        = double(Images{kf}.colimage)/255;
nkpos                           = kpos(:,nidx);
nstr                            = getSparseColor(nstr, colimage, nkpos);
nstr                            = nstr';
SparseMap.ARTrack.str           = [SparseMap.ARTrack.str; nstr];
SparseMap.ARTrack.idx           = [SparseMap.ARTrack.idx; kidx(nidx)];
SparseMap.Views{kf}.feat        = [SparseMap.Views{kf}.feat nkpos];
SparseMap.Views{kf}.tracks      = [SparseMap.Views{kf}.tracks; SparseMap.ARTrack.idx(tidx)];

