library(dplyr)
setwd("/Users/charlesbecker/Downloads/")

# Load test data
xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("UCI HAR Dataset/test/Y_test.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Load training data
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

# combine testing and training data and convert numeric codes to description string
xTotal <- rbind(xTrain,xTest)
yTotal <- rbind(yTrain,yTest)
yTotal <- gsub("1","WALKING",yTotal$V1)
yTotal <- gsub("2","WALKING - UPSTAIRS",yTotal)
yTotal <- gsub("3","WALKING - DOWNSTAIRS",yTotal)
yTotal <- gsub("4","SITTING",yTotal)
yTotal <- gsub("5","STANDING",yTotal)
yTotal <- gsub("6","LAYING",yTotal)
yTotal <- as.data.frame(yTotal)
subjectTotal <- rbind(subjectTrain,subjectTest)

# read features file, convert to characters and name columns with them (activity and subject as well)
features <- read.table("UCI HAR Dataset/features.txt")
var_names <- as.character(features$V2)
colnames(xTotal) <- var_names
colnames(yTotal) <- "Activity"
colnames(subjectTotal) <- "Subject"

# combine all x,y and subject data
total <- cbind(subjectTotal,yTotal,xTotal)

# pull columns that have "mean" or "std" in them as well as subject and activity column
total_subset <- total[,grep("Activity|Subject|mean|std",colnames(total))]

# use dplyr packaage to get the mean of each subsetted column and then group by both subject and activity
total_summary <- total_subset %>% group_by(Subject,Activity) %>% summarize_all(funs(mean)) 

# Write a text file of the new tidy dataset
write.table(total_mean, file = "./tidy.txt", row.names = FALSE, col.names = TRUE) 

