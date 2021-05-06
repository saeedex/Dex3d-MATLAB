function jac = estimateJacobian(TK, uv, dscale, pose, config)
Jcam            = [];   
Jstr            = [];

fx              = TK(1,1);
fy              = TK(2,2);
u               = uv(1,:);
v               = uv(2,:);
R               = pose(:,1:3);
        
for i = 1:length(dscale)
uvs             = skewMatrix([u(i) v(i) 1])/dscale(i);    
J1              = dscale(i)*[fx 0 -u(i)*fx; 0 fy -v(i)*fy];
jcam            = [];

if config.opt.var.cam
jcam            = [jcam [u(i) 0 1 0; 0 v(i) 0 1]];
end
if config.opt.var.pos
jcam            = [jcam J1*[eye(3) -uvs]];
end
Jcam            = [Jcam; jcam];

if config.opt.var.str
Jstr            = [Jstr; J1*R];
end
end

jac.iJp        = Jcam;
jac.iJx        = Jstr;
