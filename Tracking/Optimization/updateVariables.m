function BAVar = updateVariables(BAConfig, BAVar, config, p)
clength         = BAConfig.clength;
plength         = BAConfig.plength;
slength         = BAConfig.slength;
varposes        = BAConfig.poses;
offset          = clength + plength*length(BAConfig.poses);

if nargin > 3
%% Intrinsic update
if clength ~= 0
BAVar.K                 = BAVar.K + twist2intr(p(1:clength));
end
%% Pose update
for j = 1:length(varposes)
cidx                    = varposes(j);
cjidx                   = (j-1)*plength+1+clength:j*plength+clength;
if plength ~= 0
BAVar.poses(:,:,cidx)   = concatenateRts(twist2pose(p(cjidx)), BAVar.poses(:,:,cidx));
end
end

%% Points update
if slength ~= 0
for i   = 1:size(BAVar.str,2)
    pidx                = (i-1)*3+1+offset:i*3+offset;
    BAVar.str(1:3,i)    = BAVar.str(1:3,i) + p(pidx)';
end
end
end

%% IDSR
if strcmp(config.opt.solver, 'IDSRLBA2')
config.packing          = 1;
BAVar                   = updatePoints(BAConfig, BAVar, config);

config.packing          = 0;
BAVar                   = updatePoints(BAConfig, BAVar, config);
end
