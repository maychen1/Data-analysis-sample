# Data cleaning sample: Employment rate by industry 

SAEMP25N are GDP and personal income data in the United States. 
For this project, I want to reorder and analyze 2000 and 2017 SAEMP25N data in total and by industry. 

__Clean data__ 
This section cleans the data by removing the footnotes, drop unnecessary summaries, and remove N/As. 
step1: remove footnotes for both data sets
step2.1: Drop subtotal summaries in data2
step2.2: Drop blanks/tabs in data2 `Description` column

__Recognize data__
This is the second preparation step, which aims to merge the two clean data sets together for further analysis. 
step1: Apply pivot longer on both data frames to make year and total/subtotal two columns
step2: combine reorganized data into one long dataframe 

__Calculate statistics__
Turn Subtotal into Percentage. 

__Export the cleaned data__ 
Store data in csv format. 

__Data visualization__
In this project, I select the 2000 top 5 employment rate in manufacturing industry and plot their changes. 
