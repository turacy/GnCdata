Getting and Cleaning Data - Course Assignment
=======
# Description

`run_Analysis.R` code has been created to do the tasks mentioned below;
 - Merging the training and the test sets to create one data set.
 - Extracting only the measurements on the mean and standard deviation for each measurement
 - Using descriptive activity names to name the activities in the data set
 - Appropriately labeling the data set with descriptive activity names. 
 - Creating a second, independent tidy data set with the average of each variable for each activity and each subject.
 
## Requirements
 
The data sets can be found at `UCI HAR Dataset` directory. To run the code this directory must be located at your R working directory. Alternatively you can set your working directory with `setwd()` function and locate the data sets at this directory.

The R code uses the `data.table` package. If you don't have the package, code will automatically download and install the package. 

## Runnig code Step-by-step

 - Download the data sets and locate at your working directory.
 - Run the `run_Analysis.R` code. 
    
## Output

The code will produce two data sets called `merge` and `data` and a text file called `tidy.txt`. The "merge" data set consists of test and train sets. The "data" set consists of the measurements on mean and standard deviation. Finally, tidy.txt file is an independent tidy data set with the average of each variable for each activity and each subject.