function [Images,frames] = depthrescale2(Images, Track, Views, frames, config)
if ~config.sdepth.rescale; return; end
config.opt.method           = 'global';
frames.dscale               = 1;
BAConfig                    = configureBA(Track, Views, frames.regcams, config);
[BAConfig, config]          = configureLM(BAConfig, config);
BAVar                       = packVariables(Track, Views, frames, BAConfig); 
pres                        = BACalcResidual(BAConfig, BAVar, config);
inliers                     = pres < config.opt.threshold;
pres                        = pres(inliers);
BAConfig.tracks             = BAConfig.tracks(inliers);
BAVar                       = packVariables(Track, Views, frames, BAConfig); 
[BAConfig, config]          = configureLM(BAConfig, config);

%% Select inliers
indices                     = [1:size(BAVar.str,2)]';
pres                        = zeros(size(indices))'; 
visible                     = pres;
A                           = [];
for i = 1:length(BAConfig.regcams)
    pose                    = BAVar.poses(:,:,i);
    valid                   = BAVar.vis(i,:) ~= 0;
    iindices                = indices(valid);
    points                  = BAVar.str(1:3,valid);
    iobs                    = BAVar.str((i-1)*2+4:(i-1)*2+5,valid);
    [iprj,~,iz]             = projectPoints(BAVar.K, pose, points);
    indepth                 = logical(iz > (1/config.dataset.maxz));
    iprj                    = iprj(:,indepth);
    iz                      = iz(indepth);
    depthmap                = double(Images{BAConfig.regcams(i)}.depth);
    [depth,vpnt]            = getFeatureDepth2(depthmap, iprj', config);
    idepth                  = (1./depth)';
    iz                      = iz(vpnt);
    A                       = [A [idepth; iz]];
end

ratio                       = A(2,:)./A(1,:);
frames.dscale               = median(ratio);
for i = 1:length(BAConfig.regcams)
mf                          = BAConfig.regcams(i);
Images{mf}.depth            = Images{mf}.depth/frames.dscale;
end
frames.dscale               = 1;
