function IDSRvar = packIDSRvar(point, ipoint, ipobs, idsrcn, j)
IDSRvar.point   = point(:,j);
IDSRvar.ipoint  = ipoint(:,j);
IDSRvar.obs     = ipobs(:,j);  
IDSRvar.sigma   = idsrcn.sigma(:,j);       
IDSRvar.pj      = idsrcn.pj(:,j);
IDSRvar.npj     = idsrcn.npj(j);
IDSRvar.x       = idsrcn.x(:,j);