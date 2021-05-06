function [dTrack, dViews, Images] = guidedDenseMatching(dTrack, dViews, Views, Images, frames, kf, mf, config)
%% initialize variables
load MyColormaps.mat;
threshold           = config.mdepth.threshold;
wrad                = config.mdepth.range;
nrange              = 2*wrad + 1;
[M,N]               = size(Images{mf}.gryimage);
tracks              = dViews{mf}.tracks;

% vis                 = dTrack.vis(tracks) >= min(max(dTrack.vis),3);
% tracks              = tracks(vis);

smpos               = dViews{mf}.pos;
mpos                = floor(smpos);
mdsc                = dTrack.dsc(tracks,:);
kdsc                = dViews{kf}.dsc;
patn                = size(mdsc,2);
cmask               = ones(M,N);
cost                = ones(length(tracks), 1);

smpos               = projectPoints(frames.K, invertPoses(Views{mf}.pose), dTrack.Pt(1:3,tracks));
smpos               = smpos';
%% project points 
ipose               = invertPoses(Views{kf}.pose);
skpos               = projectPoints(frames.K, ipose, dTrack.Pt(1:3,tracks));

skpos               = skpos';
kpos                = floor(skpos);
valid               = inBB(kpos, M, N);

if strcmp(config.mdepth.method,'DAISY') 
kidx                = (kpos(:,2)-1)*N+kpos(:,1);
else
kidx                = (kpos(:,1)-1)*M+kpos(:,2); 
end

if ~strcmp(config.mdepth.method,'NCC') 
residual            = abs(mdsc(valid,:) - kdsc(kidx(valid), :));
cost(valid)         = sum(residual,2);
else
mRL                 = mdsc(valid,:).*kdsc(kidx(valid), :);
mimgRL              = sum(mRL(:,1:end-2),2)/patn;
cost(valid)         = 1 - (mimgRL - mRL(:,end-1))./mRL(:,end);
end
midx                = (mpos(:,1)-1)*M+mpos(:,2);
inliers             = cost < threshold;
cmask(midx(inliers))= cost(inliers);
figure(100); imshow(imrotate(cmask,-config.dataset.rotate), [0 threshold], 'colormap', jetMM);
%% compute epipoles
if config.run.mdepth 
range               = meshgrid((-wrad:+wrad), 1:length(tracks));
[~,L]               = computeF(Views, frames, smpos, kf, mf);
% kxr                 = (range + kpos(:,1))';  
% kyr                 = floor((-L(3,:)-L(1,:).*kxr)./L(2,:));
kyr                 = (range + kpos(:,2))';  
kxr                 = floor((-L(3,:)-L(2,:).*kyr)./L(1,:));

%% matching
costv               = ones(length(tracks), nrange);
if strcmp(config.mdepth.method,'DAISY') 
pidx                = (kyr-1)*N+kxr; 
else
pidx                = (kxr-1)*M+kyr; 
end
valid               = pidx <= size(kdsc,1);
valid(pidx < 1)     = 0; 

for j = 1:nrange
kidx                = pidx(j,valid(j,:));
if ~strcmp(config.mdepth.method,'NCC') 
diff                = abs(mdsc(valid(j,:),:) - kdsc(kidx, :)); 
costv(valid(j,:),j) = sum(diff,2);  
else
mRL                 = mdsc(valid(j,:),:).*kdsc(kidx, :);
mimgRL              = sum(mRL(:,1:end-2),2)/patn;
costv(valid(j,:),j) = 1 - (mimgRL - mRL(:,end-1))./mRL(:,end);
end
end
[cost,idx]          = min(costv, [], 2);
inliers             = cost < threshold;

for i = 1:length(tracks)
kpos(i,:)           = [kxr(idx(i),i) kyr(idx(i),i)]; 
skpos(i,:)         	= subpixelMVS(kpos(i,:), idx(i), costv(i,:), L(:,i));
end
inliers          	= logical(inBB(skpos, M, N).*inliers);
cmask(midx(inliers))= cost(inliers);
end
%% Visualization
dViews{mf}.conf     = cmask;
dViews{kf}.tracks   = tracks(inliers);
dViews{kf}.pos      = skpos(inliers,:);
figure(100);  imshow(imrotate(cmask,-config.dataset.rotate), [0 threshold], 'colormap', jetMM);