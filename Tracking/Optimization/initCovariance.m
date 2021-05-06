function idsr = initCovariance(IDSRvar, pose, config) 
%% mean and covariance
IDSRvar             = getMean(IDSRvar, pose, config);
IDSRvar             = getCovariance(IDSRvar, config);

%% Output
idsr.cov            = [IDSRvar.cj*IDSRvar.muj IDSRvar.cj];
if ~config.packing; idsr.J = concatenateJacobians(IDSRvar); end
