function fI = extractsaddsc(I, pos, sadpat, rad)
if isa(I, 'uint8')
I                   = double(I)./255;
end
rad                 = rad + 5;
I                   = padarray(I, [rad rad]);
pos                 = pos + rad;
[M,N]               = size(I);
patn                = size(sadpat,1); 
fI                  = zeros(size(pos,1), patn);

for k = 1:patn
idx                 = (pos(:,1)+sadpat(k,1)-1)*M + pos(:,2) + sadpat(k,1);
fI(:,k)             = I(idx);
end