function groupdata = make_raw_data(nrtrials_full)

% Function that constructs a variable with full behavioral data for each
% participant that completed the novel two-step paradigm in Kool, Cushman, & Gershman (2016).
% 
% NOTE: There is no need to call this function individually.
%
% Wouter Kool, Aug 2016

load('data.mat');
load('subinfo.mat');

s = 0;

% indices that map columns in data.mat to relevant variables
state1_i = 1;
stim_left_i = 2;
stim_right_i = 3;
rt1_i = 4;
choice1_i = 5;
rt2_i = 6;
points_i = 7;
state2_i = 8;
score_i = 9;
practice_i = 10;
rews1_i = 11;
rews2_i = 12;
trial_i = 13;
% time_elapsed_i = 14;

for i = 1:length(subinfo)
        
    if sum(strcmp(subinfo(i,1),data(:,1))) >= nrtrials_full %#ok<NODEF> % complete dataset
        
        s = s + 1;

        subdata = cell2mat(data(strcmp(subinfo(i,1),data(:,1)),2:15));
        subdata(subdata(:,practice_i)==1,:)=[]; % discard the practice trials
    
        %% storing data from data.mat
        groupdata.subdata(s).state1 = subdata(:,state1_i);          % first-stage state
        groupdata.subdata(s).stim_left = subdata(:,stim_left_i);    % stimulus presented on left
        groupdata.subdata(s).stim_right = subdata(:,stim_right_i);  % stimulus presented on right
        groupdata.subdata(s).rt1 = subdata(:,rt1_i);                % reaction time for first-stage choice
        groupdata.subdata(s).choice1 = subdata(:,choice1_i);        % first-stage choice
        groupdata.subdata(s).rt2 = subdata(:,rt2_i);                % reaction time for second-stage response
        groupdata.subdata(s).state2 = subdata(:,state2_i);          % second stage state
        groupdata.subdata(s).points = subdata(:,points_i);          % number of points won
        groupdata.subdata(s).win = subdata(:,points_i)>0;           % 1 if points > 0, if not
        groupdata.subdata(s).score = subdata(:,score_i);            % current score
        groupdata.subdata(s).practice = subdata(:,practice_i);      % 1 if practice trial, 0 if not
        groupdata.subdata(s).rews(:,1) = subdata(:,rews1_i);        % reward distribution for s2 = 1
        groupdata.subdata(s).rews(:,2) = subdata(:,rews2_i);        % reward distribution for s2 = 2
        groupdata.subdata(s).trial = subdata(:,trial_i);            % trial number
        groupdata.subdata(s).N = length(subdata(:,trial_i));        % number of trials
        
        %% variables for behavioral analysis
        groupdata.subdata(s).missed = (subdata(:,rt1_i) == -1 | subdata(:,rt2_i) == -1);                                % indicates time-out  
        groupdata.subdata(s).prevmissed = [1; groupdata.subdata(s).missed(1:(length(groupdata.subdata(s).missed)-1))];  % indicates time-out on previous trial
        groupdata.subdata(s).prevstate1 = [0; groupdata.subdata(s).state1(1:(length(groupdata.subdata(s).state1)-1))];  % first-stage state on previous trial
        groupdata.subdata(s).prevstate2 = [0; groupdata.subdata(s).state2(1:(length(groupdata.subdata(s).state2)-1))];  % second-stage state on previous trial
        groupdata.subdata(s).prevwin = [-1; groupdata.subdata(s).win(1:(length(groupdata.subdata(s).win)-1))];          % > 0 points on previous trial
        groupdata.subdata(s).same = double(groupdata.subdata(s).prevstate1 == groupdata.subdata(s).state1);             % are current and previous first-stage state similar
        groupdata.subdata(s).stay = double(groupdata.subdata(s).prevstate2 == groupdata.subdata(s).state2);             % repeated second-stage state?
        
        %% constructing matrix for multi-level analysis in R
        nrtrials = length(groupdata.subdata(s).missed);
        missed = groupdata.subdata(s).missed;
        prevmissed = groupdata.subdata(s).prevmissed;
        skip = missed|prevmissed;
        
        same = groupdata.subdata(s).same;
        same(skip) = [];
        same(same==0) = -1;

        stay = groupdata.subdata(s).stay;
        stay(stay==0) = -1;
        stay(skip) = [];
        
        prevrews = [0 0; groupdata.subdata(s).rews(1:(nrtrials-1),:)];
        prevchosen = groupdata.subdata(s).prevstate2;
        prevunchosen = zeros(length(prevchosen),1);
        prevunchosen(prevchosen==1) = 2;
        prevunchosen(prevchosen==2) = 1;
        prevunchosen(skip) = [];
        prevchosen(skip) = [];
        prevrews(skip,:) = [];
        diff = prevrews(sub2ind(size(prevrews),(1:length(prevchosen))',prevchosen))-prevrews(sub2ind(size(prevrews),(1:length(prevunchosen))',prevunchosen));
        
        prevpoints = [0; groupdata.subdata(s).points(1:(nrtrials-1))];
        prevpoints(skip) = [];
        
        r = [prevpoints same diff stay];        
        
        groupdata.subdata(s).r = r;
        
    end
end

end
