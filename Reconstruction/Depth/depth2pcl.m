function dViews = depth2pcl(dViews, Views, Images, frames, kf, config)
%% Get depth of image coordinates
skpos                   = dViews{kf}.pos;
kdidx                   = dViews{kf}.map(:,2);
depth                   = Images{kf}.depth(kdidx);
dViews{kf}.valid        = depth~=0;

dkpos                   = round(skpos/config.sdepth.sparsity);
dkposx                  = dkpos;
dkposx(:,1)             = dkposx(:,1) - 1; 
dkposx(dkposx(:,1)<1,1) = 1;
kdidxx                  = (dkposx(:,1)-1)*size(Images{kf}.depth,1)+dkposx(:,2);
depthx                  = Images{kf}.depth(kdidxx);
skposx                  = dkposx*config.sdepth.sparsity;
strx                    = [skposx(:,1).*depthx skposx(:,2).*depthx depthx];

dkposy                  = dkpos;
dkposy(:,2)             = dkposy(:,2) - 1; 
dkposy(dkposy(:,2)<1,2) = 1;
kdidxy                  = (dkposy(:,1)-1)*size(Images{kf}.depth,1)+dkposy(:,2);
depthy                  = Images{kf}.depth(kdidxy);
skposy                  = dkposy*config.sdepth.sparsity;
stry                    = [skposy(:,1).*depthy skposy(:,2).*depthy depthy];

%% Project dense point cloud
str                     = [skpos(:,1).*depth skpos(:,2).*depth depth];

dx                      = inv(frames.K)*(strx - str)';
dy                      = inv(frames.K)*(stry - str)';
d                       = cross(dx,-dy);
mag                     = sqrt(sum(d.^2,1));
n                       = d./mag;

str                     = inv(frames.K)*str';
n                       = Views{kf}.pose(:,1:3)*n;
str                     = Views{kf}.pose*[str; ones(1, size(str, 2))];
%% Get color and descriptors 
colimage                = double(Images{kf}.colimage)/255;
R                       = colimage(:,:,1);
G                       = colimage(:,:,2);
B                       = colimage(:,:,3);
ipos                    = floor(skpos);
pidx                    = (ipos(:,1)-1)*size(Images{kf}.gryimage,1)+ipos(:,2);
col                     = [R(pidx) G(pidx) B(pidx)]';

%% Convert to pcl format
dViews{kf}.pcl          = [str; n; col];
% ptCloud                 = pointCloud(dViews{kf}.pcl(1:3,dViews{kf}.valid)', 'Normal', dViews{kf}.pcl(4:6,dViews{kf}.valid)', 'Color', dViews{kf}.pcl(7:9,dViews{kf}.valid)');
% pcshow(ptCloud); set(gca,'visible','off'); view(0, 180); 
% pcwrite(ptCloud,'test');
% pause