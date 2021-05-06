function [Images, frames] = loadFrames(frames, config)
%% Reading images
f = waitbar(0,strcat('Loading dataset -  ', config.dataset.name));
for kf = 1:frames.length
    
%%--- color image    
if ~isempty(frames.color)
cimg                                = imread([frames.path  frames.color{kf}]);  
cimg                                = imrotate(cimg,config.dataset.rotate);
if isa(cimg, 'uint16')
cimg                                = uint8(255*double(cimg)/(2^16-1));
end
gimg                                = rgb2gray(cimg);
end

%%--- stereo pair
% if ~isempty(frames.imagesLeft)
% limg                                = imread(strcat(frames.path, frames.imagesLeft{kf}));
% rimg                                = imread(strcat(frames.path, frames.imagesRight{kf}));  
% limg                                = limg(:,:,1);
% rimg                                = rimg(:,:,1);
% if isa(limg, 'uint16')
% limg                                = uint8(255*double(limg)/(2^16-1));
% rimg                                = uint8(255*double(rimg)/(2^16-1));
% end
% if isempty(frames.color)
% cimg                                = limg;
% gimg                                = limg;
% end
% end

%%--- resize
M                                   = size(cimg,1);
N                                   = size(cimg,2);
cimg                                = imresize(cimg, [ceil(M*config.dataset.imresize),ceil(N*config.dataset.imresize)],'nearest');
gimg                                = imresize(gimg, [ceil(M*config.dataset.imresize),ceil(N*config.dataset.imresize)],'nearest');

%%--- save images
Images{kf}.colimage                 = cimg;
Images{kf}.gryimage                 = gimg;
% if ~isempty(frames.imagesLeft)
% limg                                = imresize(limg, [ceil(M*config.dataset.imresize),ceil(N*config.dataset.imresize)],'nearest');
% rimg                                = imresize(rimg, [ceil(M*config.dataset.imresize),ceil(N*config.dataset.imresize)],'nearest');
% Images{kf}.limage                   = limg;
% Images{kf}.rimage                   = rimg;
% end
waitbar(double(kf/frames.length),f); 
end
close(f)
