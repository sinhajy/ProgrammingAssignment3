run_analysis <- function() {

setwd("C:/Git-2.14.0/Repositories/ProgrammingAssignment3/getdata projectfiles FUCI HAR Dataset/UCI HAR Dataset")
  
##Required columns (index) from features.txt
f<-read.table("features.txt",sep=" ",header = FALSE)
required_cols<-f[c(grep("mean\\(\\)",f$V2),grep("std\\(\\)",f$V2)),]

##Read training data
f1<-read.table("train/X_train.txt")
##Read test data
f2<-read.table("test/X_test.txt")
##Combine data
fd<-rbind(f1,f2)
##Remove intermediate
rm(f)
rm(f1)
rm(f2)
##Keep required cols
fd<-fd[,required_cols[,1]]

##Set meaningful names
required_cols[,2]<-gsub("-","_",required_cols[,2])
required_cols[,2]<-gsub("\\(\\)","",required_cols[,2])

names(fd)<-as.vector(required_cols[,2])

##Read activity codes
activity_code_train<-read.table("train/y_train.txt")
activity_code_test<-read.table("test/y_test.txt")
activity_code<-rbind(activity_code_train,activity_code_test)
rm(activity_code_train)
rm(activity_code_test)

##Read activity label (descriptions..)
activity_label<-read.table("activity_labels.txt")

##Get activity as per codes
activity <- activity_label[activity_code$V1,]

##Add column in final data set fd
fd$Activity <- activity$V2

##Read subject codes
subject_code_train<-read.table("train/subject_train.txt")
subject_code_test<-read.table("test/subject_test.txt")
subject_code<-rbind(subject_code_train,subject_code_test)$V1

rm(subject_code_train)
rm(subject_code_test)
##Add column in final data set fd
fd$Subject<-subject_code

##Prepare column list for average calculation
col_list<-paste0("avg(",required_cols[,2],"),",collapse = "")

##Create query for final output - use sqldf library
qry<-paste0("select ",col_list,"Activity, Subject from fd group by Activity, Subject")

library(sqldf)
fd_out<-sqldf(qry)

write.table(fd_out, "tidy_data.txt", row.names = FALSE)
rm(fd_out)
}

run_analysis()