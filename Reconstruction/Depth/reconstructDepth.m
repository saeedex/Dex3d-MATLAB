function Images = reconstructDepth(Images, dViews, SparseMap, kf, config)
Views                   = SparseMap.Views;
frames                  = SparseMap.frames;
kpcl                    = dViews{kf}.pcl;
kdidx                   = dViews{kf}.idx;

% kpcl                    = dTrack.pcl; 
if ~isempty(kpcl)
depthmap                = zeros(size(Images{kf}.depth));

mpose                   = invertPoses(Views{kf}.pose);
[skpos,~,iz]            = projectPoints(frames.K, mpose, kpcl(1:3,:));
z                       = 1./iz;

% dkpos               = round(skpos/config.sdepth.sparsity);
% kdidx               = (dkpos(1,:)-1)*size(Images{kf}.depth,1)+dkpos(2,:);
% valid               = logical((kdidx >= 1).*(kdidx <= size(Images{kf}.depth,1)*size(Images{kf}.depth,2)).*(z < config.dataset.maxz).*(z > 0.1));
% z                   = z(valid);
% kdidx               = kdidx(valid);

for i = 1:length(kdidx)
if depthmap(kdidx(i))==0
depthmap(kdidx(i)) = z(i);
else
if z(i) < depthmap(kdidx(i))
depthmap(kdidx(i)) = z(i);
end
end
end
%% Visualization
load MyColormaps;
figure(1);  imshow(Images{kf}.colimage); title('Scene', 'Color', 'white');
figure(3);  imshow(depthmap,[0 max(depthmap(depthmap~=0))], 'Colormap', jetMM);  title('Stacy Depth', 'Color', 'white'); 
pause
end