function [Pt, cov] = refineDIDSR(cov, ncov, Pt)
cov             = cov + ncov;
cj              = cov(1:9,:);
muj             = cov(10:12,:);
nPt             = zeros(3,size(Pt,2));
for j = 1:size(Pt,2)
nPt(:,j)        = reshape(cj(:,j),3,3)\muj(:,j);
end
Pt(1:3,:)       = nPt;