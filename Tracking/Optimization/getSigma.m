function Jsigma = getSigma(IDSRvar)
%% Jacobian of sigma
ipoint          = IDSRvar.ipoint;
sigma           = IDSRvar.sigma;
Jsigma          = zeros(3,6);

Jz              = [0 0 1 ipoint(2) -ipoint(1) 0];
Jiz2            = -2*Jz/ipoint(3);
Jsigma(1,:)     = Jiz2*sigma(1);
Jsigma(2,:)     = Jiz2*sigma(2);
Jsigma(3,:)     = Jiz2*sigma(3);