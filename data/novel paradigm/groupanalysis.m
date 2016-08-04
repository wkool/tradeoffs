function groupdata = groupanalysis

% Function that constructs a variable with pre-processed behavioral data
% for the novel two-step paradigm in Kool, Cushman, & Gershman (2016).
% 
% USAGE: groupdata = groupanalysis
% 
% FIELDS:
%   .subdata - Struct array with full behavioral dataset for each subject
%   .i - values that map pre-processed data vectors to associated full 
%       dataset in the subdata struct array
%   .r - Matrix that can be used for multi-level modeling in R. Columns
%       index following variables:
%           [sub_num previous_points startstate_similarity diff_chosen_unchosen_points stay]
%   .rewardrate - reward rates for each participant
%   .avg_rew - vector with average reward in reward distributions
%   .rewardrate_corrected - reward rates minus avg_rew
%   .stayprobs - 'stay probabilities' used to construct Figure 16B. Columns
%       index following variables:
%           [prev_rew_x_s1_same prev_punish_x_s1_same prev_punish_x_s1_diff prev_rew_x_s1_diff]
%
% NOTES:
%
%   1. This variable is needed for the maximum a posteriori model-fitting
%   procedure in mfit_wrapper.m
%
%   2. This function does not analyze data for participants with more than
%   25 missed trials (>20% of all trials).
%
% Wouter Kool, Aug 2016

groupdata = make_raw_data(150);

nrsubs = length(groupdata.subdata);

groupdata.r = [];

s = 0;

for i = 1:nrsubs
    
    subdata = groupdata.subdata(i);
    
    if sum(subdata.missed) < 25
        
        s=s+1;
        groupdata.i(s,1) = i;
        
        groupdata.missed(s,1) = sum(subdata.missed);
        
        prevwin = subdata.prevwin(~(subdata.missed|subdata.prevmissed));
        same = subdata.same(~(subdata.missed|subdata.prevmissed));
        stay = subdata.stay(~(subdata.missed|subdata.prevmissed));
        
        groupdata.rewardrate(s,1) = mean(subdata.points(~subdata.missed));
        groupdata.avg_rew(s,1) = mean(subdata.rews(:));
        groupdata.rewardrate_corrected(s,1) = groupdata.rewardrate(s)-groupdata.avg_rew(s);
        
        groupdata.stayprobs(s,1) = mean(stay(same&prevwin));
        groupdata.stayprobs(s,2) = mean(stay(same&~prevwin));
        groupdata.stayprobs(s,3) = mean(stay(~same&prevwin));
        groupdata.stayprobs(s,4) = mean(stay(~same&~prevwin));
        
        groupdata.r = [groupdata.r; s*ones(length(subdata.r),1) subdata.r];
                
    end
    
end

end

