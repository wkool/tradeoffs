function [opts, param] = set_opts(opts)

% Code that sets up different options, and empirical priors for model-fitting
% procedure of novel two-step paradigm in Kool, Cushman, & Gershman (2016).
% Parameters of the prior are chosen after Gershman (2016).
%
% Wouter Kool, Aug 2016

opts.ix = ones(1,6);

if ~(opts.model==1), opts.ix(4) = 0; end
if ~opts.st, opts.ix(5) = 0; end
if ~opts.respst, opts.ix(6) = 0; end

% create parameter structure
g = [4.82 0.88];  % parameters of the gamma prior
param(1).name = 'inverse temperature';
param(1).logpdf = @(x) sum(log(gampdf(x,g(1),g(2))));  % log density function for prior
param(1).lb = 0;   % lower bound
param(1).ub = 20;  % upper bound

param(2).name = 'learning rate';
param(2).logpdf = @(x) 0;
param(2).lb = 0;
param(2).ub = 1;

param(3).name = 'eligibility trace decay';
param(3).logpdf = @(x) 0;
param(3).lb = 0;
param(3).ub = 1;

param(4).name = 'mixing weight';
param(4).logpdf = @(x) 0;
param(4).lb = 0;
param(4).ub = 1;

mu = 0.15; sd = 1.42;   % parameters of choice stickiness
param(5).name = 'choice stickiness';
param(5).logpdf = @(x) sum(log(normpdf(x,mu,sd)));
param(5).lb = -20;
param(5).ub = 20;

mu = 0.15; sd = 1.42;    % parameters of response stickiness
param(6).name = 'response stickiness';
param(6).logpdf = @(x) sum(log(normpdf(x,mu,sd)));
param(6).lb = -20;
param(6).ub = 20;

param = param(opts.ix==1);

end
