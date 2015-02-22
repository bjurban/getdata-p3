### getdata-p3
The run_analysis.R script is designed to read in the raw experimental smartphone accelerometer data and convert it into a tidy format that summarizes the mean of specific measured variables by subject and activity. 

### Data
Raw data were organized into several files split into a training set and a test set. In addition, the data were separated from labels that indicate subject id (person in the experiment), activity label (what the person was doing during the measurement), and measurement variable name (what was reported). 

See data_codebook.txt for updated description of the variables included in the tidy dataset. 

### Analysis
Before starting, the raw data is downloaded locally. We assume the raw data are unzipped into a folder in the working directory called "data".

* Step 0: Raw data for both test- and training- data are read into data frames. Activity labels, subject ids, and variable names associated with these datasets are also read.
* Step 1: Raw data for all data sets are combined to form one large dataset, and activity labels and subject ids are added.
* Step 2: This step identifies these variables and keeps only those that contain a mean or standard deviation of a measure.
* Step 3: Format and add column names to all variables. Variable names are kept consistent with the raw data, except that special characters are converted to "." 
* Step 4: The numeric activity labels (1-6) are converted to their corresponding descriptive text labels. (e.g., walking, sitting, etc.)
* Step 5: The mean of each measure is calculated by subject and by activity, and is written to a csv text file. 