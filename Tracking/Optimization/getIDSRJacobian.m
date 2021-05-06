function Jmun = getIDSRJacobian(cn, mun, Jcj, Jmj)
Jmj     = Jmj - reshape(mun'*Jcj,3,6);
Jmun    = cn\Jmj;
