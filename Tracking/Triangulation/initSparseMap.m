function Track = initSparseMap(str)
for i = 1:size(str,2)    
Track(i).Str                    = str(:,i);
Track(i).obsImages              = [];
Track(i).obsInliers             = [];
Track(i).obsLocs                = [];
Track(i).fidx                   = [];
Track(i).fDesc                  = [];
end
