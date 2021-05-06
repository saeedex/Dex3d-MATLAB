function [p, x]     = schurcomplement(Hessian, BAConfig, BAVar, config)
if strcmp(config.opt.solver, 'IDSRLBA1') 
U                   = Hessian.Hpp + BAConfig.mu*eye(size(Hessian.Hpp));
ea                  = Hessian.bp - Hessian.Hpx*Hessian.x;
p                   = inverse(factorize(U))*ea;
x                   = Hessian.x;
return;
end

if strcmp(config.opt.solver, 'SBA')   
vis                 = BAVar.vis;
mu                  = BAConfig.mu;
varposes            = BAConfig.poses;
clength             = BAConfig.clength;
plength             = BAConfig.plength;
slength             = BAConfig.slength;

U                   = Hessian.Hpp + mu*eye(size(Hessian.Hpp));
W                   = Hessian.Hpx;
V                   = Hessian.Hxx;
ea                  = Hessian.bp;
eb                  = Hessian.bx;
mu                  = mu*eye(3);

%% Implementation (SBA LOURAKIS paper)
% camlength           = clength + plength;
% YW                  = zeros(camlength*length(varposes));
% Yeb                 = zeros(camlength*length(varposes),1);
% x                   = zeros(slength,1);
% 
% for i = 1:size(vis,2)
% sidx                = (i-1)*3+1:i*3;
% Wi                  = W(:,sidx);
% Wit                 = Wi';
% Vi                  = V(:,sidx) + mu;
% for j = 1:length(varposes)
% pjidx               = (j-1)*camlength+1:j*camlength;
% Wij                 = Wi(pjidx,:); 
% Yij                 = Wij*inverse(Vi);
% Yeb(pjidx)          = Yeb(pjidx) + vis(j,i)*Yij*eb(sidx);
% 
% for k = 1:length(varposes)
%     pkidx           = (k-1)*camlength+1:k*camlength;
%     Wikt            = Wit(:,pkidx);
%     YW(pjidx,pkidx) = YW(pjidx,pkidx) + vis(j,i)*Yij*Wikt;      
% end
% 
% end      
% end
% 
% U                   = U - YW;
% ea                  = ea - Yeb;
% p                   = inverse(factorize(U))*ea;
% 
% for i   = 1:size(vis,2)
% pidx                = (i-1)*3+1:i*3;
% ebS                 = zeros(3,1);
% Wpidxt              = W(:,pidx)';
% 
% for j = 1:length(varposes)
%     cjidx           = (j-1)*camlength+1:j*camlength;
%     ebS             = ebS + vis(j,i)*Wpidxt(cjidx)*p(cjidx);
% end
% 
% Vi                  = V(:,pidx) + mu;
% x(pidx)             = inverse(Vi)*(eb(pidx) - ebS);
% end
%% Toolbox
Wt                  = W';
D                   = zeros(size(W,2));
for i = 1:size(vis,2)
sidx                = (i-1)*3+1:i*3;
Vi                  = V(:,sidx) + mu;
D(sidx,sidx)        = inverse(Vi);
end

Y                   = W*D;
YW                  = Y*Wt;
Yeb                 = Y*eb;

U                   = U - YW;
ea                  = ea - Yeb;


p                   = inverse(factorize(U))*ea;
x                   = D*(eb - Wt*p);
end
