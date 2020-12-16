# Getting-and-Cleaning-Data-Course-Project
Author: Joseph Figuracion // TheLastMonolith @github <br>
*Project for the Getting and Cleaning Data [course](https://www.coursera.org/learn/data-cleaning)* <br>

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 


## Input Data
- https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip <br>

### About the Data
- http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Outputs Produced
- README.md
- CodeBook.md
- project_tidy_dataset.txt

## R Script
- run_analysis.R

### The R scipt does the following:
1. Merge the training and test data sets to get a single data set.
2. Extract only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive activity names.
5. From the data set from step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Steps to Reproduce this Project
1. Download the [data set](#input-data) and unzip the file in your working directory.
2. Open the R script `run_analysis.r` using RStudio.
3. Change the parameter of the `setwd` function call to the working directory.
4. Run the R script `run_analysis.r`. It produces the tidy data set called `project_tidy_dataset.txt`.  

*Note: Install the `data.table` function if you still don't have it.*

## Licencse:
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This data set is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
