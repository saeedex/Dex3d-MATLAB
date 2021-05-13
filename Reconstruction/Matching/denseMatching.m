function dViews = denseMatching(dViews, Views, Images, frames, kf, mf, config)
%% Read previous pcl
mimage              = Images{mf}.gryimage;
kimage              = Images{kf}.gryimage;
valid               = dViews{mf}.valid;
pcl                 = dViews{mf}.pcl(1:3,valid);
smpos               = dViews{mf}.pos(valid,:);
mdidx               = dViews{mf}.map(valid,2);

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

dkpos               = round(skpos/config.sdepth.sparsity);
kdidx               = (dkpos(:,1)-1)*size(Images{kf}.depth,1)+dkpos(:,2);
valid               = Images{kf}.depth(kdidx)~=0;
smpos               = smpos(valid,:);
skpos               = skpos(valid,:);
res                 = res(valid);
mdidx               = mdidx(valid);
kdidx               = kdidx(valid);
%% Compute photometric residual
cost                = costPhotometric(mimage, kimage, smpos, skpos, config);
if config.mdepth.filter.photresh ~= 0
valid               = cost < config.mdepth.filter.photresh;
smpos               = smpos(valid,:);
skpos               = skpos(valid,:);
mdidx               = mdidx(valid);
kdidx               = kdidx(valid);
res                 = res(valid);
cost                = cost(valid);
end
%% Save current pcl
cmap                = zeros(size(Images{kf}.depth));
imap                = zeros(size(Images{kf}.depth));
valid               = true(size(kdidx));
for i = 1:length(valid)
if cmap(kdidx(i)) == 0
cmap(kdidx(i))      = cost(i);
imap(kdidx(i))      = i;
elseif cmap(kdidx(i)) > cost(i)
cmap(kdidx(i))      = cost(i);
valid(imap(kdidx(i)))=false;
imap(kdidx(i))      = i;
else
valid(i)            = false;
end
end
mdidx               = mdidx(valid);
kdidx               = kdidx(valid);
smpos               = smpos(valid,:);
skpos               = skpos(valid,:);
res                 = res(valid);

dViews{kf}.pos(kdidx,:)  = skpos; 
dViews{kf}.map(kdidx,1)  = mdidx;
dViews{mf}.map(mdidx,3)  = kdidx;

%% Visualization
% mflow             	= zeros(size(Images{mf}.depth));
% kflow             	= zeros(size(Images{kf}.depth));
% mflow(mdidx)      	= res;
% kflow(kdidx)       	= res;
% load MyColormaps;
% mflow                   = mflow/max(mflow(:));
% kflow                   = kflow/max(kflow(:));
% figure(9); imshow(imrotate(mflow,-config.dataset.rotate),  'Colormap', jetMM); colorbar
% figure(10); imshow(imrotate(kflow,-config.dataset.rotate),  'Colormap', jetMM); colorbar
% pause

