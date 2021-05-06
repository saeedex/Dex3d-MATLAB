function res = onecostGeometric(pcl, dViews, Views, frames, kf, kdidx)
%% Geometric cost
kpose                     	= invertPoses(Views{kf}.pose);
kpos                        = dViews{kf}.pos(kdidx,:)';
rkpos                       = projectPoints(frames.K, kpose, pcl); 
res                     	= sum((kpos - rkpos).^2,1);