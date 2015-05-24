---
title: "Readme"
author: "Chilly Amador"
date: "May 21, 2015"
output: html_document
---

# Getting and cleaning data - Project 2

Objective: To create a tidy data set of wearable computing data from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#Files in this repo

README.md -- Script information
CodeBook.md -- codebook describing variables, the data and transformations
run_analysis.R -- actual R code
tidy_data.txt -- Data output from run_analysis.R

#Project description:
You should create one R script called run_analysis.R that does the following: 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Run_analysis.R should run in a folder of the Samsung data (the zip had this folder: UCI HAR Dataset) The script assumes it has in it's working directory the following files and folders:

activity_labels.txt
features.txt
test/
train/
The output is created in working directory with the name of tidy2.txt

Note: the R script is built to run without including any libraries for the purpose of this course.

#run_analysis.R steps


1.Read the test, train and subject files: y_test.txt, subject_test.txt and X_test.txt.
Combine the files to a data frame linking subjects, labels, and the rest of the data.

2.Read the activity labels from activity_labels.txt and replace the numbers with the text

3.Read the features from features.txt and extract only those features that are either means ("mean()") or standard deviation ("std()"). The reason for leaving out meanFreq() is that the goal for this step is to only include means and standard deviations of measurements, of which meanFreq() is neither.Factor to character conversion was used to complete this task.

4.A long data frame (melt_data) is then created that includes subjects, labels and the described features for mean(0 and std().

5.Replace column names for more meaningful ones using gsub()

6.Create a wide data frame (tidy_data) by finding the mean for each combination of subject and label using aggregate() function

7.Write the new tidy data set into a text file called tidy_data.txt.