function saveOUT(SparseMap, Images, pcl, map)
savepath = [SparseMap.frames.path 'reconstruction\'];
mkdir(savepath);
%% Save cameras in Bundle OUT format
fileID      = fopen([savepath 'bundle.out'],'w');
numOfcams   = length(SparseMap.frames.regcams);
numOfpoints = size(pcl,2);
k1          = 0;
k2          = 0;
fx          = SparseMap.frames.K(1,1);
fy          = SparseMap.frames.K(2,2);
fprintf(fileID, '# Bundle file v0.3\r\n');
fprintf(fileID, '%d ', [numOfcams numOfpoints]); fprintf(fileID,'\r\n');

for i = 1:numOfcams
kf          = SparseMap.frames.regcams(i);
ext         = invertPoses(SparseMap.Views{kf}.pose);
ext(2:3,:)  = -ext(2:3,:);
ext         = [ext(1:3,1:3); ext(1:3,4)'];

fprintf(fileID, '%f ', fx, k1, k2); fprintf(fileID,'\r\n');
fprintf(fileID, '%f ', ext(1,:)); fprintf(fileID,'\r\n');
fprintf(fileID, '%f ', ext(2,:)); fprintf(fileID,'\r\n');
fprintf(fileID, '%f ', ext(3,:)); fprintf(fileID,'\r\n');
fprintf(fileID, '%f ', ext(4,:)); fprintf(fileID,'\r\n');
end

%% Save points in Bundle OUT format
for j = 1:numOfpoints
loc         = single(pcl(1:3,j));
col         = uint8(pcl(7:9,j)*255);
vis         = single(map(j).track(1));
track       = map(j).track(2:end);
fprintf(fileID, '%f ', loc); fprintf(fileID,'\r\n');
fprintf(fileID, '%d ', col); fprintf(fileID,'\r\n');
fprintf(fileID, '%d', vis);      
for visj = 1:vis
tidx        = (visj-1)*4 + 1: (visj-1)*4 + 4;
fprintf(fileID, ' %d', single(track(tidx(1:2))));  
fprintf(fileID, ' %f', double(track(tidx(3:4))));  
end
fprintf(fileID,'\r\n');
end
fclose(fileID);

%% Save rasters
fileID      = fopen([savepath 'list.txt'],'w');
for i = 1:length(SparseMap.frames.regcams)
kf  = SparseMap.frames.regcams(i);
filename    = [int2str(kf) '.jpg'];
fprintf(fileID, '%s\n', filename);
imwrite(Images{kf}.colimage, [savepath filename]);
end
fclose(fileID);
