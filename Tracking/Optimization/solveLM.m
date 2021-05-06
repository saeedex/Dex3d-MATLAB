function BAVar = solveLM(BAConfig, BAVar, rmse, config)
if strcmp(config.opt.solver, 'builtin')
options                     = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','off');
p                           = lsqnonlin(@(x) BACalcResidual(BAConfig, BAVar, config, x), BAConfig.p, [], [], options);
BAVar                       = updateVariables(BAConfig, BAVar, config, p);
else
BAVar                       = updateVariables(BAConfig, BAVar, config);
Hessian                     = buildHessian(BAConfig, BAVar, config); 
BAConfig                    = estimateStep(BAConfig, Hessian, BAVar);
k                           = 0;

while (k <= BAConfig.ctrl.kmax) && ~BAConfig.ctrl.stop 
k                           = k + 1;
if BAConfig.ctrl.display; fprintf('Iteration %d                               \n', k); end

while BAConfig.ctrl.ro < 0 && ~BAConfig.ctrl.stop
BAConfig                    = solveproblem(BAConfig, BAVar, Hessian, config); 

if sqrt(sum(BAConfig.p.^2)) <= BAConfig.ctrl.epsilon(2)
    BAConfig.ctrl.stop      = 1;
else          
    BAVar_new               = updateVariables(BAConfig, BAVar, config, BAConfig.p);    
    pres_new                = BACalcResidual(BAConfig, BAVar_new, config);
    rmse_new                = sum(pres_new)/length(pres_new);

    if BAConfig.ctrl.display;  fprintf('                              = %f\n',  rmse_new); end
    
    BAConfig                = convergenceTest(BAConfig, Hessian, rmse, rmse_new);
    if (BAConfig.ctrl.ro > 0) 
        BAVar               = BAVar_new;               
        rmse                = rmse_new;
        Hessian             = buildHessian(BAConfig, BAVar, config);
        normg               = max(abs(Hessian.b));
        BAConfig.ctrl.stop  = BAConfig.ctrl.stop || (normg <= BAConfig.ctrl.epsilon(1));
        BAConfig.ctrl.mu    = BAConfig.mu*max(1/3, 1-(2*BAConfig.ctrl.ro-1)^3);
        BAConfig.ctrl.v     = 2;                   
    else
        BAConfig.mu         = BAConfig.mu*BAConfig.ctrl.v;
        BAConfig.ctrl.v     = 2*BAConfig.ctrl.v;
        if isinf(BAConfig.mu);  BAConfig.ctrl.stop = 1; end
    end
end
end
BAConfig.ctrl.ro            = -1;
BAConfig.ctrl.stop          = BAConfig.ctrl.stop || (rmse <= BAConfig.ctrl.epsilon(3));
end
end