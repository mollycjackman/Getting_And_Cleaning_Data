############################################
#############Molly Jackman##################
#############February 20, 2015##############
#############Getting and Cleaning Data######
#############Course Project#################
############################################




####################################################################################
####################################Parts 1-4#######################################
####################################################################################
#Set the working directory
setwd("~/Dropbox/Programming/GettingCleaningData/UCI HAR Dataset/")

#Read in the features dataset
features<-read.table("features.txt")
featuresNames<-as.vector(features[,2])

##Read in the features data and labels, starting with the test data
xtest<-read.table("test/X_test.txt") 
names(xtest)<-featuresNames
ytest<-read.table("test/Y_test.txt") #activity label
names(ytest)<-"activity"
subjecttest<-read.table("test/subject_test.txt") #identifies the subject that performed activity
names(subjecttest)<-"subject_id"
data_test<-cbind(subjecttest, ytest, xtest)

##Now train
xtrain<-read.table("train/X_train.txt") 
names(xtrain)<-featuresNames
ytrain<-read.table("train/Y_train.txt") #activity label
names(ytrain)<-"activity"
subjecttrain<-read.table("train/subject_train.txt") #identifies the subject that performed activity
names(subjecttrain)<-"subject_id"
data_train<-cbind(subjecttrain, ytrain, xtrain)


##Extract just the columns that include means and standard deviations, plus the subject and activity column
dataSubsettest<-data_test[,grepl("subject_id|activity|[Mm]ean|[Ss]td", colnames(data_test))]
dataSubsettrain<-data_train[,grepl("subject_id|activity|[Mm]ean|[Ss]td", colnames(data_train))]

##Now merge the two datasets together using rbind
data<-rbind(dataSubsettest, dataSubsettrain)

##Label the activities
data$activity <- factor(data$activity, levels = c(1,2,3,4,5,6), labels = c("Walking", "Walking_Upstairs", "Walking_Downstairs", "Sitting", "Standing", "Laying"))

####################################################################################
####################################Part 5#########################################
####################################################################################
##Calculate means by group and activity
aggdata<-aggregate(data, by = list(data$subject_id, data$activity), FUN = mean)
##Get rid of extra columns, rename new variables
library(dplyr)
aggdata<-tbl_df(aggdata)
aggdata_tidy<-select(aggdata, -(3:4))
aggdata_tidy<-rename(aggdata_tidy, subject_id = Group.1)
aggdata_tidy<-rename(aggdata_tidy, activity = Group.2)
##Sort the data by subject and activity
aggdata_tidy<-aggdata_tidy[order(aggdata_tidy$subject_id, aggdata_tidy$activity),]

##Write file
write.table(aggdata_tidy, "~/Dropbox/Programming/GettingCleaningData/UCI HAR Dataset/courseproject_tidydata.txt", row.name=FALSE )