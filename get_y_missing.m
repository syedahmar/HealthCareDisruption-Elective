function y_missing=get_y_missing(total_missing_present,percent_return,future_index_length,shape_missing)

%% Inputs:
% total_missing: estimated total number of missing people over 3 years
%present_return: percentage of missing people expected to return
% future_index_length: this should be equal to the length of the future time period indices 
% Outputs:
% y_missing: time-series vector of missing people over the 
% %% processing (assume a specific shape - Triangular)
total_missing=round(total_missing_present);
if(shape_missing==1)
    missing_peak=(total_missing*percent_return)/24;
    y_missing=[linspace(0,missing_peak,12) ...
    ones(1,12)*missing_peak ...
    linspace(missing_peak,0,12)];
end
if(shape_missing==2)
    missing_peak=(total_missing*percent_return)/30;
    y_missing=[ones(1,24)*missing_peak ...
    linspace(missing_peak,0,12)];
end

y_missing=y_missing';
y_missing=[y_missing;zeros(future_index_length-length(y_missing),1)]; % append zero patients returning for any period beyond 3 years

