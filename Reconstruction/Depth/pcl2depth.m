function Images = pcl2depth(dViews, Views, Images, frames, kf, config)
valid                   = dViews{kf}.valid;
kpcl                    = dViews{kf}.pcl(:,valid);
idx                     = dViews{kf}.map(valid,2);
kpose                   = invertPoses(Views{kf}.pose);
[~,~,iz]                = projectPoints(frames.K, kpose, kpcl(1:3,:));
z                       = 1./iz;
depthmap                = zeros(size(Images{kf}.depth));

for i = 1:length(idx)
if depthmap(idx(i))==0
depthmap(idx(i))        = z(i);
else
if z(i) < depthmap(kdidx(i))
depthmap(idx(i))        = z(i);
end
end
end
Images{kf}.mdepth       = depthmap;

%% Visualization
% figure(1); imshow(imrotate(Images{kf}.colimage,-config.dataset.rotate));
% figure(3); viewdepth(depthmap, config);