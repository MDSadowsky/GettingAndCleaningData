library(dplyr)
library(tidyr)

##  Loads the header info.
features <- read.table(file="UCI HAR Dataset/features.txt")


##  Loads the Activity mapping.
activities <- read.table(file="UCI HAR Dataset/activity_labels.txt")

##  Names the 2 Activity columns.
colnames(activities) <- c("ActivityNum", "Activity")


##  Loads the test data.
test_x <- read.table(file="UCI HAR Dataset/test/X_test.txt")
test_subject <- read.table(file="UCI HAR Dataset/test/subject_test.txt")
test_y <- read.table(file="UCI HAR Dataset/test/y_test.txt")


##  Loads the train data.
train_x <- read.table(file="UCI HAR Dataset/train/X_train.txt")
train_subject <- read.table(file="UCI HAR Dataset/train/subject_train.txt")
train_y <- read.table(file="UCI HAR Dataset/train/y_train.txt")


##  Combines the two data sets.
x <- rbind( test_x, train_x )
y <- rbind( test_y, train_y )
subject <- rbind( test_subject, train_subject )


##  Assigns column names.
##  Most of the names are taken from the features file.
##  ActivityNum and Subject are assigned manually to the y and subject data.
colnames(x) <- as.vector(features$V2)
colnames(y) <- c("ActivityNum")
colnames(subject) <- c("Subject")


##  Adds the descriptive Activity names from the activity_labels data.
y_labeled <- inner_join( y, activities, by="ActivityNum")


##  Uses cbind to combine the x, y, and subject data.
##  We now have a complete (messy) dataset.
data <- tbl_df(cbind( subject, y_labeled, x ))


##  Some of the column names are duplicates,
##  which causes problems, so we remove them here.
data_no_dupe_cols <- (data[, !duplicated(colnames(data))])


##  The tidying of the complete data set.
##  First, we use select to grab the Subject, Activity,
##  and all fields that use mean() or std().
##  Then we use gather to unpivot the measurement columns and turn them into two columns
##  named Measurement and Results.
##  Finally, we use group_by and summarize to determine the average per Subject/Activity/Measurement.
data_tidy <- select( data_no_dupe_cols, Subject, Activity, contains("mean()"), contains("std()") ) %>%
  gather( Measurement, Results, -Activity, -Subject ) %>%
  group_by( Subject, Activity, Measurement ) %>%
  summarize( Average = mean(Results))


##  Records the tidy dataset.
write.table( data_tidy, file="tidy_data_set.txt", row.name=FALSE)
