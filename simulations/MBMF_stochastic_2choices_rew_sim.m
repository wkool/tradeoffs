function output = MBMF_stochastic_2choices_rew_sim(x,rews)

% Mixed model-based / model-free simulation code for a task with stochastic
% transitions, two choices at the second level, and points for the
% second-level bandits.
%
% USAGE: output = MBMF_stochastic_2choices_rew_sim(x,rews)
%
% INPUTS:
%   x - [1 x 4] vector of parameters, where:
%       x(1) - softmax inverse temperature
%       x(2) - learning rate
%       x(3) - eligibility trace decay
%       x(4) - mixing weight
%   rews - [N x 2 x 2] array storing the rewards, where
%       rews(n,s,a) is the payoff on trial n in second-level state s after 
%       taking action a, where N is the number of trials
%
% OUTPUTS:
%   output.A - [N x 2] chosen actions at first and second levels
%   R - [N x 1] second level rewards
%   S - [N x 1] second level states
%
% Wouter Kool, Aug 2016, based on code written by Sam Gershman

% parameters
b = x(1);               % softmax inverse temperature
lr = x(2);              % learning rate
lambda = x(3);          % eligibility trace decay
w = x(4);               % mixing weight

tr = 0.7;               % common transition probability

% initialization
Qd = zeros(3,2);        % Q(s,a): state-action value function for Q-learning
Tm = [.3 .7; .7 .3];    % transition matrix
N = size(rews,1);
output.A = zeros(N,2);
output.R = zeros(N,1);
output.S = zeros(N,1);
output.C = zeros(N,1);

% loop through trials
for t = 1:N
    
    maxQ = max(Qd(2:3,:),[],2);                                     % optimal reward at second level
    Qm = Tm'*maxQ;                                                  % compute model-based value function
    
    tr_prob = rand;
    
    Q = w*Qm + (1-w)*Qd(1,:)';                                      % mix TD and model value
    if rand < exp(b*Q(1))/sum(exp(b*Q))                             % make choice using softmax
        a(1) = 1;
        s = round(double(tr_prob<tr))+2;
    else
        a(1) = 2;
        s = round(double(tr_prob>tr))+2;
    end
    
    if rand < exp(b*Qd(s,1))/sum(exp(b*Qd(s,:)))                    % make choice using softmax and observe transition
        a(2) = 1;
    else
        a(2) = 2;
    end
    
    dtQ(1) = Qd(s,a(2)) - Qd(1,a(1));                               % backup with actual choice (i.e., sarsa)
    Qd(1,a(1)) = Qd(1,a(1)) + lr*dtQ(1);                            % update TD value function
    
    r = rews(t,s-1,a(2));                                           % sample reward
    dtQ(2) = r - Qd(s,a(2));                                        % prediction error (2nd choice)
    
    Qd(s,a(2)) = Qd(s,a(2)) + lr*dtQ(2);                            % update TD value function
    Qd(1,a(1)) = Qd(1,a(1)) + lambda*lr*dtQ(2);                     % eligibility trace
    
    % store stuff
    output.A(t,:) = a;
    output.R(t,1) = r;
    output.S(t,1) = s-1;
    output.C(t,1) = tr_prob<tr;
    
end

end
