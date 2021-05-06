function config = denseConfig(config)
%%---- Stacy
config.sdepth.mode                  = 'read';
config.sdepth.sparsity              = 1; 
config.sdepth.rescale               = 0; 
config.sdepth.edge.apply            = 1;
config.sdepth.edge.threshold        = 0.5/255;
config.sdepth.edge.win              = 3;
config.sdepth.edge.border           = 3;

%%---- Morrie
config.mdepth.flow.apply            = 1;
config.mdepth.flow.method           = 'deep';                               % 'classical', 'deep'
config.mdepth.flow.winsize          = 15;
config.mdepth.flow.minsearch        = 0;
config.mdepth.flow.maxsearch        = 100;

config.mdepth.refine.apply          = 1;
config.mdepth.refine.method         = 'DIDSR';                              % 'DIDSR', 'DLT'
config.mdepth.filter.minvis         = 3;
config.mdepth.filter.geotresh       = 1;
config.mdepth.filter.photresh       = 0.05;                                    % 0.05 matching threshold
