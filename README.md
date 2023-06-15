# HealthCareDisruption-Elective

This repository contains the raw data, the processed data and the MATLAB script files that accompany a research publication that is currently under review. The link to the published paper will be provided here once it is published.

**Files Description**

**GetModelParameters.m:**  (MATLAB Script File) This script will create a new VARX model and determine the associated parameters by fitting it to the data.
**HealthCareDisruption_final.m:** (MATLAB Script File) This script will run the entire analysis pipeline and use the model learnt from GetModelParameter.
**RTT_October2022.mat:** (MATLAB Data File) This is the data imported from the raw data (CSV) that is now in the MATLAB format.
**RTT-Overview-Timeseries-October22.xlsx:** This is the original data file that was downloaded from NHS England (https://www.england.nhs.uk/statistics/statistical-work-areas/rtt-waiting-times/). This data is made publicly available under the Open Government Licence v3 (https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
