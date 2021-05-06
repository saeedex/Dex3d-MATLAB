function sadpat     = sadpattern(rad)
xgv                 = [-rad:rad];
ygv                 = [-rad:rad];
[X,Y]               = meshgrid(xgv,ygv);
sadpat              = [X(:) Y(:)];
%% Reading data
