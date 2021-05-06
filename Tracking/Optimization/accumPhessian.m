function acc = accumPhessian(acc, jac, ir, valid, pidx, clength)
if isempty(acc.bpAcc); return; end
for j = 1:sum(valid)
    %---- camera hessian        
    jiJp                    = jac.iJp((j-1)*2+1:j*2,:);           
    jiJpt                   = jiJp';
    dHpp                    = jiJpt*jiJp;
    dbp                     = - jiJpt*ir(:,j);
    
    acc.HppAcc(1:clength,1:clength)     = acc.HppAcc(1:clength,1:clength) + dHpp(1:clength,1:clength);
    acc.HppAcc(pidx,pidx)               = acc.HppAcc(pidx,pidx) + dHpp(clength+1:end,clength+1:end);
    
    acc.HppAcc(1:clength,pidx)          = acc.HppAcc(1:clength,pidx) + dHpp(1:clength,clength+1:end);
    acc.HppAcc(pidx,1:clength)          = acc.HppAcc(pidx,1:clength) + dHpp(clength+1:end,1:clength);
    
    acc.bpAcc(1:clength)                = acc.bpAcc(1:clength) + dbp(1:clength);
    acc.bpAcc(pidx)                     = acc.bpAcc(pidx) + dbp(clength+1:end);
end