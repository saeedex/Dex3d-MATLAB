function displayPoses(SparseMap, frames, config, kf)
if ~config.display; return; end
%% Input
Views                       = SparseMap.Views;
if nargin < 4; kf           = frames.regcams(end); end
frames.regcams              = frames.regcams(1:kf);
sz                          = frames.K(1,1)*config.camera.alpha*config.camera.pixel_scale;
figure(2); hold on;
for i = 1:length(frames.regcams)-1
pose                        = Views{frames.regcams(i)}.pose;
pose                        = concatenateRts(invertPoses(Views{1}.pose), pose);
rigp                        = rigid3d(pose(:,1:3)', pose(:,4)');
plotCamera('AbsolutePose',rigp, 'Size', sz, 'Color', 'cyan', 'Opacity', 0.4);  
end
pose                        = Views{frames.regcams(end)}.pose;
pose                        = concatenateRts(invertPoses(Views{1}.pose), pose);
rigp                        = rigid3d(pose(:,1:3)', pose(:,4)');
plotCamera('AbsolutePose',rigp, 'Size', sz, 'Color', 'red', 'Opacity', 0);  
hold off;
figure(2); hold on; show(SparseMap.poseGraph);
drawnow;
