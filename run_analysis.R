# load reshape2 and set working directory
library(reshape2)
setwd("~/R")

## Merge the training and the test sets to create one data set

# read data from working diretory and add column names
subject_train <- read.table("subject_train.txt")
subject_test <- read.table("subject_test.txt")
X_train <- read.table("X_train.txt")
X_test <- read.table("X_test.txt")
y_train <- read.table("y_train.txt")
y_test <- read.table("y_test.txt")
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"
featureNames <- read.table("features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2
names(y_train) <- "activity"
names(y_test) <- "activity"

# merge files into one dataset
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)


# Extract only the measurements on the mean and standard
# deviation for each measurement.
meanstd <- grepl("mean\\(\\)", names(combined)) |
    grepl("std\\(\\)", names(combined))

# keep only needed columns
combined <- combined[, meanstd]


# Uses descriptive activity names to name the activities in the data set.
# Appropriately labels the data set with descriptive activity names. 

combined$activity <- factor(combined$activity, labels=c("Walking",
                                                        "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

# Creates a second, independent tidy data set with the average of each variable for 
# each activity and each subject.

# create the tidy data set and write it to a file
melted <- melt(combined, id=c("subjectID","activity"))
tidy <- dcast(melted, subjectID+activity ~ variable, mean)
write.csv(tidy, "tidy.csv", row.names=FALSE)