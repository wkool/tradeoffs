function groupdata = groupanalysis

% Function that constructs a variable with pre-processed behavioral data
% for the Daw two-step paradigm in Kool, Cushman, & Gershman (2016).
% 
% USAGE: groupdata = groupanalysis
% 
% FIELDS:
%   .subdata - Struct array with full behavioral dataset for each subject
%   .i - values that map pre-processed data vectors to associated full 
%       dataset in the subdata struct array
%   .r - Matrix that can be used for multi-level modeling in R. Columns
%       index following variables:
%           [sub_num previous_win previous_transition stay]
%   .rewardrate - reward rates for each participant
%   .avg_p - vector with average reward probability in reward distributions
%   .rewardrate_corrected - reward rates minus avg_p
%   .stayprobs - 'stay probabilities' used to construct Figure 16A. Columns
%       index following variables:
%           [common_x_win common_x_loss rare_x_win rare_x_loss]
%   .maineffect - main effect of previous win on staying behavior
%   .interaction - interaction of previous win and transition on staying
%       behavior
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

groupdata = make_raw_data;

nrsubs = length(groupdata.subdata);

s = 0;

groupdata.r = [];

for i = 1:nrsubs
    
    subdata = groupdata.subdata(i);
    
    if sum(subdata.missed) < 25
        
        s = s+1;
        groupdata.i(s,1) = i;
        
        groupdata.missed(s,1) = sum(subdata.missed);
        
        prevwin = subdata.prevwin(~(subdata.missed|subdata.prevmissed));
        prevcommon = subdata.prevcommon(~(subdata.missed|subdata.prevmissed));
        stay = subdata.stay(~(subdata.missed|subdata.prevmissed));
        
        groupdata.rewardrate(s,1) = mean(subdata.win(~subdata.missed));
        groupdata.avg_p(s,1) = mean(subdata.ps(:));
        groupdata.rewardrate_corrected(s,1) = groupdata.rewardrate(s,1)-groupdata.avg_p(s,1);
        
        groupdata.stayprobs(s,1) = mean(stay(prevwin&prevcommon));
        groupdata.stayprobs(s,2) = mean(stay(prevwin&~prevcommon));
        groupdata.stayprobs(s,3) = mean(stay(~prevwin&prevcommon));
        groupdata.stayprobs(s,4) = mean(stay(~prevwin&~prevcommon));
        
        groupdata.maineffect(s,1) = sum(groupdata.stayprobs(s,1:2))-sum(groupdata.stayprobs(s,3:4));
        groupdata.interaction(s,1) = sum(groupdata.stayprobs(s,[1,4]))-sum(groupdata.stayprobs(s,2:3));
        
        groupdata.r = [groupdata.r; s*ones(length(subdata.r),1) subdata.r];
        
    end
    
end

end

