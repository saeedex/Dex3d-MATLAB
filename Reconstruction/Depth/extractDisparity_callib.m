function [disp, conf] = extractDisparity_callib(imgL, imgR, cimg, config)
win         = config.sdepth.winsize;
drange      = config.sdepth.range;
aggsigma    = config.sdepth.ca.sigma;

%% build the cost volume
[m,n]       = size(imgL);
cvol        = zeros(m,n,length(drange),'single');

%-- pre-process for NCC
nccL        = extractncc(imgL, win);
%-- pre-process for aggregration

[gx,gy]     = imgradientxy(cimg, 'prewitt');
guidex      = aggsigma./(aggsigma+gx.^2);
guidey      = aggsigma./(aggsigma+gy.^2);
% guidex      = exp(-gx.^2/aggsigma);
% guidey      = exp(-gy.^2/aggsigma);

for i = 1:length(drange)
imgRt           = imtranslate(imgR,[-drange(i), 0]);
nccR            = extractncc(imgRt, win);
cvol(:,:,i)     = matchncc(nccL, nccR, win);
cvol(:,:,i)     = fullguidedfilter(guidex, guidey, cvol(:,:,i), config);
end

%% Subpixel disparity
[conf, disp]   = max(cvol,[],3);
sampleNumber    = 3;
halfSample      = floor(sampleNumber/2);

for y=1:m
for x=1:n
if (disp(y,x) > halfSample) && (disp(y,x) < drange(end)-drange(1)+1-halfSample)
    A           = cvol(y,x,disp(y,x))-cvol(y,x,disp(y,x)+1);
    B           = cvol(y,x,disp(y,x))-cvol(y,x,disp(y,x)-1);
    disp(y,x)=((A+B)*disp(y,x)+(B-A)*0.5)/(A+B);
end
end
end

