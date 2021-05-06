function mask = computeMask (I, config)
% compute a mask that selects patches with edges from the image I
%
% INPUT:
% - I ........... input image
% - threshold ... if the STD of a patch is > threshold, the patches is selected
% - win_var ..... size of the patches where the variance is computed 
%
% OUTPUT:
% - mask ........ binary mask where 1 indicates a patch containing an edge, 
%                 while 0 indicates a "flat" patch

% Written by Manuel Martinello
% January 2013
% Edinburgh, UK

threshold       = config.sdepth.edge.threshold;
win_var         = config.sdepth.edge.win;
borderx         = config.sdepth.edge.border;
bordery         = config.sdepth.edge.border;

%-- compute Variances of the RGB and IR patches 
mean_I = imfilter(I,ones(1,win_var)/win_var,'same','symmetric','conv');
mean2_I = imfilter(I.^2,ones(1,win_var)/win_var,'same','symmetric','conv');
std_I= real(sqrt(mean2_I-mean_I.^2)+1e-5);
mask= single(std_I>threshold);

% mean_I = imfilter(I,ones(win_var)/win_var/win_var,'same','symmetric','conv');
% mean2_I = imfilter(I.^2,ones(win_var)/win_var/win_var,'same','symmetric','conv');
% std_I= real(sqrt(mean2_I-mean_I.^2)+1e-5);
% mask= single(std_I>threshold);

% add the border of the image to the mask 
% (filters are not complete at the border)
 mask(1:[(bordery-1)/2],:)=0;
 mask([end-(bordery-1)/2+1]:end,:)=0;
 mask(:,1:[(borderx-1)/2])=0;
 mask(:,[end-(borderx-1)/2+1]:end)=0;

 
mask = medfilt2(mask, [3 3]); 

% add the area where the vignetting is too strong 
% (this needs a better estimation linked to the lens shading)
%--------------
%Cy=floor(size(mask,1)/2);
%Cx=floor(size(mask,2)/2);
%[x,y]=meshgrid(1:size(mask,2),1:size(mask,1));
%mask(((x-Cx).^2+(y-Cy).^2)>8e4)=0;
%mask(((x-Cx).^2+(y-Cy).^2)>1.3e4)=0;


