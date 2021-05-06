function BAConfig = estimateStep(BAConfig, Hessian, BAVar)
U           = Hessian.Hpp;
mu          = max([0; diag(U)]);

% if isfield(Hessian, 'Hxx')
% V           = Hessian.Hxx;
% for i       = 1:size(BAVar.str,2)
%     pidx    = [(i-1)*3+1:(i-1)*3+3];
%     mu      = max([mu; diag(V(:,pidx))]); 
% end
% end

BAConfig.mu   = BAConfig.ctrl.tau*mu;
normg         = max(abs(Hessian.b));
BAConfig.ctrl.stop = normg <= BAConfig.ctrl.epsilon(1);