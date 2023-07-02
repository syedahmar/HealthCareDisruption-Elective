%% Description
% Author: Syed Ahmar Shah
% ahmar.shah@ed.ac.uk
% June 15, 2023
% This script can be used to find the paramaters of the autoregressive
% model that will then be used for the projections for the healthcare
% disruption work
%% clear workspace and load data
clc;clear all;
load RTT_October2022;
% pre-processing to ensure that the adjusted total waiting time is used
data.Waiting=data.TotalWaitingmilWithEstimatesForMissingData;
data.Capacity=data.NoOfPathwaysallWithEstimatesForMissingData+data.NoOfPathwaysallWithEstimatesForMissingData1;
data.Demand = data.NoOfNewRTTPeriodsWithEstimatesForMissingData;


%% Let us use the subset of data during the pre-pandemic period where we have demand data available

% pre-pandemic indices where demand data is available
pre_start=103; % corresponds to October 2015
pre_end=155; % corresponds to February 2020
IX=pre_start:pre_end;

%% create a full model (Model_F) 
Mdl_F = varm(1,12); % one time-series, all AR terms up to lag of 6 but also include lag of 12
Mdl_F.Constant=NaN; 
Mdl_F.Trend=NaN;
Mdl_F.Beta=[NaN NaN];
% instantiate a model with only 1-6 and 12th lag terms
Mdl_F.AR(7:11)={0}; % this step ensures that AR(7:11) are not excluded
[Mdl_F_Est Mdl_F_SE Mdl_F_LogL, Mdl_F_E] = estimate(Mdl_F,data.Waiting(IX),X=[data.Capacity(IX) data.Demand(IX)]);
sqrt(Mdl_F_Est.Covariance)
summarize(Mdl_F_Est)

%% create the parsimonious model (Model_P) with AR(12)
Mdl_P = varm(1,12); % one time-series, lag of 12
Mdl_P.Constant=NaN; 
Mdl_P.Trend=0;
Mdl_P.Beta=[NaN NaN];
Mdl_P.AR(2:11)={0};
[Mdl_P_Est Mdl_P_SE Mdl_P_LogL, Mdl_P_E] = estimate(Mdl_P,data.Waiting(IX),X=[data.Capacity(IX) data.Demand(IX)]);
sqrt(Mdl_P_Est.Covariance)
summarize(Mdl_P_Est)
std(Mdl_P_E)

% save the model (uncomment the following lines if you need to generate a
% new model
EstMdl = Mdl_P_Est; 
save LearnedModel_final EstMdl
