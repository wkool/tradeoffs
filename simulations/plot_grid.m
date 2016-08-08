function plot_grid(data)

% Function that plots a surface plot of the linear relationship between
% model-based control and reward rate in a two-step task across a range of 
% the reinforcement learning parameters inverse temperature and learning 
% rate. Most figures reported in Kool, Cushman, & Gershman (2016) were
% created using this function.
%
% USAGE: plot_grid(data), with data the output of the wrapper.m function.
%
% Wouter Kool, Aug 2016

figure;
surface(data.lrs,data.bs,mean(data.slope,3));
caxis([-0.05 0.6]);
zlim([-0.05 0.6]);
colormap('jet');
xlabel('Learning rate');
ylabel('Inverse temperature');
zlabel('Standardized linear effect of w on reward');
c=colorbar;
% c.Label.String='Standardized linear effect of w on reward';

view(-33,22);

end

