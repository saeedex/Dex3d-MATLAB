function [ptCloud, Images] = depthfusion(dViews, Views, Images, frames, config)
vtresh                  = config.mdepth.filter.minvis;
geotresh                = config.mdepth.filter.geotresh;
maxz                    = config.dataset.maxz;

for j = 1:length(frames.regcams)
kf                      = frames.regcams(j);
[Images, indepth]       = pcl2depth(dViews, Views, Images, frames, kf, config); 

valid                   = dViews{kf}.valid;
vis                     = dViews{kf}.vis';
mres                    = dViews{kf}.res;
kpcl                    = dViews{kf}.pcl;

valid(vis < vtresh)     = false;    
if geotresh ~= 0
valid(isnan(mres))      = false;
valid(mres>geotresh)    = false;                                            
end

kpose                   = invertPoses(Views{kf}.pose);
[~,~,iz]                = projectPoints(frames.K, kpose, kpcl(1:3,:));
indepth                 = logical((iz > 1/config.dataset.maxz).*(iz > 0));
valid(~indepth)         = false;

%% Merging
kptCloud                = pointCloud(kpcl(1:3,valid)', 'Color', kpcl(4:6,valid)');

if j == 1
ptCloud                 = pointCloud(kpcl(1:3,valid)', 'Color', kpcl(4:6,valid)');
else
ptCloud                 = pcmerge(ptCloud, kptCloud, 0.001);
end
end
figure(2); pcshow(ptCloud);
