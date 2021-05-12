function [ptCloud, Images] = depthfusion(dViews, SparseMap, Images, config)
Views                   = SparseMap.Views;
frames                  = SparseMap.frames;
pcl                     = [];
for j = 1:length(frames.regcams) 
kf                      = frames.regcams(j);
dViews                  = pclfilter(dViews, Views, frames, kf, config);
Images                  = pcl2depth(dViews, Views, Images, frames, kf, config); 
valid                   = dViews{kf}.valid;
map                     = dViews{kf}.map(:,1);
valid(map~=0)           = false;
kpcl                    = dViews{kf}.pcl(:,valid);
vis                     = dViews{kf}.vis(valid);
%% Mapping info
if ~isempty(kpcl)
kdidx                 	= dViews{kf}.map(valid,2);
mf                    	= kf;
mdidx                   = kdidx;
for jj = 1:max(vis)-1
mpos                    = dViews{mf}.pos(mdidx,:);
mdidx                  	= dViews{mf}.map(mdidx,1);
mvalid                 	= mdidx~=0;
mdidx                 	= mdidx(mvalid);
kdidx                   = kdidx(mvalid);
mf                      = kf + jj; 
end
%% Merging
pcl                     = [pcl kpcl];
end
% if j == 1
% ptCloud                 = pointCloud(kpcl(1:3,:)', 'Normal', kpcl(4:6,:)', 'Color', kpcl(7:9,:)');
% else
% kptCloud                = pointCloud(kpcl(1:3,:)', 'Normal', kpcl(4:6,:)', 'Color', kpcl(7:9,:)');
% ptCloud                 = pcmerge(ptCloud, kptCloud, 0.001);
% end
end
ptCloud                 = pointCloud(pcl(1:3,:)', 'Normal', pcl(4:6,:)', 'Color', pcl(7:9,:)');
figure(2); pcshow(ptCloud);
ptCloud
