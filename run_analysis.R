#set the working directory
setwd("Y:/personal/personal/Work/teaching/Data Science/Coursera/Data Cleaning")

#download the file
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/run.zip")


# unzip the zip file 
unzip(zipfile="./data/run.zip", exdir="./data")

#read the file
activity_labels <- read.table("Y:/personal/personal/Work/teaching/Data Science/Coursera/Data Cleaning/data/UCI HAR Dataset/activity_labels.txt")
features <- read.table("Y:/personal/personal/Work/teaching/Data Science/Coursera/Data Cleaning/data/UCI HAR Dataset/features.txt")
X_train <- read.table("Y:/personal/personal/Work/teaching/Data Science/Coursera/Data Cleaning/data/UCI HAR Dataset/train/X_train.txt", col.names=features[,2])
X_test  <- read.table("Y:/personal/personal/Work/teaching/Data Science/Coursera/Data Cleaning/data/UCI HAR Dataset/test/X_test.txt", col.names=features[,2])
y_train <- read.table("Y:/personal/personal/Work/teaching/Data Science/Coursera/Data Cleaning/data/UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("Y:/personal/personal/Work/teaching/Data Science/Coursera/Data Cleaning/data/UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("Y:/personal/personal/Work/teaching/Data Science/Coursera/Data Cleaning/data/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("Y:/personal/personal/Work/teaching/Data Science/Coursera/Data Cleaning/data/UCI HAR Dataset/test/subject_test.txt")

#Merges the training and the test sets to create one data set.
#sort=FALSE is used to stack all the train set and then test set.

X_train$set<-"train"
X_test$set<-"test"
MergeData<-merge(X_train, X_test, all=TRUE, sort=FALSE)

#Extracts only the measurements on the mean and standard deviation for each measurement. 
MeanStdData<-MergeData[,grep("mean|std", names(MergeData), value="TRUE")]


#Uses descriptive activity names to name the activities in the data set
# Create a new variable activity to include activity names (y)
# Create a new variable subject to include subject identification (subject)

MeanStdData$activity<-rep(0, nrow(MeanStdData))
MeanStdData$activity<-c(y_train$V1, y_test$V1)
MeanStdData$subject<-c(subject_train$V1, subject_test$V1)

#Appropriately labels the data set with descriptive variable names.
#Change variable name from V2 to activity for the better label
library(dplyr)
activity_labels<-rename(activity_labels,  Activity=V2)
y_train<-rename(y_train,  activity=V1)
y_test<-rename(y_test,  activity=V1)
subject_train<-rename(subject_train,  subject=V1)
subject_test<-rename(subject_test,  subject=V1)

#From the data set in previous step, creates a second, independent tidy data set
#with the average of each variable for each activity and each subject.


Mean_for_each_activity <- MeanStdData %>% group_by(activity, subject) %>%summarise_each(funs(mean), -activity)
Mean_for_each_activity$activity[Mean_for_each_activity$activity==1]<-"WALKING"
Mean_for_each_activity$activity[Mean_for_each_activity$activity==2]<-"WALKING_UPSTAIRS"
Mean_for_each_activity$activity[Mean_for_each_activity$activity==3]<-"WALKING_DOWNSTAIRS"
Mean_for_each_activity$activity[Mean_for_each_activity$activity==4]<-"SITTING"
Mean_for_each_activity$activity[Mean_for_each_activity$activity==5]<-"STANDING"
Mean_for_each_activity$activity[Mean_for_each_activity$activity==6]<-"LAYING"

write.table(Mean_for_each_activity, "tidy.txt", row.names = FALSE, quote = FALSE)

