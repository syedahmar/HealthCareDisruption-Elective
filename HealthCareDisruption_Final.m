%% Description
% Author: Syed Ahmar Shah
% ahmar.shah@ed.ac.uk
% June 15, 2023
% This script can be used to investigate the extent of healthcare disruption, and create projections on the number of people whon are waiting for elective treatment in hospitals
% The initial modelling is based on Referral to Treatment (RTT) data from
% NHS England
% Modify the value of percent_return (line 142) to adjust the percentage of missing who
% return) ; 
% Modify the value of percent_increase (line 145) to adjust the percentage increase in system capacity

%% clear workspace and load data
clc;clear all;
load RTT_October2022;

% pre-processing to ensure that the adjusted total waiting time is used
data.TotalWaitingmil_adjusted=data.TotalWaitingmilWithEstimatesForMissingData;

%% Pre-pandemic analysis (January 2012- February 2020)
% get growth and counterfactuals for the pandemic period

% pre-pandemic indices
pre_start=58; % corresponds to January 2012
pre_end=155; % corresponds to February 2020
I_Pre=(pre_start:pre_end); % indices to use for dataframe
x_Pre=1:length(I_Pre); % x_time to use for model fitting
% create a linear model for waiting list
[model_WaitingList, error_WaitingList]=polyfit(x_Pre,data.TotalWaitingmil_adjusted(I_Pre),1);

% create a linear model for system capacity
data.Capacity=data.NoOfPathwaysallWithEstimatesForMissingData+data.NoOfPathwaysallWithEstimatesForMissingData1;
[model_SystemCapacity, error_SystemCapacity]=polyfit(x_Pre,data.Capacity(I_Pre),1);

%% let us plot the waiting times figure with error estimates for counterfactuals
%%%%%%%%%%%%%%% Waiting Time %%%%%%%%%%%%%%%%%%%%%%%%%%%%
M1=1000000; % 1 million so that the y-axis is scaled accordingly
fw=figure;hold on,
plot(data.MonthYear(I_Pre),data.TotalWaitingmil_adjusted(I_Pre)./M1,'o');
% pre-pandemic
y_est_pre = polyval(model_WaitingList,x_Pre);
plot(data.MonthYear(I_Pre),y_est_pre./M1,'-b','LineWidth',3);

% counterfactual (if pre-pandemic trend had continued)
post_start=156;
post_end=187;
I_post=post_start:post_end;
x_Post=(1:length(I_post))+x_Pre(end);
[y_est_post, y_est_post_error]= polyval(model_WaitingList,x_Post,error_WaitingList);
%plot(data.MonthYear(I_post),y_est_post,'-g','LineWidth',3); 

% intermediate step of showing counterfactuals with 95% CI interval
% plot(data.MonthYear(I_post),y_est_post+2*y_est_post_error,'m--',data.MonthYear(I_post),y_est_post-2*y_est_post_error,'m--','LineWidth',3); % error bounds
% legend('monthly waiting (raw data, pre-pandemic)','monthly waiting (modelled, pre-pandemic)','projected waiting (if no pandemic)','95% Confidence Interval')
% set(gca(),'FontSize',18)
% xlabel('Year');
% ylabel('Total Number of People Waiting (in Millions)'); grid on;

% actual waiting times
plot(data.MonthYear(I_post),data.TotalWaitingmil_adjusted(I_post)./M1,'-r','LineWidth',3);

legend('monthly waiting (raw data, pre-pandemic)','monthly waiting (modelled, pre-pandemic)','actual waiting during pandemic')
set(gca(),'FontSize',18)
xlabel('Year');
ylabel('Total Number of People Waiting (in Millions)'); grid on;


%% let us plot the system capacity figure
%%%%%%%%%%%%%%% System Capacity %%%%%%%%%%%%%%%%%%%%%%%%%%%%
ft=figure;hold on,
plot(data.MonthYear(I_Pre),data.Capacity(I_Pre),'o');
% pre-pandemic
y_est_pre = polyval(model_SystemCapacity,x_Pre);
plot(data.MonthYear(I_Pre),y_est_pre,'-b','LineWidth',3);

% counterfactual (if pre-pandemic trend had continued)
[y_est_post, y_est_post_error]= polyval(model_SystemCapacity,x_Post,error_SystemCapacity);
plot(data.MonthYear(I_post),y_est_post,'-g','LineWidth',3);

