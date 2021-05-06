function viewdepth(depthmap, config)
load MyColormaps;
depth                   = depthmap(depthmap~=0);
mind                    = min(depth);
maxd                    = max(depth);
range                   = maxd - mind;
mind                    = max(0,mind-0.1*range);
maxd                    = maxd+0.1*range;
imshow(imrotate(depthmap,-config.dataset.rotate),[mind maxd], 'Colormap', jetMM); 