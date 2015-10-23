library(dplyr)

#download the raw data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","dataset.zip")
unzip("dataset.zip")


trainpath<-"UCI HAR Dataset/train"
testpath<-"UCI HAR Dataset/test"
UCIpath<-"UCI HAR Dataset"

#read the raw information
#bind by column subject_test,x_test and y_test for both test and training dataset
features<-read.table(paste(sep="",UCIpath,"/features.txt"), header = FALSE,col.names = c("id","features"))
activity<-read.table(paste(UCIpath,"/activity_labels.txt",sep=""),header=FALSE,col.names=c("index","labels"))

trainsubject<-read.table(paste(trainpath,"/subject_train.txt",sep=""),header=FALSE,col.names="subject")
trainX<-read.table(paste(trainpath,"/X_train.txt",sep=""),header = FALSE,col.names=features$features)
trainY<-read.table(paste(trainpath,"/Y_train.txt",sep=""),header = FALSE,col.names="activity")
train<-cbind(trainsubject,trainX,trainY)

testsubject<-read.table(paste(testpath,"/subject_test.txt",sep=""),header=FALSE,col.names="subject")
testX<-read.table(paste(testpath,"/X_test.txt",sep=""),header = FALSE,col.names=features$features)
testY<-read.table(paste(testpath,"/Y_test.txt",sep=""),header = FALSE,col.names = "activity")
test<-cbind(testsubject,testX,testY)

#merge test and training data set together
dataset<-rbind(train,test)

#Extracts only the measurements on the mean and standard deviation for each measurement. 
dataset.meanstd<-dataset[,c(1,563,grep("(mean[^Freq]|std)",names(dataset)))]

#Uses descriptive activity names to name the activities in the data set
dataset.meanstd$activity<-factor(as.character(dataset.meanstd$activity),levels=activity$index,labels=activity$labels,ordered=is.ordered(activity$index))

#Appropriately labels the data set with descriptive variable names. 

#From the data set in step 4, creates a second, independent tidy data set with the average of each #variable for each activity and each subject.
dataset.meanstd<-tbl_df(dataset.meanstd)
dataset.meanstd.by<-group_by(dataset.meanstd,activity,subject)
dataset.activity.summary<-summarise_each(dataset.meanstd.by,funs(mean))

#write the clean data set into tidydataset.txt
write.table(dataset.activity.summary,file = "tidydataset.txt")
