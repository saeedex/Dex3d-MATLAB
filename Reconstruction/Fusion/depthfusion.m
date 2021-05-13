function [pcl, map, Images] = depthfusion(dViews, SparseMap, Images, config)
Views                   = SparseMap.Views;
frames                  = SparseMap.frames;
pcl                     = [];
map                     = [];       
for j = 1:length(frames.regcams)
kf                      = frames.regcams(j);
dViews                  = pclfilter(dViews, Views, frames, kf, config);
Images                  = pcl2depth(dViews, Views, Images, frames, kf, config); 
[kpcl,kmap]             = pclmapping(dViews, Images, kf);
%% Merging
pcl                     = [pcl kpcl];
map                     = [map kmap];
end