function tx = skewMatrix(t)
tx          = [0     -t(3)  t(2);
               t(3)   0    -t(1);
              -t(2)  t(1)     0];   