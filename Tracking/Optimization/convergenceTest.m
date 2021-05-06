function BAConfig   = convergenceTest(BAConfig, Hessian, rmse, rmse_new)
plength             = BAConfig.plength;
clength             = BAConfig.clength;
varposes            = BAConfig.poses;
offset              = clength + plength*length(varposes);

p                   = BAConfig.p(1:offset);
x                   = BAConfig.p(offset+1:end)';

ro_num              = (rmse^2 - rmse_new^2);

ro_denp             = p*(BAConfig.mu*p' + Hessian.bp);
ro_denx             = 0;

if isfield(Hessian, 'bx')
for i           = 1:size(x,2)
    pidx            = (i-1)*3+1:(i-1)*3+3;
    xi              = x(pidx);
    pidx            = (i-1)*3+1:(i-1)*3+3;
    ro_denx         = ro_denx + xi'*(BAConfig.mu*xi + Hessian.bx(pidx,:));
end
end

BAConfig.ctrl.ro    = ro_num/(ro_denp + ro_denx);

if BAConfig.ctrl.ro > 0 
BAConfig.ctrl.stop  = (rmse - rmse_new) < rmse*BAConfig.ctrl.epsilon(4);
end