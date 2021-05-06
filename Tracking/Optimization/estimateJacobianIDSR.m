function JI = estimateJacobianIDSR(TK, uv, iz, pose, Jmun, indices, cidx)
JI              = zeros(2*length(iz),size(Jmun,2));
JK              = [TK(1,1) 0 -TK(1,1); 0 TK(2,2) -TK(2,2)];

for i = 1:length(iz)
    pidx        = (indices(i)-1)*3+1:indices(i)*3;
    uvs         = skewMatrix([uv(1,i) uv(2,i) 1])/iz(i);    
    Jc          = iz(i)*JK;
    Jc(:,3)     = Jc(:,3).*uv(:,i);
    Jg          = [eye(3) -uvs];

    Jgmu        = pose(:,1:3)*Jmun(pidx,:);
    Jgmu(:,cidx(1:6))= Jg + Jgmu(:,cidx(1:6));
   
    jidx        = (i-1)*2+1:i*2;
    JI(jidx,:)  = Jc*Jgmu;
end

