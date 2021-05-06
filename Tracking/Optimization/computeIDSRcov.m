function dViews     = computeIDSRcov(dViews, Views, frames, kf, config)
valid               = dViews{kf}.valid;
Pt                  = dViews{kf}.pcl(:,valid);
obs                 = (dViews{kf}.pos(valid,:))';

cov                 = zeros(12, size(Pt,2));
points              = [Pt(1:3,:); ones(1, size(Pt,2))];
K                   = frames.K;
pose                = Views{kf}.pose;
ipose               = invertPoses(pose);
ipobs               = [obs; ones(1,size(obs,2))];   
ipobs               = inv(K)*ipobs;   

config.packing      = 1; 
ipoints             = ipose*points;

%% IDSR
idsrcn              = configureIDSR(points, ipoints, K, config, pose, ipobs);
% mu                  = sum(idsrcn.x.*idsrcn.pj,1).*idsrcn.pj + pose(:,4); %%%% DLT CASE
mu                  = points(1:3,:); 
pj                  = idsrcn.pj;
sigma               = idsrcn.sigma;
pj1                 = pj(1,:);
pj2                 = pj(2,:);
pj3                 = pj(3,:);

pj12                = pj1.*pj1;
pj22                = pj2.*pj2;
nv                  = (pj12+pj22);

Rnj                 = zeros(3,3,size(pj,2));
Rnj(1,1,:)          = (pj22+pj3.*pj12)./nv;
Rnj(1,2,:)          = (pj3-1).*pj1.*pj2./nv;
Rnj(1,3,:)          = -pj1;
Rnj(2,1,:)          = (pj3-1).*pj1.*pj2./nv;
Rnj(2,2,:)          = (pj12+pj3.*pj22)./nv;
Rnj(2,3,:)          = -pj2;
Rnj(3,1,:)          = pj1;
Rnj(3,2,:)          = pj2;
Rnj(3,3,:)          = pj3;

for j = 1:size(Pt,2)    
    Rj              = Rnj(:,:,j);
    SRnj            = sigma(:,j).*Rj;
    cj              = Rj'*SRnj;
    cov(:,j)        = [cj(:); cj*mu(:,j)];
end

dViews{kf}.cov(:,valid) = cov;
