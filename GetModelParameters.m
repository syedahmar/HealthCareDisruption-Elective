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

%% create a partially specified model (if you want to run a model with all free paramters, you can do so by assiging NaN to all the parameters
Mdl = varm(1,1); % one time-series, lag of 1
Mdl.Constant=0; 
Mdl.Trend=0;
Mdl.Beta=[NaN NaN];
%Mdl.AR={1}; % specify constaint on previous waiting time (unit coefficient)
%Mdl.Beta=[-1,1]; % specify constaint on exogenous variables - demand and treated (unit constraint)
EstMdl = estimate(Mdl,data.Waiting(IX),X=[data.Capacity(IX) data.Demand(IX)]);
sqrt(EstMdl.Covariance)
summarize(EstMdl)