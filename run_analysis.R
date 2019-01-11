library(dplyr)
##load data
xtest<-read.table("C:\\Users\\Nick\\Documents\\Coursera\\UCI HAR Dataset\\test\\X_test.txt")
ytest<-read.table("C:\\Users\\Nick\\Documents\\Coursera\\UCI HAR Dataset\\test\\y_test.txt")
subjecttest<-read.table("C:\\Users\\Nick\\Documents\\Coursera\\UCI HAR Dataset\\test\\subject_test.txt")
xtrain<-read.table("C:\\Users\\Nick\\Documents\\Coursera\\UCI HAR Dataset\\train\\X_train.txt")
ytrain<-read.table("C:\\Users\\Nick\\Documents\\Coursera\\UCI HAR Dataset\\train\\y_train.txt")
subjecttrain<-read.table("C:\\Users\\Nick\\Documents\\Coursera\\UCI HAR Dataset\\train\\subject_train.txt")
features<-read.table("C:\\Users\\Nick\\Documents\\Coursera\\UCI HAR Dataset\\features.txt")
actlabel<-read.table("C:\\Users\\Nick\\Documents\\Coursera\\UCI HAR Dataset\\activity_labels.txt")

#Merge training and test sets into one data set using rbind
xall<-rbind(xtrain,xtest)
yall<-rbind(ytrain,ytest)
subjectall<-rbind(subjecttrain,subjecttest)

#Uses descriptive activity names to name the activities in the data set
colnames(xall) <- features[,2]
colnames(yall) <- "activity"
colnames(subjectall) <- "subject"

Mergeall <- cbind(subjectall,yall,xall)

#Extracts only the measurements on the mean and standard deviation for each measurement using grep
extract<- grepl("*mean\\(\\)|*std\\(\\)|activity|subject",names(Mergeall))
select <- Mergeall[,extract]

#replace activity number with better discription
labeldata<-merge(select,actlabel, by.x="activity", by.y="V1")
#rename new col
colnames(labeldata)[69] <- "activityname"
#move col to start of table so it is not at the end of the table  
labeldata2 <- labeldata[,c(1,69,2:68)]  

# create a second, independent tidy data set with the average of each variable for each activity and each subject. 
Final <- aggregate(labeldata2[,names(labeldata2)  != c('activity','subject','activityname')], by=list(activity=labeldata2$activity,subject=labeldata2$subject),mean)
Final <- merge(Final,actlabel, by.x="activity", by.y="V1")
Final$activityname <- Final$V2
#write out final table
write.table(Final,"C:\\Users\\Nick\\Documents\\Coursera\\Peer-graded Assignment Getting and Cleaning Data Course Project\\TidyData.txt")






