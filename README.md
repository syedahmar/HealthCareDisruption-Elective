# HealthCareDisruption-Elective

This repository contains the raw data, the processed data and the MATLAB script files that accompany a research publication that is currently under review. The link to the published paper will be provided here once it is published.

**Files Description**
**HealthCareDisruption_final.m:** (MATLAB Script File) This script will run the entire analysis pipeline (but it will not plot the projections).
**plot_projections.m** Run this immediately after "HealthCareDisruption_final.m" to plot the projections. By default, it will select the previously created figure from "HealthcareDisruption_final.m" and then add the projections there. However, you can specify the figure that you wish to add the projections to.
**GetModelParameters.m:**  (MATLAB Script File) This script will create a new VARX model and determine the associated parameters by fitting it to the data.  You only need to run this if you wish to create a new learned model. We have used this script to create a parsimonious model which has been saved under "LearnedModel_final".
**LearnedModel_final.mat** This is the parsimonious VARX model that was learned and used for the projections.
**get_y_missing.m** This function generates the y_missing time-series and it is called by the HealthcareDisruption_final.m script.
**RTT_October2022.mat:** (MATLAB Data File) This is the data imported from the raw data (CSV) that is now in the MATLAB format.
**RTT-Overview-Timeseries-October22.xlsx:** This is the original data file that was downloaded from NHS England (https://www.england.nhs.uk/statistics/statistical-work-areas/rtt-waiting-times/). This data is made publicly available under the Open Government Licence v3 (https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
