function Hessian        = buildHessian(BAConfig, BAVar, config)
%% Unpacking variables
poses                   = BAVar.poses;
str                     = BAVar.str;
vis                     = BAVar.vis;
clength                 = BAConfig.clength;
plength                 = BAConfig.plength;
slength                 = BAConfig.slength;
varposes                = BAConfig.poses;
regcams                 = BAConfig.regcams;
indices                 = [1:size(str,2)]';
%% Building Hessian 
if ~strcmp(config.opt.solver, 'IDSRLBA2')
acc                     = initializeHessian(BAConfig);
for i = 1:length(regcams)
    valid               = vis(i,:) ~= 0;
    iindices            = indices(valid);
    point               = str(1:3,valid);    
    iobs                = str((i-1)*2+4:(i-1)*2+5,valid);
    [iprj, iuv, dscale] = projectPoints(BAVar.K, poses(:,:,i), point);
    ir                  = iprj - iobs;
    varidx              = find(regcams(i) == varposes);
    
    if ~isempty(varidx) 
    pidx                = (varidx-1)*plength+1+clength:varidx*plength+clength;
    jac                 = estimateJacobian(BAVar.K, iuv, dscale, poses(:,:,i), config);    
    acc                 = accumPhessian(acc, jac, ir, valid, pidx, clength);
    acc                 = accumXhessian(acc, jac, ir, iindices, valid, config);
    acc                 = accumcrossXhessian(acc, jac, iindices, valid, pidx, clength, config);
    end
end
Hessian                 = constructHessian(acc, config);

if strcmp(config.opt.solver, 'IDSRLBA1')
config.packing          = 1;
BAVar                   = updatePoints(BAConfig, BAVar, config);
config.packing          = 0;
BAVar                   = updatePoints(BAConfig, BAVar, config);
x                       = zeros(slength,1);
for j = 1:length(indices)
    sidx                = [(j-1)*3+1:j*3];
    x(sidx)             = BAVar.str(1:3,j) - str(1:3,j);
end
Hessian.x               = x;
end
else
%%----------------------- PROPOSED
HppAcc                  = zeros(plength*length(varposes));
bpAcc                   = zeros(plength*length(varposes),1);
Jmun                    = BAVar.Jmun;

for varidx = 1:length(varposes)
    cidx                = [(varidx-1)*plength+1:varidx*plength];     
    i                   = varposes(varidx);
    pose                = poses(:,:,i);
    valid               = vis(i,:) ~= 0;
    iindices            = indices(valid);
    point               = str(:,valid);
    iobs                = str((i-1)*2+4:(i-1)*2+5,valid);        
    [iprj, iuv, iz]     = projectPoints(BAVar.K, pose, point);   
    ir                  = iprj - iobs;
    obsN                = size(ir,2);
    iJp                 = estimateJacobianIDSR(BAVar.K, iuv, iz, pose, Jmun, iindices, cidx);
    for j = 1:obsN              
        jiJp            = iJp((j-1)*2+1:j*2,:);            
        jiJpt           = jiJp';
        HppAcc          = HppAcc + jiJpt*jiJp;
        bpAcc           = bpAcc - jiJpt*ir(:,j);
    end
end
%% Output
Hessian.Hpp             = HppAcc;
Hessian.bp              = bpAcc;                                                                                                                                      
Hessian.b               = Hessian.bp;
end