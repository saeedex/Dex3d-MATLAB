function Views = detfeat(Views, Images, kf, config)
inpImage                        = Images{kf}.colimage;
if ~isa(inpImage, 'uint8')
inpImage                        = uint8(inpImage*255);
end
[kpt, dsc]                      = config.smatch.detector.detectAndCompute(inpImage);
Views{kf}.feat                  = (cat(1, kpt([1:length(kpt)]).pt))';
Views{kf}.dsc                   = dsc;
Views{kf}.matched               = false(1,size(Views{kf}.feat,2));