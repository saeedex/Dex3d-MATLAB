function iposes = invertPoses(poses)
iposes          = poses;
for i = 1:size(poses,3)
    R               = poses(:,1:3,i);
    tR              = R';
    t               = poses(:,4,i);
    iposes(:,:,i)   = [tR -tR*t];
end