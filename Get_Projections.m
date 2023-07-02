%TT (total monthly treated)
y_treated_start_mean = round(mean(data.Capacity(I_Pre(end-5:end))));
y_treated_start_std = round(std(data.Capacity(I_Pre(end-5:end))));
y_treated_start_lower = y_treated_start_mean - 1*y_treated_start_std;
y_treated_start_upper = y_treated_start_mean + 1*y_treated_start_std;

y_treated_start=y_treated_start_mean; 
y_treated_end = y_treated_start + y_treated_start*percent_increase/100;
y_treated=linspace(y_treated_start,y_treated_end,length(x_future_index));
y_treated=y_treated';

% TW (total waiting)
TW_Pre=data.TotalWaitingmilWithEstimatesForMissingData(end)*ones(12,1); %from n=-11 to n=0, assume that the total waiting is whatever the value at the end from the pandemic period is
y_waiting=[TW_Pre; zeros(length(x_future_index)-1,1)]; % from n -11 to 36 (36 months of projections)



%% Let's collect all variables and use x for exogenous variables and y for the response variable
load LearnedModel_final % found after excecuting GetModel
phi_1=EstMdl.AR{1}; % AR(1) part component
phi_12=EstMdl.AR{12}; % AR(12) part component
beta_demand = EstMdl.Beta(2);
beta_treated = EstMdl.Beta(1);
model_constant = EstMdl.Constant;
error_std =  sqrt(EstMdl.Covariance);
% Monthly Demand (overall)
x_demand = y_missing + y_demand_future;
% Monthly Treated
x_treated = y_treated;
% white noise term
error_term = randn(length(x_treated),1).*sqrt(EstMdl.Covariance);


for n=1:(length(x_future_index))
    
    y_waiting(n+12,1) = phi_1*y_waiting(n+11)+beta_demand*x_demand(n)+...
    beta_treated*x_treated(n,1)+error_term(n)+phi_12*y_waiting(n)+...
    model_constant;
end
