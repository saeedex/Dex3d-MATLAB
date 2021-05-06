function BAVar = updatePoints(BAConfig, BAVar, config)
%% Unpacking variables
iposes                  = BAVar.poses;
str                     = BAVar.str;
vis                     = BAVar.vis;
cov                     = BAVar.cov;

plength                 = BAConfig.plength;
regcams                 = BAConfig.regcams;

indices                 = [1:size(str,2)]';
midx                    = 1;
cidx                    = [2:4];
orstr                   = str;


if config.packing
varposes                = BAConfig.fixposes;
else
varposes                = BAConfig.poses;
end

if strcmp(config.opt.scheme,'interleaved') %strcmp(config.opt.solver, 'IDSR')
    varposes            = [BAConfig.fixposes BAConfig.poses];
end

Jcov                    = zeros(3*length(indices),4*plength*length(varposes));
Jmun                    = zeros(3*length(indices),plength*length(varposes));
poses                   = invertPoses(iposes);
%% Update points
for varidx = 1:length(varposes)
    i                   = find(regcams == varposes(varidx));
    pose                = poses(:,:,i);
    ipose               = iposes(:,:,i);
    iK                  = inv(BAVar.K);
    valid               = vis(i,:) ~= 0;
    iindices            = indices(valid);
    point               = orstr(1:3,valid);
    iobs                = orstr((i-1)*2+4:(i-1)*2+5,valid);
    ipobs               = [iobs; ones(1,size(iobs,2))];
    ipobs               = iK*ipobs; 
    
    point               = [point; ones(1,size(point,2))];
    ipoint              = ipose*point;
    idsrcn              = configureIDSR(point, ipoint, BAVar.K, config, pose, ipobs);
    pjidx               = [(varidx-1)*4*plength+1:(varidx-1)*4*plength+4*plength];
    
    for j = 1:sum(valid) 
        idsrvar         = packIDSRvar(point, ipoint, ipobs, idsrcn, j);
        idsr            = initCovariance(idsrvar, pose, config);        
        idxj            = iindices(j);
        idx             = [(idxj-1)*3+1:(idxj-1)*3+3];
        cov(idx,:)      = idsr.cov + cov(idx,:);
        str(1:3,idxj)   = cov(idx,cidx)\cov(idx,midx);
        
        if ~config.packing
        Jcov(idx,pjidx) = idsr.J;    
        end
    end
end

%% Jacobian
if ~config.packing
for varidx = 1:length(varposes) 
pidx                = [(varidx-1)*plength+1:varidx*plength];
pjidx               = [(varidx-1)*4*plength+1:varidx*4*plength];
for j = 1:length(indices)
    idx             = [(j-1)*3+1:j*3];
    J               = Jcov(idx,pjidx);    
    Jmj             = J(:,1:6);
    Jcj             = J(:,7:end);        
    mun             = str(1:3,j); 
    cn              = cov(idx, cidx);    
    Jmun(idx,pidx)  = getIDSRJacobian(cn, mun, Jcj, Jmj);
end
end
end
%% Packing
BAVar.str           = str;
BAVar.cov           = cov;
BAVar.Jmun          = Jmun;