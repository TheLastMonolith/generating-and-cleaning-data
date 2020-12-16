# Constants

dataDirectory <- "./UCI HAR Dataset"          ## Base directory location
fileExt <- ".txt"

# Load library

library(data.table)                           ## use data.table::fread() to read large data sets

################################################################################
# Function to read and return a data table from the .txt files

createSet <- function(set.type) {
        
        # Subject data set
        subjectFileName <- paste("subject_", set.type, fileExt, sep = "")
        subjects <- fread(file.path(dataDirectory, set.type, subjectFileName),
                               header = FALSE,
                               col.names = c("subject.id"))
        # Activity data set
        activityFileName <- paste("y_", set.type, fileExt, sep = "")
        activities <- fread(file.path(dataDirectory, set.type, activityFileName),
                                  header = FALSE,
                                  col.names = c("activity"))
        # Measurement data set
        xFileName <- paste("X_", set.type, fileExt, sep = "")
        x.set <- fread(file.path(dataDirectory, set.type, xFileName),
                            header = FALSE)
        # combine the subjects, activities, and x.set data set into one data frame:
        combinedSet <- cbind(subjects, activities, x.set)
        combinedSet
}
################################################################################
# Create the train and test data sets:
trainDataSet <- createSet("train")
testDataSet <- createSet("test")

# Combine the test and train data sets to create one data set:
totalDataSet <- rbind(trainDataSet, testDataSet)

# Clean unused data memory
rm(trainDataSet, testDataSet)

# Read the features data set and return as column names for the measurement
# variables of the totalDataSet object
featuresFile <- read.table(file.path(dataDirectory, "features.txt"),
                           header = FALSE)
# Extract only the column that contains the character names or measurement labels
featuresFile <- as.character(featuresFile[, 2])
setDF(totalDataSet)     # convert data.table to data.frame
names(totalDataSet)[-c(1:2)] <- featuresFile


# Extract only the measurements on the mean and standard deviation for each measurement
totalDataSet <- totalDataSet[, which(colnames(totalDataSet) %in% 
                                            c("subject.id", "activity",
                                              grep("std\\()|mean\\()",
                                                   colnames(totalDataSet),
                                                   value = TRUE)))]

# Read the activity labels data set and use as descriptive names on the activity
activityLabels <- read.table(file.path(dataDirectory, "activity_labels.txt"),
                        header = FALSE)
# Extract only the column of the activity labels
activityLabels <- as.character(activityLabels[, 2])
totalDataSet$activity <- activityLabels[totalDataSet$activity]

# Appropriately label the data set with descriptive variable names

names(totalDataSet)[-c(1:2)] <- gsub("^t", "time", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("^f", "frequency", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("Acc", "Accelerometer", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("Gyro", "Gyrometer", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("Mag", "Magnitude", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("BodyBody", "Body", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("-", " ", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("mean\\()", "mean", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("std\\()", "stdev", names(totalDataSet)[-c(1:2)])

str(totalDataSet)

################################################################################ 
# Turn the data set into an independent tidy data set with the average of each
# variable for each activity and each subject


tidyDataSet <- aggregate(.~subject.id + activity, totalDataSet, mean)
tidyDataSet <- tidyDataSet[order(tidyDataSet$subject.id, tidyDataSet$activity), ]

str(tidyDataSet)

################################################################################
## writes the tidy dataset to .txt file in the local project directory
write.table(tidyDataSet, file = "project_tidy_dataset.txt", row.name=FALSE)