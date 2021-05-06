function saveXML(SparseMap, Images)
savepath = [SparseMap.frames.path 'reconstruction\'];
mkdir(savepath);
%% Save cameras in XML format
fileID      = fopen([savepath 'cameras.out'],'w');
numOfcams   = length(SparseMap.frames.regcams);
numOfpoints = 0;
k1          = 0;
k2          = 0;
fx          = SparseMap.frames.K(1,1);
fy          = SparseMap.frames.K(2,2);
fprintf(fileID, '# Bundle file v0.3\n');
fprintf(fileID, '%d %d\n', numOfcams, numOfpoints);

for i = 1:numOfcams
kf          = SparseMap.frames.regcams(i);
ext         = invertPoses(SparseMap.Views{kf}.pose);
ext(2:3,:)  = -ext(2:3,:);
ext         = [ext(1:3,1:3); ext(1:3,4)'];

fprintf(fileID, '%6.6f %d %d\n', fx, k1, k2);
fprintf(fileID, '%6.6f %6.6f %6.6f\n', ext(1,1), ext(1,2), ext(1,3));
fprintf(fileID, '%6.6f %6.6f %6.6f\n', ext(2,1), ext(2,2), ext(2,3));
fprintf(fileID, '%6.6f %6.6f %6.6f\n', ext(3,1), ext(3,2), ext(3,3));
fprintf(fileID, '%6.6f %6.6f %6.6f\n', ext(4,1), ext(4,2), ext(4,3));
end

fprintf(fileID, '%d %d %d\n', 0, 0, 0);
fclose(fileID);

%% Save rasters
for i = 1:length(SparseMap.frames.regcams)
kf  = SparseMap.frames.regcams(i);
filename = [savepath int2str(kf) '.jpg'];
imwrite(Images{kf}.colimage, filename);
end