function results = mfit_wrapper

% Function that fits behavioral data to reinforcement learning models
% for the Daw two-step paradigm in Kool, Cushman, & Gershman (2016).
% 
% USAGE: results = mfit_wrapper
%
% NOTES:
%   This function requires the mfit model-fitting package: https://github.com/sjgershm/mfit
%
% Wouter Kool, Aug 2016

load groupdata

opts.model = [1 2 3]; % 1 = hybrid model, 2 = model-based 3 = model-free
opts.st = [0 1]; % indexes presence of stimulus stickiness
opts.respst = [0 1]; % indexes presence of response stickiness
opts = factorial_models(opts);

nrstarts = 1;
nrmodels = length(opts);

data = groupdata.subdata(groupdata.i);

results = struct;

% run optimization
for m = 1:nrmodels
    
    disp(['Fitting model ',num2str(m)])
    [options, params] = set_opts(opts(m));
    f = @(x,data) MB_MF_daw_rllik(x,data,options);
    results(m) = mfit_optimize(f,params,data,nrstarts);
    
    results(m).opts = opts(model);
    
end

end
