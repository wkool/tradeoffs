function  output = MBMF_deterministic_1choice_p_sim(x,P)

% Mixed model-based / model-free simulation code for a task with
% deterministic transitions, one choice at the second level, and reward 
% probabilities for the second-level bandits
%
% USAGE: output = MBMF_deterministic_1choice_p_sim(x,rews)
%
% INPUTS:
%   x - [1 x 4] vector of parameters, where:
%       x(1) - softmax inverse temperature
%       x(2) - learning rate
%       x(3) - eligibility trace decay
%       x(4) - mixing weight
%   P - [N x 2] array storing the rewards, where
%       P(n,s,a) is the probability of observing a binary reward on trial n
%       in second-step state s, where N is the
%       number of trials
%
% OUTPUTS:
%   output.A - [N x 1] chosen actions at first and second steps
%   R - [N x 1] second level rewards
%   S - [N x 2] first and second level states
%
% Wouter Kool, Aug 2016, based on code written by Sam Gershman

% parameters
b = x(1);                   % softmax inverse temperature
lr = x(2);                  % learning rate
lambda = x(3);              % eligibility trace decay
w = x(4);                   % mixing weight

% initialization
Qmf = zeros(2,2);
Q2 = zeros(2,1);            % Q(s,a): state-action value function for Q-learning
Tm = cell(2,1);
Tm{1} = [1 0; 0 1];         % transition matrix
Tm{2} = [1 0; 0 1];         % transition matrix
N = size(P,1);
output.A = zeros(N,1);
output.R = zeros(N,1);
output.S = zeros(N,2);

% loop through trials
for t = 1:N
    
    s1 = ceil(rand*2);
    
    Qmb = Tm{s1}'*Q2;                                          % compute model-based value function

    Q = w*Qmb + (1-w)*Qmf(s1,:)';                              % mix TD and model value
    
    if rand < exp(b*Q(1))/sum(exp(b*Q))                        % make choice using softmax
        a = 1;
    else
        a = 2;
    end
    
    s2 = a;
    
    dtQ(1) = Q2(s2) - Qmf(s1,a);                               % backup with actual choice (i.e., sarsa)
    Qmf(s1,a) = Qmf(s1,a) + lr*dtQ(1);                         % update TD value function
    
    r = rand < P(t,s2);                                        % sample reward
    dtQ(2) = r - Q2(s2);                                       % prediction error (2nd choice)
    
    Q2(s2) = Q2(s2) + lr*dtQ(2);                               % update TD value function
    Qmf(s1,a) = Qmf(s1,a) + lambda*lr*dtQ(2);                  % eligibility trace
    
    % store stuff
    output.A(t,1) = a;
    output.R(t,1) = r;
    output.S(t,:) = [s1 s2];

end

end