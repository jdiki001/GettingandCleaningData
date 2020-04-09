# Getting and Cleaning Data Week 4 Assignment
# April 9, 2020

# Download

if(!file.exists("./data"))   {
  dir.create("./data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip", exdir="./data")

# Merging Training and Test 

X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./data/UCI HAR Dataset/features.txt')
activity_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# Variable Names

colnames(X_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
colnames(X_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activity_labels) <- c('activityId','activityType')

merged_train <- cbind(y_train, subject_train, X_train)
merged_test <- cbind(y_test, subject_test, X_test)
mergedSet <- rbind(merged_train, merged_test)

# Mean and Standard Deviation

colNames <- colnames(mergedSet)

meanandstd <- (grepl("activityId" , colNames) | 
                 grepl("subjectId" , colNames) | 
                 grepl("mean.." , colNames) | 
                 grepl("std.." , colNames) )

MeanAndStd <- mergedSet[ , meanandstd == TRUE]

# Activity Names

ActivityNamesSet <- merge(MeanAndStd, activity_labels, by = 'activityId', all.x=TRUE)

# Tidy Data Set 

TidySet2 <- aggregate(. ~subjectId + activityId, ActivityNamesSet, mean)
TidySet2 <- TidySet2[order(TidySet2$subjectId, TidySet2$activityId),]
write.table(TidySet2, "TidySet2.txt", row.name=FALSE)