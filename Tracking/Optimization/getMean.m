function IDSRvar = getMean(IDSRvar, pose, config)
%% Mean
pj          = IDSRvar.pj;
alpha       = IDSRvar.x'*pj;
IDSRvar.muj = alpha*pj + pose(:,4);

%% Jacobian of mean
if ~config.packing
Rj          = pose(:,1:3);
IDSRvar.Jpj = Rj*skewMatrix(IDSRvar.obs)/IDSRvar.npj;
IDSRvar.Jmuj= [(pj*pj' - eye(3))*Rj (alpha*IDSRvar.Jpj)+(pj*IDSRvar.x'*IDSRvar.Jpj)];
end
