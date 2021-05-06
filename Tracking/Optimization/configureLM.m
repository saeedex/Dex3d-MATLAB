function [BAConfig, config] = configureLM(BAConfig, config)
%% LM parameters
BAConfig.ctrl.epsilon       = [10^-8 10^-8 10^-8 10^-9]; 
BAConfig.ctrl.kmax          = 10;
BAConfig.ctrl.tau           = 10^-2;
BAConfig.ctrl.v             = 10;
BAConfig.ctrl.stop          = 0;
BAConfig.ctrl.ro            = -1;
BAConfig.ctrl.display       = config.opt.display;

%% Initialize BA Variables
if strcmp(config.opt.scheme,'interleaved'); config.opt.var.str  = 0; end
if strcmp(config.opt.solver, 'builtin');    config.opt.var.str  = 0; end
if strcmp(config.opt.solver, 'IDSR');       config.opt.var.str  = 0; end
if strcmp(config.opt.solver, 'IDSRLBA1');   config.opt.var.str  = 1; config.opt.var.pos = 1; end
if strcmp(config.opt.solver, 'IDSRLBA2');   config.opt.var.str  = 0; config.opt.var.pos = 1; config.opt.var.cam = 0; end
BAConfig.clength            = 0;
BAConfig.plength            = 0;
BAConfig.slength            = 0;
BAConfig.p                  = [];

if config.opt.var.cam
BAConfig.clength            = BAConfig.clength + 4;    
BAConfig.p                  = [BAConfig.p zeros(1,BAConfig.clength)];
end

if config.opt.var.pos
BAConfig.plength            = BAConfig.plength + 6;
BAConfig.p                  = [BAConfig.p zeros(1,BAConfig.plength*length(BAConfig.poses))];
end

if config.opt.var.str
BAConfig.slength            = 3*length(BAConfig.tracks);
BAConfig.p                  = [BAConfig.p zeros(1,BAConfig.slength)]; 
end


