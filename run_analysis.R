# Project
# 2015-02-22
# Bryan Urban

library(tidyr)
library(data.table)

## GET RAW DATA
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              "dataset.zip", mode="wb")

# Unzip all files to "data" folder in working directory  

## 0. Read Test Data
test <- read.csv("data/test/X_test.txt", header=FALSE, sep="")
test_labels <- read.csv("data/test/y_test.txt", header=FALSE, sep="")
test_subject <- read.csv("data/test/subject_test.txt", header=FALSE, sep="")

train <- read.csv("data/train/X_train.txt", header=FALSE, sep="")
train_labels <- read.csv("data/train/y_train.txt", header=FALSE, sep="")
train_subject <- read.csv("data/train/subject_train.txt", header=FALSE, sep="")

features <- read.csv("data/features.txt", header=FALSE, sep="")


## PROCESS DATA
## 1. Merge Data into One Big Data Set

all_data <- rbind(test, train)
all_labels <- rbind(test_labels, train_labels)      # activity labels
all_subjects <- rbind(test_subject, train_subject)  # subject IDs

## 2. Extract measurements of mean and standard deviation on each measurement

# find columns that inclue a mean or sd
mean_ind <- grep("*mean*", features[,2], ignore.case=TRUE)
std_ind <-  grep("*std*", features[,2], ignore.case=TRUE)
keep_ind <- c(mean_ind, std_ind)

ind_labels <- as.character(features[keep_ind,2])

# keep only the selected columns
sub_data <- all_data[,keep_ind]   # 86 variables kept
sub_data$subject <- unlist(all_subjects) # add subject ID

## 3. Use descriptive activity names
sub_data$activity <- all_labels

# convert numeric activity labels to text
activity_key <- 
  c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS",
    "SITTING", "STANDING", "LAYING")

sub_data$activity <- activity_key[unlist(sub_data$activity)] 

## 4. Label the dataset with descriptive column names
colnames <- make.names(names=ind_labels,unique=TRUE,allow_=TRUE)

# rid triple, double, and trailing dots
colnames <- gsub("[.]{3}", ".", colnames) 
colnames <- gsub("[.]{2}", ".", colnames) #
colnames <- gsub("[.]$", "", colnames)    #

# assign names to dataset
names(sub_data)[1:length(ind_labels)] <- colnames


## 5. Make tidy dataset
td <- data.table(sub_data)

# calculate mean for each subject and activity
td <- td[, lapply(.SD,mean), by=list(subject, activity)] 
write.table(td, "tidy.txt" ,row.name=FALSE)