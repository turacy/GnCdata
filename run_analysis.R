## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
if (!require("data.table")) {
  install.packages("data.table")
}
require("data.table")

# 0. Load tables (test,training and the activities)
#### TRAIN DATA ####
trainData_X <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
trainData_Y <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
trainData_SBJ <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
#### TEST DATA ####
testData_X <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
testData_Y <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
testData_SBJ <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)


# 3. Uses descriptive activity names to name the activities in the data set
acts <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
testData_Y$V1 <- factor(testData_Y$V1,levels=acts$V1,labels=acts$V2)
trainData_Y$V1 <- factor(trainData_Y$V1,levels=acts$V1,labels=acts$V2)

# 4. Appropriately labels the data set with descriptive activity names
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
#### TRAIN DATA ####
colnames(trainData_SBJ)<-c("Subject")
colnames(trainData_X)<-features$V2
colnames(trainData_Y)<-c("Activity")
#### TEST DATA ####
colnames(testData_X)<-features$V2
colnames(testData_Y)<-c("Activity")
colnames(testData_SBJ)<-c("Subject")


# 1. merge test and training sets into one data set, including the activities
test<-cbind(testData_X,testData_Y,testData_SBJ)
train<-cbind(trainData_X,trainData_Y,trainData_SBJ)
merge<-rbind(test,train)

# 2. extract only the measurements on the mean and standard deviation for each measurement
ext_feats <- grepl(".*mean\\(\\)|.*std\\(\\)", features$V2)
data <-merge[,ext_feats]

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
DT <- data.table(data)
tidy<-DT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy,file="tidy.txt",sep="\t", row.names = FALSE)
#### end of code ###