function Rnj = getRotation(pj)
%% Rotation matrix
pj1     = pj(1);
pj2     = pj(2);
pj3     = pj(3);

pj12    = pj1*pj1;
pj22    = pj2*pj2;
nv      = (pj12+pj22);

Rnj     = [(pj22+pj3*pj12)/nv    (pj3-1)*pj1*pj2/nv     -pj1;
           (pj3-1)*pj1*pj2/nv    (pj12+pj3*pj22)/nv     -pj2;
            pj1                   pj2                    pj3];
