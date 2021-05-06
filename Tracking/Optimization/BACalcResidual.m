function pres = BACalcResidual(BAConfig, BAVar, config, p)

%% Update variables
if nargin > 3
BAVar                   = updateVariables(BAConfig, BAVar, config, p);  
else
BAVar                   = updateVariables(BAConfig, BAVar, config);
end
%% Select inliers
indices                 = [1:size(BAVar.str,2)]';
pres                    = zeros(size(indices))'; 
visible                 = pres;

for i = 1:length(BAConfig.regcams)
    pose                = BAVar.poses(:,:,i);
    valid               = BAVar.vis(i,:) ~= 0;
    iindices            = indices(valid);
    points              = BAVar.str(1:3,valid);
    iobs                = BAVar.str((i-1)*2+4:(i-1)*2+5,valid);
    iprj                = projectPoints(BAVar.K, pose, points);
    res                 = iprj - iobs;
    ires                = sum(res.^2,1);
    pres(iindices)      = pres(iindices) + ires;
    visible(iindices)   = visible(iindices) + 1;
end
pres                    = pres./visible;