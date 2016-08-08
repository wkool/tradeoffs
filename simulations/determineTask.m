function data = determineTask

% This function is used to determine which simulation code should be used
% given the type of two-step task that the user wants to analyze.
%
% Wouter Kool, August 2016

bounds = [];
while (isempty(bounds)) || (bounds~=1&&bounds~=2)
    bounds = input('Narrow ([.25 .75]; press 1) or broad ([0 1]; press 2) range of the reward distribution?  ');
end

if bounds == 1
    bounds = [0.25 0.75];
else
    bounds = [0 1];
end

sd = [];
while (isempty(sd)) || (sd<=0)
    sd = input('Drift rate of the reward distribution (>0)?  ');
end

structure = [];
while (isempty(structure)) || (structure~=1&&structure~=2)
    structure = input('Stochastic (1) or deterministic (2) task structure? ');
end

choices = [];
while (isempty(choices)) || (choices~=1&&choices~=2)
    choices = input('One or two second-level choices?  ');
end

rewards = [];
while (isempty(rewards)) || (rewards~=1&&rewards~=2)
    rewards = input('Reward probabilities (1) or points (2) for the second-level choices?  ');
end

simulationfunction = 'MBMF_';
if structure == 1
    simulationfunction = [simulationfunction, 'stochastic_'];
else
    simulationfunction = [simulationfunction, 'deterministic_'];
end
if choices == 1
    simulationfunction = [simulationfunction, '1choice_'];
else
    simulationfunction = [simulationfunction, '2choices_'];
end
if rewards == 1
    simulationfunction = [simulationfunction, 'p_sim'];
else
    simulationfunction = [simulationfunction, 'rew_sim'];
end

data.simulationfunction = simulationfunction;
data.bounds = bounds;
data.sd = sd;
data.choices = choices;

end