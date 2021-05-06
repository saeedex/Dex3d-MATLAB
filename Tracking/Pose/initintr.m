function K  = initintr(Images, config)
[M,N]       = size(Images{1}.gryimage);
if ~config.tracking.arcore
K         	= [config.camera.intscale*N 0 M/2; 0 config.camera.intscale*N N/2; 0 0 1]; 
else
K       	= [503.23676 0 240.91353; 0 502.81366 321.09080; 0 0 1]; 
end
