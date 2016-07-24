## Prerequisites

# Load the reshape2 package.
library(reshape2)


## 1 - Merges the training and the test sets to create one data set.

# Load txt files into data frames.
subject_train <- read.table("subject_train.txt")
subject_test <- read.table("subject_test.txt")
X_train <- read.table("X_train.txt")
X_test <- read.table("X_test.txt")
y_train <- read.table("y_train.txt")
y_test <- read.table("y_test.txt")

# Add column names to the files
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"
featureNames <- read.table("features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2
names(y_train) <- "activity"
names(y_test) <- "activity"

# Merge the files into one dataset.
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)


## 2 - Extracts only the measurements on the mean and standard deviation for each measurement.

# Determine which columns contain mean() or std()
meanstdcols <- grepl("mean\\(\\)", names(combined)) |
  grepl("std\\(\\)", names(combined))

# Ensure that subjectID and activity columns remain.
meanstdcols[1:2] <- TRUE

# Remove unnecessary columns.
combined <- combined[, meanstdcols]


## 3 - Uses descriptive activity names to name the activities in the data set.
## 4 - Appropriately labels the data set with descriptive activity names. 

# Convert the activity column from integer to factor
combined$activity <- factor(combined$activity, labels=c("Walking",
                                                        "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))


## 5 - Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Create a tidy data set.
melted <- melt(combined, id=c("subjectID","activity"))
tidy <- dcast(melted, subjectID+activity ~ variable, mean)

# Write the tidy data set to a file.
write.csv(tidy, "tidy.csv", row.names=FALSE)