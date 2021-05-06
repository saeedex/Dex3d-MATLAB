function acc = accumcrossPhessian(acc, jac, valid, cidx, pidx)
if isempty(acc.HcpAcc); return; end
for j = 1:sum(valid)
    jiJp                    = jac.iJp((j-1)*2+1:j*2,:);           
    jiJc                    = jac.iJc((j-1)*2+1:j*2,:);           
    jiJct                   = jiJc';   

    acc.HcpAcc(cidx,pidx)   = jiJct*jiJp;       
end
