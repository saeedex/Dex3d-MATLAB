function dViews = pclfilter(dViews, Views, frames, kf, config)
minvis                  = config.mdepth.filter.minvis;
maxvis                  = config.mdepth.filter.maxvis;
geotresh                = config.mdepth.filter.geotresh;

valid                   = dViews{kf}.valid;
vis                     = dViews{kf}.vis';
mres                    = dViews{kf}.res;
kpcl                    = dViews{kf}.pcl;

%----- Visibility check
valid(vis < minvis)     = false; 
valid(vis > maxvis)     = false; 

%----- Geometry check
if geotresh ~= 0
valid(isnan(mres))      = false;
valid(mres>geotresh)    = false;                                            
end
%----- Depth range
kpose                   = invertPoses(Views{kf}.pose);
[~,~,iz]                = projectPoints(frames.K, kpose, kpcl(1:3,:));
indepth                 = logical((iz > 1/config.dataset.maxz).*(iz > 0));
valid(~indepth)         = false;
dViews{kf}.valid        = valid;