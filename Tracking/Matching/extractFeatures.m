function Views = extractFeatures(Images, config) 
Views           = [];
if ~config.run.srec; return; end
if ~config.smatch.apply; return; end
f = waitbar(0,strcat('Feature extraction')); 
for kf = 1:length(Images)
%% Extracting Features
Views                    = detfeat(Views, Images, kf, config);
waitbar(double(kf/length(Images)),f); 
if config.display
visimg                   = visualizeObservedPoints(Views, Images{kf}.colimage, kf, Views{kf}.feat(1:2,:));
figure(1); imshow(imrotate(visimg,-config.dataset.rotate)); set(gca,'Visible','off');
end
end
close(f)

