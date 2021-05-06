function k = twist2intr(p)
k       = zeros(3);
% p       = p*10^3;
k(1,1)  = p(1); 
k(2,2)  = p(2);

k(1,3)  = p(3);
k(2,3)  = p(4);