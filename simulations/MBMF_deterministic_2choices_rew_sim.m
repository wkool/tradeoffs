function  output = MBMF_deterministic_2choices_rew_sim(x,rews)

% Mixed model-based / model-free simulation code for a task with
% deterministic transitions, two choices at the second level, and points \
% for the second-level bandits.
%
% USAGE: output = MBMF_deterministic_2choices_rew_sim(x,rews)
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
%   S - [N x 2] first and second level states
%
% Wouter Kool, Aug 2016, based on code written by Sam Gershman

% parameters
b = x(1);           % softmax inverse temperature
lr = x(2);          % learning rate
lambda = x(3);      % eligibility trace decay
w = x(4);           % mixing weight

% initialization
Qmf = zeros(2,2);
Q2 = zeros(2,2);            % Q(s,a): state-action value function for Q-learning
Tm = cell(2,1);
Tm{1} = [1 0; 0 1];        % transition matrix
Tm{2} = [1 0; 0 1];        % transition matrix
N = size(rews,1);
output.A = zeros(N,2);
output.R = zeros(N,1);
output.S = zeros(N,2);

% loop through trials
for t = 1:N
    
    s1 = ceil(rand*2);
    
    maxQ = max(Q2,[],2);                                            % optimal reward at second level
    Qmb = Tm{s1}'*maxQ;                                              % compute model-based value function
    
    Q = w*Qmb + (1-w)*Qmf(s1,:)';                              % mix TD and model value
    
    if rand < exp(b*Q(1))/sum(exp(b*Q))                             % make choice using softmax
        a(1) = 1;
    else
        a(1) = 2;
    end
    
    s2 = a(1);
    
    if rand < exp(b*Q2(s2,1))/sum(exp(b*Q2(s2,:)))                    % make choice using softmax and observe transition
        a(2) = 1;
    else
        a(2) = 2;
    end
    
    dtQ(1) = Q2(s2,a(2)) - Qmf(s1,a(1));                               % backup with actual choice (i.e., sarsa)
    Qmf(s1,a(1)) = Qmf(s1,a(1)) + lr*dtQ(1);                                % update TD value function
    
    dtQ(2) = rews(t,s2,a(2)) - Q2(s2,a(2));                                        % prediction error (2nd choice)
    
    Q2(s2,a(2)) = Q2(s2,a(2)) + lr*dtQ(2);                            % update TD value function
    Qmf(s1,a(1)) = Qmf(s1,a(1)) + lambda*lr*dtQ(2);                     % eligibility trace
    
    % store stuff
    output.A(t,:) = a;
    output.R(t,1) = rews(t,s2,a(2));
    output.S(t,:) = [s1 s2];
    
end

end
