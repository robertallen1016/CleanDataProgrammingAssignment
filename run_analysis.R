##Libraries that need to be loaded for this R Script
## 1. dplyr
library(dplyr)

##Set the working directory to one below the UCI directory created when 
##unzipping the data files.

##Read in the Training Data
s_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

##Read in the Testing Data
s_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

##Read in the Features Data
features <- read.table("UCI HAR Dataset/features.txt", header=FALSE)

##Read in ActivityLabels Data
actlbls <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
names(actlbls) <- c("actid", "Activity")

##Assign names to vaiables in imported datasets
colnames(x_train) <- features$V2
colnames(x_test) <- features$V2
colnames(y_train) <- "y_var"
colnames(y_test) <- "y_var"
colnames(s_train) <- "Subject_ID"
colnames(s_test) <- "Subject_ID"

##Column combind the Training and Testing datasets
train <- cbind(s_train, y_train, x_train)
test <- cbind(s_test, y_test, x_test)
train <- train[, !duplicated(colnames(train))]
test <- test[, !duplicated(colnames(test))]

##Create variable to indicate which dataset the data came from
train <- mutate(train, dataset="train")
test <- mutate(test, dataset="test")

#Combine Testing and Training datasets into one dataset
compdata <- rbind(test, train)

#Extracts only the variable related to means and stand deviations
meanstd <- select(compdata, dataset, Subject_ID, y_var, contains("mean"), contains("std"))

##Update Avtivity codes with real names
meanstd <- merge(meanstd, actlbls, by.x = "y_var", by.y = "actid")

##Update names in columns with unabreviated names as found in features_info.txt
names(meanstd) <- gsub("Acc", "Accelerometer", names(meanstd))
names(meanstd) <- gsub("Gyro", "Gyroscope", names(meanstd))
names(meanstd) <- gsub("BodyBody", "Body", names(meanstd))
names(meanstd) <- gsub("Mag", "Magnitude", names(meanstd))
names(meanstd) <- gsub("^t", "Time", names(meanstd))
names(meanstd) <- gsub("^f", "Frequency", names(meanstd))
names(meanstd) <- gsub("tBody", "TimeBody", names(meanstd))
names(meanstd) <- gsub("-mean()", "Mean", names(meanstd), ignore.case = TRUE)
names(meanstd) <- gsub("-std()", "STD", names(meanstd), ignore.case = TRUE)
names(meanstd) <- gsub("-freq()", "Frequency", names(meanstd), ignore.case = TRUE)
names(meanstd) <- gsub("angle", "Angle", names(meanstd))
names(meanstd) <- gsub("gravity", "Gravity", names(meanstd))

##Find mean of each vaiable for each activity and subject
tidydata <- meanstd %>% 
            select(-dataset) %>% 
            group_by(Subject_ID, Activity) %>% 
            summarise_each(funs(mean))

##Removes unneeded y_var variable
tidydata$y_var <- NULL

##Output cleaned data to working directory
write.table(tidydata, file = "Tidy.txt", row.names = FALSE)
