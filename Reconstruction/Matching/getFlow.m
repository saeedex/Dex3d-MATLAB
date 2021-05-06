function [flowv, valid] = getFlow(flow, mimage, smpos)
Vx                  = flow(:,:,1);
Vy                  = flow(:,:,2);

fmpos               = floor(smpos);
cmpos               = ceil(smpos);
mpos1               = fmpos;
mpos2               = [fmpos(:,1) cmpos(:,2)];
mpos3               = [cmpos(:,1) fmpos(:,2)];
mpos4               = cmpos;

midx1               = (mpos1(:,1)-1)*size(mimage,1)+mpos1(:,2);
midx2               = (mpos2(:,1)-1)*size(mimage,1)+mpos2(:,2);
midx3               = (mpos3(:,1)-1)*size(mimage,1)+mpos3(:,2);
midx4               = (mpos4(:,1)-1)*size(mimage,1)+mpos4(:,2);

valid1              = logical((midx1 > 0).*(midx1 <= numel(Vx(:))));
valid2              = logical((midx2 > 0).*(midx2 <= numel(Vx(:))));
valid3              = logical((midx3 > 0).*(midx3 <= numel(Vx(:))));
valid4              = logical((midx4 > 0).*(midx4 <= numel(Vx(:))));
valid               = logical(valid1.*valid2.*valid3.*valid4);

midx1               = midx1(valid);
midx2               = midx2(valid);
midx3               = midx3(valid);
midx4               = midx4(valid);
dmpos               = smpos - fmpos;     
dmpos               = dmpos(valid,:);

Vx1                 = Vx(midx1);
Vx2                 = Vx(midx2);
Vx3                 = Vx(midx3);
Vx4                 = Vx(midx4);
Vy1                 = Vy(midx1);
Vy2                 = Vy(midx2);
Vy3                 = Vy(midx3);
Vy4                 = Vy(midx4);

Vx11                = (1-dmpos(:,1)).*Vx1 + (dmpos(:,1).*Vx3);
Vx22                = (1-dmpos(:,1)).*Vx2 + (dmpos(:,1).*Vx4);
Vy11                = (1-dmpos(:,1)).*Vy1 + (dmpos(:,1).*Vy3);
Vy22                = (1-dmpos(:,1)).*Vy2 + (dmpos(:,1).*Vy4);
Vx                  = (1-dmpos(:,2)).*Vx11 + (dmpos(:,2).*Vx22);
Vy                  = (1-dmpos(:,2)).*Vy11 + (dmpos(:,2).*Vy22);

flowv               = [Vx Vy];