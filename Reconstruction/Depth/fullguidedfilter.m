function cimage = fullguidedfilter(guidex, guidey, cimage, config)
if ~config.sdepth.ca.apply; return; end
[M,N]   = size(cimage);
mask    = cimage ~= 0; 
AL      = cimage;
AR      = cimage;

nL      = ones(M,N);
nR      = ones(M,N);
nT      = ones(M,N);
nB      = ones(M,N);

%left-right and right-left
for col=2:N
    AL(:,col)  = AL(:,col)+AL(:,col-1).*guidex(:,col-1);
    nL(:,col)  = nL(:,col)+nL(:,col-1).*guidex(:,col-1);
end


for col=N-1:-1:1
    AR(:,col)  = AR(:,col)+AR(:,col+1).*guidex(:,col+1);
    nR(:,col)  = nR(:,col)+nR(:,col+1).*guidex(:,col+1);
end

AH      = AL + AR;
nH      = nL + nR;


AT      = AH./nH;
AB      = AT;

% top-bottom and bottom-top
for row=2:M
    AT(row,:)  = AT(row,:)+AT(row-1,:).*guidey(row-1,:);
    nT(row,:)  = nT(row,:)+nT(row-1,:).*guidey(row-1,:);
end

for row=M-1:-1:1
    AB(row,:)  = AB(row,:)+AB(row+1,:).*guidey(row+1,:);
    nB(row,:)  = nB(row,:)+nB(row+1,:).*guidey(row+1,:);
end

cimage = (AT + AB)./(nT + nB);
cimage(~mask) = 0;
% function guide = huberguide(ri, threshold)
% absri                       = abs(ri);
% guide                      = ones(size(ri));
% guide(absri > threshold)   = threshold./absri(absri > threshold);  