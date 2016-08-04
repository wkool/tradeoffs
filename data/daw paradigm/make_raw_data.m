function groupdata = make_raw_data

% Function that constructs a variable with full behavioral data for each
% participant that completed the Daw two-step paradigm in Kool, Cushman, & Gershman (2016).
% 
% NOTE: There is no need to call this function individually.
%
% Wouter Kool, Aug 2016

nrtrials_full = 150;

load('data.mat');
load('subinfo.mat');

s = 0;

% indices that map columns in data.mat to relevant variables
stim_1_left_i = 1;
stim_1_right_i = 2;
rt_1_i = 3;
choice1_i = 4;
stim_2_left_i = 5;
stim_2_right_i = 6;
rt_2_i = 7;
choice2_i = 8;
win_i = 9;
state2_i = 10;
common_i = 11;
score_i = 12;
practice_i = 13;
ps1a1_i = 14;
ps1a2_i = 15;
ps2a1_i = 16;
ps2a2_i = 17;
trial_i = 18;

for i = 1:length(subinfo)
    
    if sum(strcmp(subinfo(i,1),data(:,1))) == nrtrials_full %#ok<NODEF> % complete dataset
        
        s = s + 1;
        
        subdata = cell2mat(data(strcmp(subinfo(i,1),data(:,1)),2:19));
        subdata(subdata(:,practice_i)==1,:)=[]; % discard the practice trials
        
        %% storing data from data.mat
        
        groupdata.subdata(s).stim_1_left = subdata(:,stim_1_left_i);    % first-stage stimulus presented on left
        groupdata.subdata(s).stim_1_right = subdata(:,stim_1_right_i);  % first-stage stimulus presented on right
        groupdata.subdata(s).rt1 = subdata(:,rt_1_i);                   % reaction time for first-stage choice
        groupdata.subdata(s).choice1 = subdata(:,choice1_i);            % first-stage choice
        groupdata.subdata(s).stim_2_left = subdata(:,stim_2_left_i);    % second-stage stimulus presented on left
        groupdata.subdata(s).stim_2_right = subdata(:,stim_2_right_i);  % second-stage stimulus presented on right
        groupdata.subdata(s).rt2 = subdata(:,rt_2_i);                   % reaction time for second-stage choice
        groupdata.subdata(s).choice2 = subdata(:,choice2_i);            % second-stage choice
        groupdata.subdata(s).win = subdata(:,win_i)>0;                  % 1 if a points was won
        groupdata.subdata(s).state2 = subdata(:,state2_i);              % second-stage state
        groupdata.subdata(s).common = subdata(:,common_i);              % transition type
        groupdata.subdata(s).score = subdata(:,score_i);                % current score
        groupdata.subdata(s).practice = subdata(:,practice_i);          % 1 if practice trial, 0 if not
        groupdata.subdata(s).ps1a1 = subdata(:,ps1a1_i);                % win probabilities for second-stage states and actions
        groupdata.subdata(s).ps1a2 = subdata(:,ps1a2_i);    
        groupdata.subdata(s).ps2a1 = subdata(:,ps2a1_i);
        groupdata.subdata(s).ps2a2 = subdata(:,ps2a2_i);
        groupdata.subdata(s).trial = subdata(:,trial_i);                % trial number
        groupdata.subdata(s).N = length(subdata(:,trial_i));            % number of trials
        
        %% variables for behavioral analysis
        groupdata.subdata(s).missed = (subdata(:,rt_1_i) == -1 | subdata(:,rt_2_i) == -1);                                                          % indicates time-out
        groupdata.subdata(s).prevmissed = [1; groupdata.subdata(s).missed(1:(length(groupdata.subdata(s).missed)-1))];                              % time-out on previous trial
        groupdata.subdata(s).prevwin = [-1; groupdata.subdata(s).win(1:(length(groupdata.subdata(s).win)-1))];                                      % point won on previous trial
        groupdata.subdata(s).prevcommon = [-1; groupdata.subdata(s).common(1:(length(groupdata.subdata(s).common)-1))];                             % transition type on previous trial
        groupdata.subdata(s).prevchoice1 = [-1; groupdata.subdata(s).choice1(1:(length(groupdata.subdata(s).choice1)-1))];                          % first-stage choice on previous trial
        groupdata.subdata(s).stay = double(groupdata.subdata(s).prevchoice1 == groupdata.subdata(s).choice1);                                       % repeated first-stage choice?
        groupdata.subdata(s).ps = [groupdata.subdata(s).ps1a1 groupdata.subdata(s).ps1a2 groupdata.subdata(s).ps2a1 groupdata.subdata(s).ps2a2];    % all reward probabilities

        %% constructing matrix for multi-level analysis in R
        missed = groupdata.subdata(s).missed;
        prevmissed = groupdata.subdata(s).prevmissed;
        skip = missed|prevmissed;
        
        stay = groupdata.subdata(s).stay;
        stay(skip) = [];
        stay(stay==0) = -1;
        
        prevwin = groupdata.subdata(s).prevwin;
        prevwin(skip) = [];
        prevwin(prevwin==0) = -1;
        
        prevcommon = groupdata.subdata(s).prevcommon;
        prevcommon(skip) = [];
        prevcommon(prevcommon==0) = -1;
        
        groupdata.subdata(s).r = [prevwin prevcommon stay];
        
    end
    
end

