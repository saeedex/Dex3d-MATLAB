function depthmap = importARdepth(Images, frames, kf, config)
depth                               = load([frames.path frames.ardepth{kf}]);
depth                               = depth/10^3;
depth(depth > config.dataset.maxz)  = 0;
depthmap                            = zeros(160,120);
depth                               = reshape(depth,160,90);
depth                               = depth(:,end:-1:1);
depthmap(:,16:end-15)               = depth;
depthmap                            = imresize(depthmap,4/config.sdepth.sparsity, 'nearest');
% load MyColormaps.mat
% figure(1);  imshow(Images{kf}.colimage); title('Scene', 'Color', 'white');
% figure(2);  imshow(depthmap,[min(depthmap(depthmap~=0)) max(depthmap(depthmap~=0))], 'Colormap', jetMM);  
