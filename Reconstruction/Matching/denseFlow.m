function [skpos, inliers, res] = denseFlow(frames, kf, mimage, kimage, config, smpos, skpos)
if ~config.mdepth.flow.apply; inliers = true(1, size(smpos,1)); return; end
if nargin < 7; skpos = smpos; end
%%---- Method 1 - Classical
if strcmp(config.mdepth.flow.method,'classical')
winsize             = config.mdepth.flow.winsize;
[kpt, flag]         = cv.calcOpticalFlowPyrLK(mimage, kimage, smpos, 'InitialFlow', skpos, 'WinSize', [winsize,winsize], 'MaxLevel', 5, 'Criteria', struct('type','Count+EPS', 'maxCount', 15, 'epsilon',0.01));
skpos               = cat(1, kpt{1:length(kpt)});

% flow                = cv.calcOpticalFlowFarneback(mimage, kimage);
% flow                = cv.calcOpticalFlowSF(mimage, kimage);
% flow                = cv.calcOpticalFlowSparseToDense(mimage, kimage);
% [flowv, valid]      = getFlow(flow, mimage, smpos);
% skpos(valid,:)      = smpos(valid,:) + flowv;
else
%%---- Method 2 - DeepFLOW
% flow                = importDeepFlow(kimage, frames, kf, config);
flow                = cv.calcOpticalFlowDF(mimage, kimage);
% [flowv, valid]      = getFlow(flow, mimage, smpos);
% skpos(valid,:)      = smpos(valid,:) + flowv;

Vx                  = flow(:,:,1);
Vy                  = flow(:,:,2);
mpos                = round(smpos);
midx                = (mpos(:,1)-1)*size(mimage,1)+mpos(:,2);
skpos(:,1)          = smpos(:,1) + Vx(midx); 
skpos(:,2)          = smpos(:,2) + Vy(midx);
end
res              	= sqrt(sum((smpos - skpos).^2,2));
inliers             = true(size(res));

%% Invalid flow
minf                = config.mdepth.flow.minsearch;
maxf                = config.mdepth.flow.maxsearch;
if config.mdepth.flow.maxsearch ~= 0
inliers(res < minf) = false;        
end
if config.mdepth.flow.maxsearch ~= 0
inliers(res > maxf) = false;
end

%% Visualization
% load MyColormaps;
% flowmap                 = sqrt(flow(:,:,1).^2 + flow(:,:,2).^2);
% flowmap                 = flowmap/max(flowmap(:));
% figure(8); imshow(imrotate(flowmap,-config.dataset.rotate),  'Colormap', jetMM); colorbar
% pause
