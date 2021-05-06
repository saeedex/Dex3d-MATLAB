function J = concatenateJacobians(IDSRvar)
Jmj        = reshape(IDSRvar.muj'*IDSRvar.Jcj, 3, 6) + IDSRvar.cj*IDSRvar.Jmuj;
J          = [Jmj IDSRvar.Jcj];