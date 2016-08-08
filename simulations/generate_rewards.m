function rewards = generate_rewards(nrtrials,bounds,sd,choices)

% This function generates reward distributions with random Gaussian walks
% for a certain number of trials (nrtrials). The reward distributions will
% have reflecting bounds as determined by the variable bounds, a drift rate
% of sd. Each reward distribution has two states, and 1 or 2 actions at
% each state as determined by the input variable choices.
%
% Wouter Kool, August 2016

bounds = sort(bounds);

rewards = zeros(nrtrials,2,choices);

if rand < .5
    if rand < .5
        x = [0.6 0.4];
    else
        x = [0.4 0.6];
    end
    if choices == 2
        if rand < .5
            x = [x; [0.25, 0.75]];
        else
            x = [x; [0.75, 0.25]];
        end
    end
else
    if rand < .5
        x = [0.4, 0.6];
    else
        x = [0.6, 0.4];
    end
    if choices == 2
        if rand < .5
            x = [[0.25 .75]; x];
        else
            x = [[0.75 0.25]; x];
        end
    end
end

rewards(1,:,:) = x;

for t = 2:nrtrials
    for s = 1:2
        for a = 1:choices
            rewards(t,s,a) = rewards(t-1,s,a)+normrnd(0,sd);
            rewards(t,s,a) = min(rewards(t,s,a),max(bounds(2)*2 - rewards(t,s,a), bounds(1)));
            rewards(t,s,a) = max(rewards(t,s,a),min(bounds(1)*2 - rewards(t,s,a), bounds(2)));
        end
    end
end