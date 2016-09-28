

## Load package environment
library("readr", lib.loc="~/R/win-library/3.3")       
library("tidyr", lib.loc="~/R/win-library/3.3")
library("dplyr", lib.loc="~/R/win-library/3.3")
library("plyr",  lib.loc="~/R/win-library/3.3")
library("knitr", lib.loc="~/R/win-library/3.3")
library("caTools", lib.loc="~/R/win-library/3.3")
library("rmarkdown", lib.loc="~/R/win-library/3.3")

## Read in data files
basic_path <- file.path("./" , "UCI HAR Dataset")
files<-list.files(basic_path, recursive=TRUE)
files

# Read the Subject files------------
ActivityTest  <- read.table(file.path(basic_path, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrain <- read.table(file.path(basic_path, "train", "Y_train.txt"),header = FALSE)
# Read the Subject files-----
SubjectTrain <- read.table(file.path(basic_path, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(basic_path, "test" , "subject_test.txt"),header = FALSE)
# Read Fearures files ---------
FeaturesTest  <- read.table(file.path(basic_path, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain <- read.table(file.path(basic_path, "train", "X_train.txt"),header = FALSE)


## Merge test and train observations ------------
datSubject <- rbind(SubjectTrain, SubjectTest)
datActivity<- rbind(ActivityTrain, ActivityTest)
datFeatures<- rbind(FeaturesTrain, FeaturesTest)

## rename variable ----
names(datSubject)<-c("subject")
names(datActivity)<- c("activity")
datFeaturesNames <- read.table(file.path(basic_path, "features.txt"),head=FALSE)
names(datFeatures)<- datFeaturesNames$V2

### #3
## facorize Variale activity using descriptive activity names
activityLabels <- read.table(file.path(basic_path, "activity_labels.txt"),header = FALSE)
datActivity1 <- rbind(ActivityTrain, ActivityTest)
datActivity1.f <- factor(datActivity1$V1, labels = activityLabels$V2)
datActivity1 <- data.frame(datActivity1.f)
names(datActivity1)<- c("activity")
## Read descriptive activity names
head(datActivity1,30)

### #1
## Merge columns to get the data frame Data for all data
dsCombine <- cbind(datSubject, datActivity1)
ds1 <- cbind(datFeatures, dsCombine)

### #2
## Subset Features by mean and standard deviation
subdatFeaturesNames<-datFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", datFeaturesNames$V2)]

## Subset ds1 by Selected features
selectedNames<-c(as.character(subdatFeaturesNames), "subject", "activity" )
ds1 <- subset(ds1, select=selectedNames)

### #4
## Create readable variable names
names(ds1)<-gsub("^t", "time", names(ds1))
names(ds1)<-gsub("^f", "frequency", names(ds1))
names(ds1)<-gsub("Acc", "Accelerometer", names(ds1))
names(ds1)<-gsub("Gyro", "Gyroscope", names(ds1))
names(ds1)<-gsub("Mag", "Magnitude", names(ds1))
names(ds1)<-gsub("BodyBody", "Body", names(ds1))
head(ds1)
write.table(ds1, file = "tidydata.txt",row.name=FALSE)


### #5
## Create a 2nd tidydataset with average of each variable 
ds2 <- aggregate(. ~subject + activity, ds1, mean)
ds2 <- ds2[order(ds2$subject,ds2$activity),]
head(ds2)
write.table(ds2, file = "tidydata2.txt",row.name=FALSE)

