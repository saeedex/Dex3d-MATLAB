function BAVar = interleavedLM(BAConfig, BAVar, rmse, config)
if ~strcmp(config.opt.scheme, 'interleaved'); return; end
% config.opt.solver           = 'built-in';
k                           = 0;
stop                        = 0;
config.packing              = 1;
while k <= BAConfig.ctrl.kmax && ~stop 
    k                       = k + 1;
    BAVar                   = updatePoints(BAConfig, BAVar, config);
    BAVar                   = solveLM(BAConfig, BAVar, rmse, config);
    pres_new                = BACalcResidual(BAConfig, BAVar, config);
    rmse_new                = sum(pres_new)/length(pres_new);
    
    if rmse_new/rmse < (1-BAConfig.ctrl.epsilon(1))
        rmse                = rmse_new;
    else
        stop                = 1;
    end
    if BAConfig.ctrl.display; fprintf('RI iteration %d =                      %f\n', k, rmse); end
end
