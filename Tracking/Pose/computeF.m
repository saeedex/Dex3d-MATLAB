function [F, L] = computeF(Views, frames, mpos, kf, mf)
K           = frames.K;
pose1       = Views{mf}.pose;
psoe2       = Views{kf}.pose;

R1          = pose1( : , 1:3);
t1          = pose1( : , 4);
R2          = psoe2( : , 1:3);
t2          = psoe2( : , 4);

R           = R1'*R2;
t           = R1'*(t2 - t1);
%% Compute F
A           = K * R' * t;
C           = [0 -A(3) A(2); A(3) 0 -A(1); -A(2) A(1) 0];
F           = (inv(K))' * R * K' * C;

%% Compute epipolar line
L          = F'*[mpos'; ones(1,size(mpos,1))];