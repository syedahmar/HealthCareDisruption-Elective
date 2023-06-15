%% Description
% Author: Syed Ahmar Shah
% ahmar.shah@ed.ac.uk
% June 15, 2023
% This script can be used to investigate the extent of healthcare disruption, and create projections on the number of people whon are waiting for elective treatment in hospitals
% The initial modelling is based on Referral to Treatment (RTT) data from
% NHS England
% Modify the value of percent_return (line 143) to adjust the percentage of missing who
% return) ; 
% Modify the value of percent_increase (line 154) to adjust the percentage increase in system capacity

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

figure,hold on,
plot(data.MonthYear(I_Pre),data.TotalWaitingmil_adjusted(I_Pre),'o');
% pre-pandemic
y_est_pre = polyval(model_WaitingList,x_Pre);
plot(data.MonthYear(I_Pre),y_est_pre,'-b','LineWidth',3);

% counterfactual (if pre-pandemic trend had continued)
post_start=156;
post_end=187;
I_post=post_start:post_end;
x_Post=(1:length(I_post))+x_Pre(end);
[y_est_post, y_est_post_error]= polyval(model_WaitingList,x_Post,error_WaitingList);
plot(data.MonthYear(I_post),y_est_post,'-g','LineWidth',3); 

% intermediate step of showing counterfactuals with 95% CI interval
% plot(data.MonthYear(I_post),y_est_post+2*y_est_post_error,'m--',data.MonthYear(I_post),y_est_post-2*y_est_post_error,'m--','LineWidth',3); % error bounds
% legend('monthly waiting (raw data, pre-pandemic)','monthly waiting (modelled, pre-pandemic)','projected waiting (if no pandemic)','95% Confidence Interval')
% set(gca(),'FontSize',18)
% xlabel('Year');
% ylabel('Total Number of People Waiting (in Millions)'); grid on;

% actual waiting times
plot(data.MonthYear(I_post),data.TotalWaitingmil_adjusted(I_post),'-r','LineWidth',3);

legend('monthly waiting (raw data, pre-pandemic)','monthly waiting (modelled, pre-pandemic)','projected waiting (if no pandemic)','actual waiting during pandemic')
set(gca(),'FontSize',18)
xlabel('Year');
ylabel('Total Number of People Waiting (in Millions)'); grid on;


%% let us plot the system capacity figure
%%%%%%%%%%%%%%% System Capacity %%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure,hold on,
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
y_demand_baseline=polyval(model_SystemCapacity,x_Pre(end-2:end)) + model_WaitingList(1); % monthly treated + monthly rate of increase in waiting list
%y_demand_future=mean(y_demand_baseline)*ones(length(x_future_index),1);
y_demand_future=polyval(model_SystemCapacity,x_future_index) + model_WaitingList(1);

% MC (monthly coming - missing)
total_missing=round(total_missing_present);
percent_return=0.50; % proprtion of missing that may return
missing_peak=(total_missing*percent_return)/24;
y_missing=[linspace(0,missing_peak,12) ...
    ones(1,12)*missing_peak ...
    linspace(missing_peak,0,12)];
y_missing=y_missing';
y_missing=[y_missing;zeros(length(x_future_index)-length(y_missing),1)]; % append zero patients returning for any period beyond 3 years



%TT (total monthly treated)
percent_increase=10;
y_treated_start_mean = round(mean(data.Capacity(I_Pre(end-5:end))));
y_treated_start_std = round(std(data.Capacity(I_Pre(end-5:end))));
y_treated_start_lower = y_treated_start_mean - 1*y_treated_start_std;
y_treated_start_upper = y_treated_start_mean + 1*y_treated_start_std;

y_treated_start=y_treated_start_mean; 
y_treated_end = y_treated_start + y_treated_start*percent_increase/100;
y_treated=linspace(y_treated_start,y_treated_end,length(x_future_index));
y_treated=y_treated';

% TW (total waiting)
TW_0=data.TotalWaitingmilWithEstimatesForMissingData(end);
y_waiting=[TW_0; zeros(length(x_future_index)-1,1)];


%% Let's collect all variables and use x for exogenous variables and y for the response variable
load LearnedModel % found after excecuting GetModel
phi_1=EstMdl.AR{1}; % AR part component
beta_demand = EstMdl.Beta(2);
beta_treated = EstMdl.Beta(1);
error_std =  sqrt(EstMdl.Covariance);
% Monthly Demand (overall)
x_demand = y_missing + y_demand_future;
% Monthly Treated
x_treated = y_treated;
% white noise term
error_term = randn(length(x_treated),1).*sqrt(EstMdl.Covariance);


for n=1:(length(x_future_index))
    
    y_waiting(n+1,1) = phi_1*y_waiting(n)+beta_demand*x_demand(n)+...
    beta_treated*x_treated(n,1)+error_term(n);
end


plot(x_future_months,y_waiting(2:end,1),'LineWidth',3)
plot(x_future_months,y_waiting_lower(2:end,1),'m--','LineWidth',3)
plot(x_future_months,y_waiting_upper(2:end,1),'m--','LineWidth',3)

%projection if 30% capacity increase is achieved and only 50% missing return
% if 25-75% missing return

% plot remaining figures
figure,subplot(3,1,1),
plot(x_future_months,y_demand_future,'LineWidth',3)
grid on,
set(gca(),'FontSize',18)
title('baseline monthly demand')
subplot(3,1,2)
plot(x_future_months,y_missing,'LineWidth',3)
grid on,
set(gca(),'FontSize',18)
ylabel('Total Demand (in Millions)')
title('monthly demand from missing people')
subplot(3,1,3)
plot(x_future_months,x_demand,'LineWidth',3)
grid on,
set(gca(),'FontSize',18)
xlabel('Date (month year)');
title('total monthly demand')