% intermediate step of showing counterfactuals with 95% CI interval
% plot(data.MonthYear(I_post),y_est_post+2*y_est_post_error,'m--',data.MonthYear(I_post),y_est_post-2*y_est_post_error,'m--','LineWidth',3); % error bounds
% legend('monthly completed RTT (raw data, pre-pandemic)','monthly completed RTT (modelled, pre-pandemic)','projected monthly completed RTT (if no pandemic)','95% Confidence Interval')
% set(gca(),'FontSize',18)
% xlabel('Year');
% ylabel('Total Number of People Treated (in Millions)'); grid on;


% actual capacity
plot(data.MonthYear(I_post),data.Capacity(I_post),'-r','LineWidth',3);

legend('monthly completed RTT (raw data, pre-pandemic)','monthly completed RTT (modelled, pre-pandemic)','projected monthly completed RTT (if no pandemic)','actual monthly completed RTT during pandemic')
set(gca(),'FontSize',18)
xlabel('Year');
ylabel('Total Number of People Treated (in Millions)')

%% Estimate missting people - Updated using counter-factuals
pan_start=156; % indices of pandemic start (March 2020)
pan_end=187; % indices of pandemic end (October 2022)
I_Pan=(pan_start:pan_end);

[capacity_pandemic_counterfactual, capacity_counterfactual_error]= polyval(model_SystemCapacity,x_Post,error_SystemCapacity);
capacity_pandemic_actual = data.Capacity(I_Pan);
waiting_pandemic_actual = data.TotalWaitingmil_adjusted(I_Pan);
[waiting_pandemic_counterfactual,waiting_counterfactual_error] = polyval(model_WaitingList,x_Post,error_WaitingList);

waiting_from_missing = waiting_pandemic_actual(end)-waiting_pandemic_counterfactual(end);
total_missing = sum(capacity_pandemic_counterfactual) - sum(capacity_pandemic_actual);
total_missing_present = total_missing-waiting_from_missing;


%%%%%% let us also estimate the intervals

%%%lower bound
std_err=2;
waiting_from_missing = waiting_pandemic_actual(end)-(waiting_pandemic_counterfactual(end)+std_err*waiting_counterfactual_error(end));
total_missing = sum(capacity_pandemic_counterfactual-std_err*capacity_counterfactual_error) - sum(capacity_pandemic_actual);
total_missing_present_lower = total_missing-waiting_from_missing;

%%%upper bound
waiting_from_missing = waiting_pandemic_actual(end)-(waiting_pandemic_counterfactual(end)-std_err*waiting_counterfactual_error(end));
total_missing = sum(capacity_pandemic_counterfactual+std_err*capacity_counterfactual_error) - sum(capacity_pandemic_actual);
total_missing_present_upper = total_missing-waiting_from_missing;

%% Projections

% create future time vector

t_2022 = datetime(2022,11:12,1);
t_2023 = datetime(2023,1:12,1);
t_2024 = datetime(2024,1:12,1);
t_2025 = datetime(2025,1:10,1);
x_future_months=[t_2022'; t_2023'; t_2024'; t_2025'];
x_future_index=(x_Post(end)+1):(x_Post(end)+size(x_future_months,1));
x_future_index=x_future_index';


% MD (monthly demand)
% assume monthly demand stay constant (with baseline at the start of pandemic)
%y_demand_baseline=polyval(model_SystemCapacity,x_Pre(end-2:end)) + model_WaitingList(1); % monthly treated + monthly rate of increase in waiting list
y_demand_future=polyval(model_SystemCapacity,x_future_index) + model_WaitingList(1);

% MC (monthly coming - missing)
percent_return=0.50;
shape_missing=2; % 1 for using triangular, 2 for using peak and then linear drop shape
y_missing=get_y_missing(total_missing_present,percent_return,length(x_future_index),shape_missing);
percent_increase=20; % percent increase in system capacity

% get percentiles for all estimates
num_sim = 1000; % number of simulations
y_waiting_global=zeros(num_sim,36);
for kl=1:num_sim
    disp(['Processing loop number: ',num2str(kl)]);
    Get_Projections
    y_waiting_global(kl,:)=y_waiting(13:end)';
end


