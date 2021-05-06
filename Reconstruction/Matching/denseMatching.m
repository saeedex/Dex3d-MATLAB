function dViews = denseMatching(dViews, Views, Images, frames, kf, mf, config)
%% Read previous pcl
mimage              = Images{mf}.gryimage;
kimage              = Images{kf}.gryimage;
valid               = dViews{mf}.valid;
pcl                 = dViews{mf}.pcl(1:3,valid);
smpos               = dViews{mf}.pos(valid,:);
mdidx               = dViews{mf}.idx(valid);

%% Project points
skpos               = (projectPoints(frames.K, invertPoses(Views{kf}.pose), pcl))';
valid               = validatePoint(skpos, kimage, config); 
smpos               = smpos(valid,:);
skpos               = skpos(valid,:);
mdidx               = mdidx(valid);

%% Optical flow
[skpos, valid, res] = denseFlow(frames, kf, mimage, kimage, config, smpos, skpos);
smpos               = smpos(valid,:);
skpos               = skpos(valid,:);
mdidx               = mdidx(valid);
res                 = res(valid);

%% Validate 
valid               = validatePoint(skpos, kimage, config);
smpos               = smpos(valid,:);
skpos               = skpos(valid,:);
mdidx               = mdidx(valid);
res                 = res(valid);

%% Compute photometric residual
if config.mdepth.filter.photresh ~= 0
cost                = costPhotometric(mimage, kimage, smpos, skpos, config);
valid               = cost < config.mdepth.filter.photresh;
smpos               = smpos(valid,:);
skpos               = skpos(valid,:);
mdidx               = mdidx(valid);
res                 = res(valid);
end
%% Save current pcl
dkpos               = round(skpos/config.sdepth.sparsity);
kdidx               = (dkpos(:,1)-1)*size(Images{kf}.depth,1)+dkpos(:,2);
map                 = [mdidx kdidx];
valid               = Images{kf}.depth(kdidx)~=0;
smpos               = smpos(valid,:);
skpos               = skpos(valid,:);
map                 = map(valid,:);
res                 = res(valid);
kdidx               = kdidx(valid);
dViews{kf}.pos(map(:,2),:)  = skpos; 
dViews{kf}.map(map(:,2),:)  = map;

%% Visualization
% mpos                    = round(smpos);
% midx                    = (mpos(:,1)-1)*size(mimage,1)+mpos(:,2);
% flowmap                 = zeros(size(mimage));
% flowmap(midx)           = res;
% flowmap                 = flowmap/max(flowmap(:));
% load MyColormaps;
% figure(9); imshow(imrotate(flowmap,-config.dataset.rotate),  'Colormap', jetMM); colorbar
% 
% kpos                    = round(skpos);
% kidx                    = (kpos(:,1)-1)*size(kimage,1)+kpos(:,2);
% flowmap                 = zeros(size(kimage));
% flowmap(kidx)           = res;
% flowmap                 = flowmap/max(flowmap(:));
% load MyColormaps;
% figure(10); imshow(imrotate(flowmap,-config.dataset.rotate),  'Colormap', jetMM); colorbar
% pause
