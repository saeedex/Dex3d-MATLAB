function Hessian = constructHessian(acc, config)
%% Cameras
Hessian.Hpp             = acc.HppAcc;
Hessian.bp              = acc.bpAcc;
Hessian.b               = Hessian.bp;

%% Structure
if config.opt.var.str
Hessian.Hpx             = acc.HpxAcc;

if strcmp(config.opt.solver, 'SBA')
Hessian.Hxx             = acc.HxxAcc;
Hessian.bx              = acc.bxAcc;
Hessian.b               = [Hessian.b; Hessian.bx];
end
end