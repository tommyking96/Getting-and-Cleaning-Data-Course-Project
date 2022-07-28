features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

x_binded <- rbind(x_train, x_test)
y_binded <- rbind(y_train, y_test)
subject_binded <- rbind(subject_train, subject_test)
data <- cbind(subject_binded, y_binded, x_binded)

View(data)

library(dplyr)
mean_std <- select(data, subject, code, contains("mean"), contains("std"))
View(mean_std)

mean_std$code <- activities[data$code, 2]
#data$code
#activities
#mean_std
View(mean_std)

names(mean_std)[names(mean_std) == "code"] = "activity"
names(mean_std)<-gsub("Acc", "Accelerometer", names(mean_std))
names(mean_std)<-gsub("Gyro", "Gyroscope", names(mean_std))
names(mean_std)<-gsub("BodyBody", "Body", names(mean_std))
names(mean_std)<-gsub("Mag", "Magnitude", names(mean_std))
names(mean_std)<-gsub("^t", "Time", names(mean_std))
names(mean_std)<-gsub("^f", "Frequency", names(mean_std))
names(mean_std)<-gsub("tBody", "TimeBody", names(mean_std))
names(mean_std)<-gsub("-mean()", "Mean", names(mean_std), ignore.case = TRUE)
names(mean_std)<-gsub("-std()", "STD", names(mean_std), ignore.case = TRUE)
names(mean_std)<-gsub("-freq()", "Frequency", names(mean_std), ignore.case = TRUE)
names(mean_std)<-gsub("angle", "Angle", names(mean_std))
names(mean_std)<-gsub("gravity", "Gravity", names(mean_std))
View(mean_std)

summarized <- mean_std %>%
  group_by(subject, activity) %>%
  summarise_all(mean)
write.table(summarized, "summarized.txt", row.name=FALSE)

head(summarized)
summarized
