#https://class.coursera.org/getdata-016/forum/thread?thread_id=50#comment-333

##Merging the training and the test sets to 
##create one data set.

#Read in the files

#features.txt
filepath<-".\\data\\features.txt"
features<-read.table(filepath)


#activitylabels.txt
filepath<-".\\data\\activity_labels.txt"
activity_labels<-read.table(filepath)


#subject_test
filepath<-".\\data\\test\\subject_test.txt"
subject_test<-read.table(filepath)


#X_test
filepath<-".\\data\\test\\X_test.txt"
X_test<-read.table(filepath)



#Y_test
filepath<-".\\data\\test\\Y_test.txt"
Y_test<-read.table(filepath)


#subject_train
filepath<-".\\data\\train\\subject_train.txt"
subject_train<-read.table(filepath)


#X_train
filepath<-".\\data\\train\\X_train.txt"
X_train<-read.table(filepath)


#Y_train
filepath<-".\\data\\train\\Y_train.txt"
Y_train<-read.table(filepath)


#Examine table dimensions
dim(features)
dim(activity_labels)
dim(subject_test)
dim(X_test)
dim(Y_test)
dim(subject_train)
dim(X_train)
dim(Y_train)

#confirm all are data frames
class(features)
class(activity_labels)
class(subject_test)
class(X_test)
class(Y_test)
class(subject_train)
class(X_train)
class(Y_train)


str(features)
str(activity_labels)
str(subject_test)
str(X_test)
str(Y_test)
str(subject_train)
str(X_train)
str(Y_train)


#cbind to put in person and activity columns
X_test$activity <- Y_test[,1]
X_test$person <- subject_test[,1]

X_train$activity <- Y_train[,1]
X_train$person <- subject_train[,1]

#confirm new columns
dim(X_test)
summary(X_test$person)
summary(X_test$activity)

dim(X_train)
summary(X_train$person)
summary(X_train$activity)

#rbind to merge
data<-rbind(X_test, X_train)

#confirm new rows

dim(data)

##Extracting only the measurements on the mean and standard
##deviation for each measurement. 



#use second column of features object to replace
#generic names for the data set
#add column names "person" and "activity" to features
features$V2<-as.character(features$V2)
names(data) <- features[,2]
features[nrow(features)+1,2]<-"activity"
features[nrow(features)+1,2]<-"person"




#the substrings "-mean" and "-std" are in all of the columns names of inters
# and no others
# column names with the strings "mean" and "std" and not "-"
# are not of interest because those are
# calculations, not measurements

#"data" will be subsetted for columns with column names
# that contain "-mean", "-std", "person", or "activity

#datastdmean<-select(data, contains("mean()"),contains("std()"),contains("person"),contains("activity"))
#last command in previous comment gives an error
# because of duplicated column names
#so check which column are duplicated
names(data)[duplicated(names(data))]

#all duplicated names are not of interest
#so, since none of those columns are of interest, 
#it's fine to remove those columns from the data
datanodups <- data[,!duplicated(names(data))]

#now that commented out line should run fine
datastdmean<-select(datanodups, contains("mean()"),contains("std()"),contains("person"),contains("activity"))

dim(datastdmean)

##Name activities with descriptive activity names
names(activity_labels)
class(activity_labels$V1)
class(datastdmean$activity)
class(activity_labels$V2)
#?activity_labels$V2<-as.character(activity_labels$V2)



#match(datastdmean$activity,table(activity_labels$V1,activity_labels$V2)))
library(qdap)
datastdmean$activity <- as.factor(datastdmean$activity)
labels(datastdmean$activity) <- activity_labels$V2
datastdmean$activitylabels<-factor(datastdmean$activity, activity_labels$V1,labels=activity_labels$V2)


dim(datastdmean)
#get rid of extra columns
datastdmean<-select(datastdmean,-activity,-activitydup)


names(datastdmean)
names(datastdmean)<-make.names(names(datastdmean))
class(datastdmean$activitylabels)

library(plyr)
library(dplyr)
step5table <- summarise_each(group_by(datastdmean, 
          person, activitylabels), 
          funs(mean))

filepath<-".\\step5table.txt"
write.table(step5table,file=filepath)

