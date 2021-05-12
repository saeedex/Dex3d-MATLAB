function dViews   = refinepoints(dViews, Views, frames, kf, mf, config)
valid                               = dViews{kf}.map(:,1) ~= 0;
mdidx                               = dViews{kf}.map(valid,1);
kdidx                               = dViews{kf}.map(valid,2);
mpcl                                = dViews{mf}.pcl(:,mdidx);
kpcl                                = dViews{kf}.pcl(:,kdidx);
mcov                                = dViews{mf}.cov(:,mdidx);
kcov                                = dViews{kf}.cov(:,kdidx);
cpcl                                = mpcl;
ccov                                = mcov;   

cpcl(4:6,:)                         = (kpcl(4:6,:) + cpcl(4:6,:))/2;
%% Refinement
if config.mdepth.refine.apply
if strcmp(config.mdepth.refine.method,'DIDSR')
%%----- DIDSR
[cpcl, ccov]                        = refineDIDSR(ccov, kcov, cpcl);
else
%%----- DLT
mpose                               = invertPoses(Views{kf-1}.pose);
kpose                               = invertPoses(Views{kf}.pose);
mproj                               = frames.K*mpose;
kproj                               = frames.K*kpose;
mpos                                = dViews{mf}.pos(mdidx,:);
kpos                                = dViews{kf}.pos(kdidx,:);
Str                                 = cv.triangulatePoints(mproj, kproj, mpos', kpos');
Str                                 = Str./Str(4,:);
cpcl(1:3,:)                         = Str(1:3,:);
end
end
%% Filtering
geotresh                            = config.mdepth.filter.geotresh;
kres                                = onecostGeometric(cpcl, dViews, Views, frames, kf, kdidx);
mres                                = onecostGeometric(cpcl, dViews, Views, frames, mf, mdidx);
res                                 = sqrt(0.5*(kres + mres));
inliers                             = true(size(res));
inliers(isnan(kres))                = false;
if geotresh ~= 0; inliers(res > geotresh) = false; end
mdidx                               = mdidx(inliers);
kdidx                               = kdidx(inliers);
cpcl                                = cpcl(:,inliers);
ccov                                = ccov(:,inliers);

%% Share pcl
dViews{kf}.pcl(:,kdidx)             = cpcl;
dViews{kf}.cov(:,kdidx)             = ccov;
dViews{kf}.vis(kdidx)               = dViews{mf}.vis(mdidx) + 1;
mf                                  = kf;
mdidx                               = kdidx;
for j = 1:max(dViews{kf}.vis)-1
mdidx                               = dViews{mf}.map(mdidx,1);
mvalid                              = mdidx~=0;
mdidx                               = mdidx(mvalid);
kdidx                               = kdidx(mvalid);
cpcl                                = cpcl(:,mvalid);
ccov                                = ccov(:,mvalid);
mf                                  = kf - j; 
dViews{mf}.pcl(:,mdidx)             = cpcl;
dViews{mf}.cov(:,mdidx)             = ccov;
dViews{mf}.vis(mdidx)               = dViews{mf}.vis(mdidx) + 1;
end