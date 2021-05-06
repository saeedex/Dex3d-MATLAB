function cost = costPhotometric(mimage, kimage, smpos, skpos, config)
[M,N]               = size(mimage);
rad                 = floor(config.mdepth.flow.winsize/2);
sadpat              = sadpattern(rad);
mI                  = subpixelSAD(mimage, smpos, sadpat, rad);
kI                  = subpixelSAD(kimage, skpos, sadpat, rad);

% mpos                = floor(smpos);
% kpos                = floor(skpos);
% mI                  = extractsaddsc(mimage, mpos, sadpat, rad);
% kI                  = extractsaddsc(kimage, kpos, sadpat, rad);

residual            = abs(mI - kI);
cost                = sum(residual,2)/size(residual,2);

