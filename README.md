# GettingAndCleaningData

The script run_analysis.R handles all of the data gathering and transforming for this project.  It assumes that the data is in the "UCI HAR Dataset" folder in the working directory.

The script loads the following files from the provided data:

features.txt
activity_labels.txt
test/X_test.txt
test/subject_test.txt
test/y_test.txt
train/X_train.txt
train/subject_train.txt
train/y_train.txt

It uses rbind to combine each test and train data set together, an inner join to link the activity numbers in the y data to the descriptive labels, and then cbind to combine the x, y, and subject data into a complete data set.

Based on the descriptions provided in features_info.txt, the mean() and std() columns are the ones containing Mean Values and Standard Deviations.  While fields like meanFreq() can arguably be included, I opted to use only the columns specifically labeled as mean and standard deviation.

After assigning header names based on features.txt and removing duplicate and unwanted column names, dplyr functions are used to transform the data set into 11880 observations of 4 variables:

Subject
Activity
Measurement
Average

Because values like "tBodyAcc-mean()-X" are observations, not variables, I did not "clean" them by giving them more human readable names.
