function Hes = initializeHessian(BAConfig)
clength                 = BAConfig.clength;
plength                 = BAConfig.plength;
slength                 = BAConfig.slength;
varposes                = BAConfig.poses;
camlength               = plength*length(varposes)+clength;

Hes.HppAcc              = zeros(camlength);
Hes.HxxAcc              = zeros(3,slength); 
Hes.HpxAcc              = zeros(camlength, slength);
Hes.bpAcc               = zeros(camlength,1);
Hes.bxAcc               = zeros(slength,1);   