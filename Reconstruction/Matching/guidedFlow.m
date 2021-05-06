function [kpos, tracks] = guidedFlow(tracks, dViews, dTrack, Views, Images, frames, kf, mf, config)
%% Initialize
[M,N]               = size(Images{mf}.gryimage);

%% select points in matchframe 
mpose               = invertPoses(Views{mf}.pose);
kpose               = invertPoses(Views{kf}.pose);

smpos               = (projectPoints(frames.K, mpose, dTrack.Pt(1:3,tracks)))';
skpos               = (projectPoints(frames.K, kpose, dTrack.Pt(1:3,tracks)))';

mpos                = floor(smpos);
kpos                = floor(skpos);

bbxin               = logical(inBB(mpos, M, N) .* inBB(kpos, M, N));

tracks              = tracks(bbxin);
smpos               = smpos(bbxin,:);
skpos               = skpos(bbxin,:);
mpos                = mpos(bbxin,:);
kpos                = kpos(bbxin,:);

midx                = (mpos(:,1)-1)*M+mpos(:,2);
[~,ic]              = unique(midx);   
midx                = midx(ic);
tracks              = tracks(ic);
smpos               = smpos(ic,:);
skpos               = skpos(ic,:);

kidx                = (kpos(ic,1)-1)*M+kpos(ic,2);
[~,ic]              = unique(kidx);   
midx                = midx(ic);
tracks              = tracks(ic);
smpos               = smpos(ic,:);
skpos               = skpos(ic,:);
%% Search range
range               = [-2:2];
[~,L]               = computeF(Views, frames, smpos, kf, mf);
L                   = L';
costv               = zeros(length(tracks), length(range));
for j = 1:length(range)
% rkpos(:,1)          = range(j) + skpos(:,1);  
% rkpos(:,2)          = ((-L(:,3)-L(:,1).*rkpos(:,1))./L(:,2));

rkpos(:,2)          = range(j) + skpos(:,2);  
rkpos(:,1)          = ((-L(:,3)-L(:,2).*rkpos(:,2))./L(:,1));

%% Compute cost
[cost, valid]       = computeDenseCost(Images, mf, kf, smpos, rkpos, config);
costv(valid,j)      = cost;
end

%% Sub-pixel level
[cost,idx]          = min(costv, [], 2);
for i = 1:length(tracks)
skpos(i,1)          = range(idx(i)) + skpos(i,1);  
skpos(i,2)          = (-L(i,3)-L(i,1)*rkpos(i,1))/L(i,2);
skpos(i,:)         	= subpixelMVS(skpos(i,:), idx(i), costv(i,:), L(i,:));
end

inliers             = densecheckpoint(cost, smpos, skpos, Views, Images, frames, kf, mf, config);
tracks              = tracks(inliers);
kpos                = skpos(inliers,:);

%% Confidence map
% cmask               = zeros(M,N);
% cmask(midx(inliers))= cost(inliers);
% dViews{mf}.conf     = cmask;
% load MyColormaps.mat;
% figure(100);  imshow(imrotate(cmask,-config.dataset.rotate), [0 config.mdepth.threshold], 'colormap', jetMM);