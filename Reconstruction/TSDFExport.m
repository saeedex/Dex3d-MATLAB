function TSDFExport(SparseMap, Images, config)
savepath                            = [SparseMap.frames.path 'reconstruction\TSDF Export\'];
mkdir(savepath);

%% Save Depthmaps
for j = 1:length(SparseMap.frames.regcams)
kf                                  = SparseMap.frames.regcams(j);
depthmap                            = uint16((2^16-1)*Images{kf}.depth/config.dataset.maxz);
imwrite(depthmap, [savepath 'sdepth' int2str(kf) '.png']);

kf                                  = SparseMap.frames.regcams(j);
depthmap                            = uint16((2^16-1)*Images{kf}.mdepth/config.dataset.maxz);
imwrite(depthmap, [savepath 'depth' int2str(kf) '.png']);


load MyColormaps;
% figure(1);  imshow(Images{kf}.colimage); title('Scene', 'Color', 'white');
figure(3);  imshow(depthmap, 'Colormap', jetMM);  title('Stacy Depth', 'Color', 'white'); 
% pause
end
fileID      = fopen([savepath 'maxdistance.txt'],'w');
fprintf(fileID, '%6.6f\n', config.dataset.maxz);
fclose(fileID);
%% Save cameras in Bundle OUT format
fileID      = fopen([savepath 'intrinsic.txt'],'w');
intr        = SparseMap.frames.K;
fprintf(fileID, '%6.6f %6.6f %6.6f\n', intr(1,1), intr(1,2), intr(1,3));
fprintf(fileID, '%6.6f %6.6f %6.6f\n', intr(2,1), intr(2,2), intr(2,3));
fprintf(fileID, '%6.6f %6.6f %6.6f\n', intr(3,1), intr(3,2), intr(3,3));
fclose(fileID);

numOfcams   = length(SparseMap.frames.regcams);
for i = 1:numOfcams
kf          = SparseMap.frames.regcams(i);
ext         = SparseMap.Views{kf}.pose;

fileID      = fopen([savepath 'pose' int2str(kf) '.txt'],'w');
fprintf(fileID, '%6.6f %6.6f %6.6f %6.6f\n', ext(1,1), ext(1,2), ext(1,3), ext(1,4));
fprintf(fileID, '%6.6f %6.6f %6.6f %6.6f\n', ext(2,1), ext(2,2), ext(2,3), ext(2,4));
fprintf(fileID, '%6.6f %6.6f %6.6f %6.6f\n', ext(3,1), ext(3,2), ext(3,3), ext(3,4));
fprintf(fileID, '%6.6f %6.6f %6.6f %6.6f\n', 0, 0, 0, 1);
fclose(fileID);
end