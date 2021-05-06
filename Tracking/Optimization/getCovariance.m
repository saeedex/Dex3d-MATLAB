function IDSRvar= getCovariance(IDSRvar, config) 
%% Covariance
Rnj             = getRotation(IDSRvar.pj);
SRnj            = IDSRvar.sigma.*Rnj;
IDSRvar.cj      = Rnj'*SRnj;
%% Jacobian of covariance
if ~config.packing
IDSRvar.Jcj     = covJacobian(IDSRvar, Rnj, SRnj);
end