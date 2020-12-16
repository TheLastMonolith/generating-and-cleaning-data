---
title: "Cookbook for Final Project for Getting and Cleaning Data Course"
author: "Joseph Figuracion"
output:
  html_document
---

### Script Assignment: 
You should create one R script called `run_analysis.R` that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with 
   the average of each variable for each activity and each subject.

### Variable Lists and Descriptions

Variable name    | Description
-----------------|------------
subject.id       | The subject who performed the activity for each window sample. Its range is from 1 to 30.
activity         | Activity name (e.g. WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, etc.)
timeBodyAccelerometer - XYZ | Triaxial body acceleration from the accelerometer (time domain)
timeGravityAccelerometer - XYZ | Triaxial gravity acceleration from the accelerometer (time domain)
timeBodyAccelerometerJerk - XYZ | Triaxial body linear acceleration Jerk Signal (time domain)
timeBodyGyrometer - XYZ | Triaxial body acceleration from the gyroscope (time domain)
timeBodyGyrometerJerk - XYZ | Triaxial body angular velocity Jerk Signal (time domain)
timeBodyAccelerometerMagnitude | Magnitude of the timeBodyAccelerometer
timeGravityAccelerometerMagnitude | Magnitude of the timeGravityAccelerometer - XYZ
timeBodyAccelerometerJerkMagnitude | Magnitude of the timeBodyAccelerometerJerk - XYZ
timeBodyGyrometerMagnitude | Magnitude of the timeBodyGyrometer - XYZ
timeBodyGyrometerJerkMagnitude | Magnitude of the timeBodyGyrometerJerk - XYZ
frequencyBodyAccelerometer - XYZ | Triaxial body acceleration from the accelerometer (frequency domain)
frequencyBodyAccelerometerJerk - XYZ | Triaxial body linear acceleration Jerk Signal (frequency domain)
frequencyBodyGyrometer - XYZ | Triaxial body acceleration from the gyroscope (frequency domain)
frequencyBodyAccelerometerMagnitude | Magnitude of the frequencyBodyAccelerometer - XYZ
frequencyBodyAccelerometerJerkMagnitude | Magnitude of the frequencyBodyAccelerometerJerk - XYZ
frequencyBodyGyrometerJerkMagnitude | Magnitude of the triaxial body angular velocity Jerk Signal (frequency domain)

### run_analysis.R
Created on R version 4.0.3 (2020-10-10), System: x86_64, mingw32  

#### Step 1: Setting up your directory and library package
Create constants for your directory path and file extension format
```{r}
dataDirectory <- "./UCI HAR Dataset"          # Base directory location
fileExt <- ".txt"
```
and load the `data.table` package
```{r}
library(data.table)                           # use data.table::fread() to read large data sets
```
#### Step 2: Create sets of data using a read-in data function
The `set.type` argument shall have an input of 'train' data sets and 'test' data sets <br>

```{r}
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
```
```{r}
# Create the train and test data sets:
trainDataSet <- createSet("train")
testDataSet <- createSet("test")
```

#### Step 3: Combine test and train data sets to create one data set
This satisfies the **project requirement [#1](#script-assignment)** 
```{r}
totalDataSet <- rbind(trainDataSet, testDataSet)

# Clean unused data memory
rm(trainDataSet, testDataSet)
```
```{r}
> dim(totalDataSet)
[1] 10299   563
```
#### Step 4: Update data (`totalDataSet`) with descriptive column names
Read the features data set and return as column names for the measurement variables of the `totalDataSet` object. We will make these names 'tidier' on [Step 7](#step-7)

```{r}
featuresFile <- read.table(file.path(dataDirectory, "features.txt"),
                           header = FALSE)
# Extract only the column that contains the character names or measurement labels     
featuresFile <- as.character(featuresFile[, 2])
```
Since we used the `data.table::fread()` function to read the data sets, it is in a `data.table` format. Convert it to a `data.frame` to use the base syntax of data frames.
```{r}
> class(totalDataSet)
[1] "data.table" "data.frame"
setDF(totalDataSet)     # convert data.table to data.frame
```
```{r}
> class(totalDataSet)
[1] "data.frame"        # It is now converted to a data.frame
```
Update the column names...
```{r}
names(totalDataSet)[-c(1:2)] <- featuresFile
```
#### Step 5: Extract only the means and standard deviations for each measurement
We will use the `grep` function to select column names with patterns: mean() and std(). Let the value equal to `TRUE` to return the selected column names. Remember to select also the first two columns (subject.id, and activity) in your extraction. The resulting data set will have 68 variables from 563. This satisfies the **project requirement [#2](#script-assignment)** 
```{r}
totalDataSet <- totalDataSet[, which(colnames(totalDataSet) %in%
                               c("subject.id", "activity",
                                grep("std\\()|mean\\()",
                                    colnames(totalDataSet),
                                    value = TRUE)))]
```
#### Step 6: Update the observations on the activity variable with descriptive names
The activity label data set contains the activity id (1-6) with it's corresponding activity (e.g. WALKING, SITTING, LAYING, etc.). Read the activity label data set and use it as descriptive names on the activity variable column. This satisfies the **project requirement [#3](#script-assignment)** 

```{r}
activityLabels <- read.table(file.path(dataDirectory, "activity_labels.txt"),
                        header = FALSE)
# Extract only the column of the activity labels
activityLabels <- as.character(activityLabels[, 2])
totalDataSet$activity <- activityLabels[totalDataSet$activity]
```

#### Step 7: Appropriately label the data set with descriptive variable names {#step-7}
In order to label the data set with descriptive names, we are going to make the following changes:  

- prefix **t** is replaced by **time**
- prefix **f** is replaced by **frequency**
- **Acc** is replaced by **Accelerometer**
- **Gyro** is replaced by **Gyroscope**
- **Mag** is replaced by **Magnitude**
- **BodyBody** is replaced by **Body**
- separator **'-'** is replaced with **white space ' '**
- **mean()** is replaced with **mean**
- **std()** is replaced with **stdev**  

This satisfies the **project requirement [#4](#script-assignment)**
```{r}
names(totalDataSet)[-c(1:2)] <- gsub("^t", "time", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("^f", "frequency", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("Acc", "Accelerometer", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("Gyro", "Gyrometer", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("Mag", "Magnitude", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("BodyBody", "Body", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("-", " ", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("mean\\()", "mean", names(totalDataSet)[-c(1:2)])
names(totalDataSet)[-c(1:2)] <- gsub("std\\()", "stdev", names(totalDataSet)[-c(1:2)])
```

#### Step 8: Create a second, independentidy data set with the average of each variable for each activity and each subject
This satisfies the **project requirement [#5](#script-assignment)**
```{r}
tidyDataSet <- aggregate(.~subject.id + activity, totalDataSet, mean)
tidyDataSet <- tidyDataSet[order(tidyDataSet$subject.id, tidyDataSet$activity), ]
```  

The resulting data set `tidyDataSet` includes the average of each variable for each activity and each subject. The 10299 observations from the `totalDataset` data set are split into 180 groups (30 subjects and 6 activities) and 66 mean and standard deviation features are averaged for each group.  

#### Optional Step: Write the 'tidy' data set into a `.txt` file
Writes the tidy data set to .txt file in the local project directory
```{r}
write.table(tidyDataSet, file = "project_tidy_dataset.txt", row.name=FALSE)
```