function [Images, indepth] = pcl2depth(dViews, Views, Images, frames, kf, config)
vtresh                  = config.mdepth.filter.minvis;
vis                     = dViews{kf}.vis';
valid                   = vis >= vtresh;
kpcl                    = dViews{kf}.pcl(:,valid);
idx                     = dViews{kf}.idx(valid);
kpose                   = invertPoses(Views{kf}.pose);
[~,~,iz]                = projectPoints(frames.K, kpose, kpcl(1:3,:));
indepth                 = logical((iz > 1/config.dataset.maxz).*(iz > 0));
idx                     = idx(indepth);
z                       = 1./iz(indepth);
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
figure(1); imshow(imrotate(Images{kf}.colimage,-config.dataset.rotate));
figure(3); viewdepth(depthmap, config);