function dViews = costGeometric(dViews, Views, frames, kf)
%% Global residual
kvalid                              = dViews{kf}.map(:,1) ~= 0;
kdidx                               = dViews{kf}.map(kvalid,2);
kpcl                                = dViews{kf}.pcl(:,kdidx);
vis                                 = dViews{kf}.vis;
res                                 = dViews{kf}.res;
kres                                = onecostGeometric(kpcl, dViews, Views, frames, kf, kdidx);

res(kdidx)                          = res(kdidx) + kres;
mf                                  = kf;
mdidx                               = kdidx;
for j = 1:max(vis)-1
mdidx                               = dViews{mf}.map(mdidx,1);
mvalid                              = mdidx~=0;
mdidx                               = mdidx(mvalid);
kdidx                               = kdidx(mvalid);
kpcl                                = kpcl(:,mvalid);
mf                                  = kf - j; 
mres                                = onecostGeometric(kpcl, dViews, Views, frames, mf, mdidx);
res(kdidx)                          = res(kdidx) + mres;
end

%% Share
kdidx                               = dViews{kf}.map(kvalid,2);
res                                 = sqrt(res(kdidx) ./vis(kdidx) );
dViews{kf}.res(kdidx)               = res;
mf                                  = kf;
mdidx                               = kdidx;
for j = 1:max(dViews{kf}.vis)-1
mdidx                               = dViews{mf}.map(mdidx,1);
mvalid                              = mdidx~=0;
mdidx                               = mdidx(mvalid);
kdidx                               = kdidx(mvalid);
res                                 = res(mvalid);
mf                                  = kf - j; 
dViews{mf}.res(mdidx)               = res;
end