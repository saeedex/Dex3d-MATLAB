function flow = importDeepFlow(kimage, frames, kf, config)
path                                = [frames.path 'reconstruction\DenseFlow\RAFT\'];
dirs                                = dir(strcat(path, '*.npy'));
frames.deepflow                     = {dirs.name};
data                                = readNPY([path frames.deepflow{kf-1}]);
flow                                = zeros(640,480,2);
%% DIS
% flow(:,:,1)                         = data(:,:,1);
% flow(:,:,2)                         = data(:,:,2);

%% FLOWNET
% flow(:,:,1)                         = imresize(data(:,:,1), size(kimage));
% flow(:,:,2)                         = imresize(data(:,:,2), size(kimage));

%--- RAFT
flow(:,:,1)                         = data(1,:,:);
flow(:,:,2)                         = data(2,:,:);