function fidx = knnmatchwrap(des1, des2, config)
fidx                = [];
if config.smatch.knn
matches             = config.smatch.matcher.knnMatch(des1, des2, 2);    
idx                 = cellfun(@(m) (numel(m) == 2) && (m(1).distance < config.smatch.threshold * m(2).distance), matches);
matches             = cellfun(@(m) m(1), matches(idx));
if isempty(matches); return; end
fidx                = [cat(1, [matches.queryIdx]+1); cat(1, [matches.trainIdx]+1)]';
[~, ia, ~]          = unique(fidx(:, 2), 'rows');
fidx                = fidx(ia,:);
else
matches             = config.smatch.matcher.match(des1, des2);    
fidx                = [cat(1, [matches.queryIdx]+1); cat(1, [matches.trainIdx]+1)]';
distance            = cat(1, matches.distance); 
fidx                = fidx(distance < 20, :);
end

