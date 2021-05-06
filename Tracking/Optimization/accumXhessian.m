function acc = accumXhessian(acc, jac, ir, iindices, valid, config)
if strcmp(config.opt.solver, 'IDSRLBA1'); return; end
if isempty(acc.bxAcc); return; end 

for j = 1:sum(valid)
    pidx                    = [(iindices(j)-1)*3+1:iindices(j)*3];      
    jiJx                    = jac.iJx((j-1)*2+1:(j-1)*2+2,:);
    jiJxt                   = jiJx';
    acc.HxxAcc(:,pidx)      = acc.HxxAcc(:,pidx) + jiJxt*jiJx;
    acc.bxAcc(pidx)         = acc.bxAcc(pidx) - jiJxt*ir(:,j); 
end