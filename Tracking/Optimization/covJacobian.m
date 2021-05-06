function Jc = covJacobian(IDSRvar, Rnj, SRnj)
pj          = IDSRvar.pj;
Jpj         = IDSRvar.Jpj;
Rv1x        = zeros(3); Rv2x = Rv1x; Rv3x = Rv1x;

nv          = (pj(1)^2+pj(2)^2);
dv          = pj(1)^2 - pj(2)^2;
a1          = (1-pj(3))/nv^2;
a2          = a1*dv;
a1          = a1*pj(1)*pj(2);

Rv1x(1,1)   = -2*a1*pj(2); 
Rv1x(1,2)   = +a2*pj(2);
Rv1x(1,3)   = -1;
Rv1x(2,1)   =  Rv1x(1,2);
Rv1x(2,2)   = -Rv1x(1,1); 
Rv1x(3,1)   = +1;

Rv2x(1,1)   = +2*a1*pj(1); 
Rv2x(1,2)   = -a2*pj(1); 
Rv2x(2,1)   =  Rv2x(1,2);
Rv2x(2,2)   = -Rv2x(1,1);
Rv2x(2,3)   = -1;
Rv2x(3,2)   =  1;

Rv3x(1,1)   =  pj(1)*pj(1)/nv;
Rv3x(1,2)   =  pj(1)*pj(2)/nv; 
Rv3x(2,1)   =  Rv3x(1,2);
Rv3x(2,2)   =  pj(2)*pj(2)/nv; 
Rv3x(3,3)   =  1;

%% Jacobian
tRnj        = Rnj';
Jc          = zeros(3,18);
Jsigma      = getSigma(IDSRvar);

for i       = 3:6
Cnjx        = tRnj*(Jsigma(:,i).*Rnj);

if i > 3
Rvx         = Rv1x*Jpj(1,i-3) + Rv2x*Jpj(2,i-3) + Rv3x*Jpj(3,i-3);
JRvx        = Rvx'*SRnj;
Cnjx        = JRvx + JRvx' + Cnjx;
end
Jc(:,(i-1)*3+1:(i-1)*3+3)   = Cnjx;
end
% pause