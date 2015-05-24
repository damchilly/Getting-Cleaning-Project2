## Getting and Cleaning Project 2 week 3

## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

setwd("~/Documents/COURSERACleaning/UCI HAR Dataset")


# Create a vector activity labels
activity_labels <- read.table("activity_labels.txt")[,2]

# Create a vector with column names
features <- read.table("features.txt")[,2]

# (2) Get measurements names referring to the mean or standard deviation for each measurement using character vectors
a <-grepl("-mean()", features, fixed=TRUE)
b <-grepl("-std()", features, fixed=TRUE)
features1<-features[a]
features2<-features[b]
cfeatures1 <- as.character(features1)
cfeatures2 <- as.character(features2)
cfeatures <- c(cfeatures1, cfeatures2)
ucfeatures <- unique(cfeatures)


#(1) Merges the training and the test sets to create one data set.

# Read X_test, y_test and subject_test
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

names(X_test) = features

# Get the measurements on the mean and standard deviation for each measurement.
X_test = X_test[,ucfeatures]

# (3) Get activities names
y_test[,2] = activity_labels[y_test[,1]]
# Rename y_test columns to meaningful names
names(y_test) = c("Activity_ID", "Activity_Label")
# Rename subject_test columns to meaningful names
names(subject_test) = "subject"

# (1) Merge data from test sets
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Read X_train, y_train and subject_train data into data frames
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

# Rename columns in X_train
names(X_train) = features

# (2) Get the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,ucfeatures]

# (3) Get activities
y_train[,2] = activity_labels[y_train[,1]]
# Rename columns in y_train
names(y_train) = c("Activity_ID", "Activity_Label")
# Rename columns in subject_train
names(subject_train) = "subject"

# (1) Merge data from train sets
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# (1) Merge test and train data
data = rbind(test_data, train_data)

# Set a id vector
id_cols   = c("subject", "Activity_ID", "Activity_Label")
#Gets all the measure names from the original data table
data_cols = setdiff(colnames(data), id_cols)

#Use melt to create an Id vector (Subject,Activity_ID & Activity_Label) and
#a Measures vector with all the measures stacked together for each ID vector record
#melt_data is a long format file with 1 row per variable
melt_data  = melt(data, id = id_cols, measure.vars = data_cols)

# (4) Replacing labels for appropriate descriptive names.
melt_data$variable<- gsub("^t","Time_",melt_data$variable) 
melt_data$variable<- gsub("^f","Freq_",melt_data$variable)
melt_data$variable<- gsub("Acc","_acceleration",melt_data$variable)
melt_data$variable<- gsub("BodyBody","_body",melt_data$variable)
melt_data$variable<- gsub("Mag","_magnitude",melt_data$variable)
melt_data$variable<- gsub("Gyro","_gyroscope",melt_data$variable)


#(5) Create wide format (dcast) from melt_data applying mean function 
tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, fun.aggregate=mean, na.rm=TRUE)

# Write tidy_data.txt on wide format
write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)
