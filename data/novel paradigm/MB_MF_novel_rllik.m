function  LL = MB_MF_novel_rllik(x,subdata,opts)

% Likelihood function for novel two-step paradigm in Kool, Cushman, &
% Gershman (2016).
%
% Depending on opts, the function reflects either a full hybrid model (opts.model = 1),
% a fully model-based model (opts.model = 2), or a model-free model
% (opts.model = 3). The fields opts.st and opts.respst determine the
% inclusion of stickiness parameters.
%
% Wouter Kool, Aug 2016

y = zeros(1,6);
y(opts.ix==1) = x;

switch opts.model
    case 2   
        y(4) = 1;
    case 3
        y(4) = 0;
end
if ~opts.st
    y(5) = 0;
end
if ~opts.respst
    y(6) = 0;
end

% parameters
b = y(1);           % softmax inverse temperature
lr = y(2);          % learning rate
lambda = y(3);      % eligibility trace decay
w = y(4);           % mixing weight
st = y(5);          % stimulus stickiness
respst = y(6);      % response stickiness

% initialization
Qmf = zeros(2,2);               % Q(s,a): First-stage state-action values
Q2 = zeros(2,1);                % Q(s,a): Second-stage state-action values
Tm = cell(2,1);
Tm{1} = [.5 .5; .5 .5];         % transition matrix s1=1
Tm{2} = [.5 .5; .5 .5];         % transition matrix s1 = 2
M = [0 0; 0 0];                 % last choice structure
R = [0; 0];                     % last choice structure
N = size(subdata.choice1);
LL = 0;

Tmchanged(1) = 0;
Tmchanged(2) = 0;

% loop through trials
for t = 1:N
    
    if (subdata.rt1(t) == -1 || subdata.rt2(t) == -1)               % skip trial if timed out
        continue
    end
    
    if (subdata.stim_left(t) == 2) || (subdata.stim_left(t) == 4)
        R = flipud(R);                                              % arrange R to reflect stimulus mapping
    end
        
    s1 = subdata.state1(t);
    s2 = subdata.state2(t);
    a = subdata.choice1(t);
    action = a;
    a = a - (s1 == 2)*(2);
    
    Qmb = Tm{s1}'*Q2;                                               % compute model-based value function

    Q = w*Qmb + (1-w)*Qmf(s1,:)' + st.*M(s1,:)' + respst.*R;        % mix TD and model-based value
    
    LL = LL + b*Q(a) - logsumexp(b*Q);                              % update likelihoods
    
    if ~Tmchanged(1) && s1 == 1                                     % after one observation
        Tmchanged(1) = 1;                                           % agent realizes transition structure
        Tm{1} = [1 0; 0 1];
    end

    if ~Tmchanged(2) && s1 == 2
        Tmchanged(2) = 1;
        Tm{2} = [1 0; 0 1];
    end
    
    M = zeros(2,2);
    M(s1,a) = 1;                                                    % make the last choice sticky
    
    R = zeros(2,1);
    if action == subdata.stim_left(t)
        R(1) = 1;                                                   % make the last response sticky
    else
        R(2) = 1;
    end 
    
    dtQ(1) = Q2(s2) - Qmf(s1,a);                                    % backup with actual choice (i.e., sarsa)
    Qmf(s1,a) = Qmf(s1,a) + lr*dtQ(1);                              % update TD value function
    
    dtQ(2) = subdata.points(t) - Q2(s2);                            % prediction error (2nd choice)
    
    Q2(s2) = Q2(s2) + lr*dtQ(2);                                    % update TD value function
    Qmf(s1,a) = Qmf(s1,a) + lambda*lr*dtQ(2);                       % eligibility trace
    
end