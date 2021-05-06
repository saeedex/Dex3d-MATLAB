function img = visualizeObservedPoints(Views, img, kf, feat, color, marker)
if nargin < 3
kf              = length(Views);
end
if nargin < 4
feat            = Views{kf}.feat(1:2,Views{kf}.tracks(:,2));
end
if nargin < 6
    marker = '+';
end
if nargin < 5
    color = 'red';
end
img             = insertMarker(img,feat', marker, 'Color', color);
