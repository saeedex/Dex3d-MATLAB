function config = sparseConfig(config)
%%---- Display Options
config.display                      = 1;

%%---- Sparse Matching
config.smatch.apply                 = 1;
config.smatch.threshold             = 0.6; 
config.smatch.feature               = 'AKAZE';                              %SIFT ORB AKAZE 
config.smatch.knn                   = 1;
config.smatch.display               = 0;
config.smatch.conpoints             = 1; 
config.smatch.conperc               = 0.10;

%%---- Tracking
config.tracking.arcore              = 1;

%%---- Keyframe selection
config.pushkf.euc                   = 0.05;
config.pushkf.perc                  = 0.1;

%%---- Optimization
config.opt.apply                    = 0;
config.opt.display                  = 0;

config.opt.var.cam                  = 1; 
config.opt.var.pos                  = 1; 
config.opt.var.str                  = 1; 
config.opt.scheme                   = 'interleaved';                        % 'interleaved' 'joint'
config.opt.solver                   = 'builtin';                            % 'builtin' 'SBA' 'IDSR' 'IDSRLBA1' IDSRLBA2' 
config.opt.method                   = 'local';                              %'local' 'global'
config.opt.length                   = 10; 
config.opt.threshold                = 2;
config.opt.numpoints                = 1500;

%%---- Camera
config.camera.intscale              = 1.5;
config.camera.baseline              = 8*10^-3;    
config.camera.alpha                 = 5.6*10^-6;   
config.camera.pixel_scale           = 10;


%%----- Feature extractor
if strcmp(config.smatch.feature, 'SIFT')
config.smatch.detector              = cv.SIFT('NFeatures', 10000); 
config.smatch.matcher               = cv.DescriptorMatcher('FlannBased');
elseif strcmp(config.smatch.feature, 'ORB')
config.smatch.detector              = cv.ORB('MaxFeatures', 10000); 
config.smatch.matcher               = cv.DescriptorMatcher('FlannBasedMatcher', 'Index',{'LSH', 'TableNumber', 12, 'KeySize', 20, 'MultiProbeLevel',2});
elseif strcmp(config.smatch.feature, 'AKAZE')
config.smatch.detector              = cv.AKAZE('Threshold', 1e-4);
config.smatch.matcher               = cv.DescriptorMatcher('BruteForce-Hamming');
% config.smatch.matcher               = cv.DescriptorMatcher('FlannBasedMatcher', 'Index',{'LSH', 'TableNumber',12, 'KeySize',20, 'MultiProbeLevel',2});
end

if ~config.tracking.arcore; config.smatch.apply = 1; end
if ~config.smatch.apply; config.opt.apply = 0; end