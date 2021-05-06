function cond = inBB(kpos, M, N)
upX             = ~(kpos(:,1) > N);
lowX            = ~(kpos(:,1) < 1);
upY             = ~(kpos(:,2) > M);
lowY            = ~(kpos(:,2) < 1);
cond            = logical(upX .* lowX .* upY .* lowY);  