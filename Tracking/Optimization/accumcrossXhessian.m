function acc = accumcrossXhessian(acc, jac, iindices, valid, pidx, clength, config)
if ~config.opt.var.str; return; end
for j = 1:sum(valid)    
    sidx                    = [(iindices(j)-1)*3+1:iindices(j)*3];   
    jiJx                    = jac.iJx((j-1)*2+1:j*2,:);
    
    if ~isempty(acc.HpxAcc)
    jiJp                    = jac.iJp((j-1)*2+1:j*2,:);           
    jiJpt                   = jiJp';
    dHpx                    = jiJpt*jiJx; 
    
    acc.HpxAcc(1:clength,sidx)      = dHpx(1:clength,:);       
    acc.HpxAcc(pidx,sidx)           = dHpx(clength+1:end,:);       
    end
end