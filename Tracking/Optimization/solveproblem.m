function BAConfig       = solveproblem(BAConfig, BAVar, Hessian, config)
offset                  = BAConfig.clength + BAConfig.plength*length(BAConfig.poses);

%% solve inverse
if config.opt.var.str
[p, x]                  = schurcomplement(Hessian, BAConfig, BAVar, config); 
else
U                       = Hessian.Hpp + BAConfig.mu*eye(size(Hessian.Hpp));
b                       = Hessian.bp;
p                       = inverse(factorize(U))*b;
end
%% Output
if ~isempty(BAConfig.p(1:offset));      BAConfig.p(1:offset)         = p; end
if ~isempty(BAConfig.p(offset+1:end));  BAConfig.p(offset+1:end)     = x; end
