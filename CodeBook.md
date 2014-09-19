### Introduction

This file describes the data, the variables, and the work that has been performed to clean up the data.

### Data Set Description

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

#### For each record it is provided:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

#### The dataset includes the following files:

* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
* 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

### Variables

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

### Work/Transformations

#### Load test and training sets and the activities

The data set has been stored in the `UCI HAR Dataset/` directory.

The R code requires `data.table` package


```
if (!require("data.table")) {
  install.packages("data.table")
}
require("data.table")
```

`read.table` is used to load the data to R environment for the data, the activities and the subject of both test and training datasets.

```
trainData_X <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
trainData_Y <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
trainData_SBJ <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
testData_X <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
testData_Y <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
testData_SBJ <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
```

#### Descriptive activity names to name the activities in the data set

`activity_labels.txt` file used for labelin for both test and train data;


```
acts <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
testData_Y$V1 <- factor(testData_Y$V1,levels=acts$V1,labels=acts$V2)
trainData_Y$V1 <- factor(trainData_Y$V1,levels=acts$V1,labels=acts$V2)
```

#### Appropriately labeling the data set with descriptive activity names

`features.txt` file used for assigning names to the columns of both test and train data set. The `Activity` and `Subject` names are also assigned to columns of `*_Y` and `*_SUBJ` data sets respectively. 

```
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
colnames(trainData_SBJ)<-c("Subject")
colnames(trainData_X)<-features$V2
colnames(trainData_Y)<-c("Activity")
colnames(testData_X)<-features$V2
colnames(testData_Y)<-c("Activity")
colnames(testData_SBJ)<-c("Subject")
```

#### Merging the training and the test sets to create one data set.

Data sets for Sets, labels and activities are appended for both test and train, and then both are merged in `data` data frame.

```
test<-cbind(testData_X,testData_Y,testData_SBJ)
train<-cbind(trainData_X,trainData_Y,trainData_SBJ)
merge<-rbind(test,train)

```

#### Extracting only the measurements on the mean and standard deviation for each measurement

The measurements for `mean` and `standard deviation` extracted form the `data` data frame.

```
ext_feats <- grepl(".*mean\\(\\)|.*std\\(\\)", features$V2)
data <-merge[,ext_feats]
```


#### Creating a second, independent tidy data set with the average of each variable for each activity and each subject.

A data table called `tidy` which includes the average of each measurement per activity and subject is created and written as a txt file to the working directory. 

```
DT <- data.table(data)
tidy<-DT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy,file="tidy.txt",sep="\t", row.names = FALSE)
```