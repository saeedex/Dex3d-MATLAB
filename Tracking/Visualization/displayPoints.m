function displayPoints(SparseMap, Images, frames, config, kf)
if ~config.display; return; end
%% Input
Views                       = SparseMap.Views;
if nargin < 5; kf           = frames.regcams(end); end
frames.regcams              = frames.regcams(1:kf);
visimg                      = Images{kf}.colimage;


%% Displaying Point Cloud 
if config.smatch.apply
visimg                      = visualizeObservedPoints(Views, visimg, kf);
Track                       = SparseMap.Track;
config.opt.method           = 'global';
BAConfig                    = configureBA(Track, Views, frames.regcams, config);
[BAConfig, config]          = configureLM(BAConfig, config);
BAVar                       = packVariables(Track, Views, frames, BAConfig); 
str                         = cat(2, Track(BAConfig.tracks).Str);
pres                        = BACalcResidual(BAConfig, BAVar, config);
inliers                     = pres < config.opt.threshold;
str                         = str(:,inliers);
[~,~,iz]                    = projectPoints(BAVar.K, invertPoses(Views{kf}.pose), str);
indepth                     = logical(iz > (1/config.dataset.maxz));
str                         = str(:,indepth);
str(1:3,:)                  = invertPoses(Views{1}.pose)*[str(1:3,:); ones(1, size(str,2))];
ptCloud                     = pointCloud(str(1:3,:)', 'Color', str(4:6,:)');
figure(2); pcshow(ptCloud); set(gca,'visible','off'); view(-config.dataset.rotate, -60);
hold on;

str                         = cat(2, Track(Views{kf}.tracks(:,1)).Str);
[~,~,iz]                    = projectPoints(BAVar.K, invertPoses(Views{kf}.pose), str);
indepth                     = logical(iz > (1/config.dataset.maxz));

else
%% Displaying AR Core Point Cloud
visimg                      = visualizeObservedPoints(SparseMap.Views, visimg, kf, SparseMap.Views{kf}.feat(1:2,:), 'red');
str                         = SparseMap.ARTrack.str';
[~,~,iz]                    = projectPoints(frames.K, invertPoses(Views{kf}.pose), str);
indepth                     = logical(iz > (1/config.dataset.maxz));
str                         = str(:,indepth);
ptCloud                     = pointCloud(str(1:3,:)', 'Color', str(4:6,:)');
figure(2); pcshow(ptCloud); set(gca,'visible','off');  view(-config.dataset.rotate, -60);
hold on;

x = size(visimg,2) - SparseMap.Views{kf}.feat(1,:);
y = SparseMap.Views{kf}.feat(2,:);
end
%% Displaying Depth and Observations
figure(1); imshow(imrotate(visimg,-config.dataset.rotate)); set(gca,'Visible','off'); 

%% DT
% x                           = size(visimg,2) - SparseMap.Views{kf}.feat(1,Views{kf}.tracks(indepth,2));
% y                           = SparseMap.Views{kf}.feat(2,Views{kf}.tracks(indepth,2));
% DT = delaunay(y,x);
% x1 = x(DT(:,1));
% x2 = x(DT(:,2));
% x3 = x(DT(:,3));
% 
% y1 = y(DT(:,1));
% y2 = y(DT(:,2));
% y3 = y(DT(:,3));
% 
% x12 = sqrt((x1-x2).^2 + (y1-y2).^2);
% x13 = sqrt((x1-x3).^2 + (y1-y3).^2);
% x23 = sqrt((x3-x2).^2 + (y3-y2).^2);
% threshold = 50;
% valid = logical((x12 < threshold).*(x13 < threshold).*(x23 < threshold));
% hold on; triplot(DT(valid,:),y,x);

