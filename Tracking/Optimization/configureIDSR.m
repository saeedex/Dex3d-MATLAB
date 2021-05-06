function idsrcn = configureIDSR(point, ipoint, K, config, pose, ipobs)
%% Configure mean
pj                      = pose(:,1:3)*ipobs;
idsrcn.npj              = sqrt(sum(pj.^2,1));
idsrcn.pj               = pj./idsrcn.npj;
idsrcn.x                = point(1:3,:) - pose(:,4); %%%% DLT CASE

%% Configure covariance
config.opt.threshold    = 1;
lambda                  = (config.opt.threshold)^2;
const_sc                = 8*log(2);
fx2                     = K(1,1)^2;
fy2                     = K(2,2)^2;
z                       = ipoint(3,:);
z2                      = z.^2;

idsrcn.sx               = fx2*const_sc/lambda;
idsrcn.sy               = fy2*const_sc/lambda;
idsrcn.sz               = idsrcn.sx*10^-9;

idsrcn.sigma            = zeros(3,length(z));
idsrcn.sigma(1,:)       = (idsrcn.sx./z2);
idsrcn.sigma(2,:)       = (idsrcn.sy./z2);
idsrcn.sigma(3,:)       = (idsrcn.sz./z2);
