function [depth, conf] = OPAdepthExtractor(Images, kf, config)
%% Pre-processing
limg                          = double(Images{kf}.limage)./255;
rimg                          = double(Images{kf}.rimage)./255;
cimg                          = double(Images{kf}.gryimage)./255;
[M,N]                         = size(limg);
load MyColormaps;
%% Resizing input
limg                          = imresize(limg, [ceil(M/config.sdepth.sparsity),ceil(N/config.sdepth.sparsity)],'nearest');
rimg                          = imresize(rimg, [ceil(M/config.sdepth.sparsity),ceil(N/config.sdepth.sparsity)],'nearest');
cimg                          = imresize(cimg, [ceil(M/config.sdepth.sparsity),ceil(N/config.sdepth.sparsity)],'nearest');

%% Depth extraction

config.sdepth.winsize         = max(config.sdepth.minwin,floor(config.sdepth.winsize/config.sdepth.sparsity));
maxdisp                       = floor(config.sdepth.maxdisp/config.sdepth.sparsity);
config.sdepth.range           = [-maxdisp:maxdisp];
[disp, conf]                  = extractDisparity_callib(limg, rimg, cimg, config);
disp                          = length(config.sdepth.range) - disp + 1;

%% Post Processing
disp                          = bilateralSolver(disp, conf, cimg, config);

%% Resizing
depth                         = 1./disp*config.sdepth.sparsity;
depth                         = imresize(depth, size(Images{kf}.gryimage));
depth                         = uint8((2^8-1)*depth/max(depth(:)));
figure(20);  imshow(Images{kf}.colimage); title('Scene', 'Color', 'white');
figure(21);  imshow(depth,[min(depth(depth~=0)) max(depth(depth~=0))], 'Colormap', jetMM);  title('Stacy Depth', 'Color', 'white');