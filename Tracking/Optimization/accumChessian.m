function acc    = accumChessian(acc, jac, ir, valid, cidx)
if isempty(acc.bcAcc); return; end
for j = 1:sum(valid)
    %---- cam hessian        
    jiJc                    = jac.iJc((j-1)*2+1:j*2,:);           
    jiJct                   = jiJc';
    acc.HccAcc(cidx,cidx)   = acc.HccAcc(cidx,cidx) + jiJct*jiJc;
    acc.bcAcc(cidx)         = acc.bcAcc(cidx) - jiJct*ir(:,j);
end