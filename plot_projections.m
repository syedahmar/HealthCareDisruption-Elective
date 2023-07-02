figure(fw); % make sure that you can focus on the correct figure
% note that the figures are returned with the 10^6 notation, you can ignore
% that portion as this is already in millions.
if(percent_return==0.50)
    plot(x_future_months, prctile(y_waiting_global(:,1:end)./M1,50,1),'-k','LineWidth',3,'DisplayName',['if capacity increases by ', num2str(percent_increase),'% and only 50% missing return'])
    plot(x_future_months, prctile(y_waiting_global(:,1:end)./M1,2.5,1),'--k','LineWidth',1,'HandleVisibility','off')
    plot(x_future_months, prctile(y_waiting_global(:,1:end)./M1,97.5,1),'--k','LineWidth',1,'HandleVisibility','off')
    ylabel('Total Number of Pending Patient Referrals (in Millions)')
end
if(percent_return==0.25)
    plot(x_future_months, prctile(y_waiting_global(:,1:end)./M1,50,1),'-m','LineWidth',3,'DisplayName','if 25-75% missing return')
    plot(x_future_months, prctile(y_waiting_global(:,1:end)./M1,2.5,1),'--m','LineWidth',1,'HandleVisibility','off')
    plot(x_future_months, prctile(y_waiting_global(:,1:end)./M1,97.5,1),'--m','LineWidth',1,'HandleVisibility','off')
    ylabel('Total Number of Pending Patient Referrals (in Millions)')
end
if(percent_return==0.75)
    plot(x_future_months, prctile(y_waiting_global(:,1:end)./M1,50,1),'-m','LineWidth',3,'HandleVisibility','off')
    plot(x_future_months, prctile(y_waiting_global(:,1:end)./M1,2.5,1),'--m','LineWidth',1,'HandleVisibility','off')
    plot(x_future_months, prctile(y_waiting_global(:,1:end)./M1,97.5,1),'--m','LineWidth',1,'HandleVisibility','off')
    ylabel('Total Number of Pending Patient Referrals (in Millions)')
end
