# Sets the vector of packages to be used in the code
packages <- c("data.table", "reshape2")

# Loads packages, checking for their presence
sapply(packages, require, character.only=TRUE, quietly=TRUE)

# Sets the working directory path
path <- "D:/КПІ/3-курс/Data Science/3 курс/4 тиждень"
setwd(path)

# Sets the URL for downloading the data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Downloads the file from the specified URL and saves it at the given path
download.file(url, file.path(path, "dataFiles.zip"))

# Unzips the downloaded archive
unzip(zipfile = "dataFiles.zip")

# Reads activity labels and feature data
activityLabels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt"), col.names = c("classLabels", "activityName"))
features <- fread(file.path(path, "UCI HAR Dataset/features.txt") , col.names = c("index", "featureNames"))

# Selects features with "mean" or "std" in their names
featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames])
measurements <- features[featuresWanted, featureNames]

# Removes parentheses from feature names
measurements <- gsub('[()]', '', measurements)

# Reads and processes training data
train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, featuresWanted, with = FALSE]
data.table::setnames(train, colnames(train), measurements)
trainActivities <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt"), col.names = c("Activity"))
trainSubjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt") , col.names = c("SubjectNum"))
train <- cbind(trainSubjects, trainActivities, train)

# Reads and processes test data
test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, featuresWanted, with = FALSE]
data.table::setnames(test, colnames(test), measurements)
testActivities <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt") , col.names = c("Activity"))
testSubjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt")   , col.names = c("SubjectNum"))
test <- cbind(testSubjects, testActivities, test)

# Combines training and test data
combined <- rbind(train, test)

# Replaces numeric activity labels with their text equivalent
combined[["Activity"]] <- factor(combined[, Activity], levels = activityLabels[["classLabels"]]   , labels = activityLabels[["activityName"]])

# Converts subject numbers to factors
combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])

# Transforms data into long format
combined <- reshape2::melt(data = combined, id = c("SubjectNum", "Activity"))

# Creates wide format, computing mean values
combined <- reshape2::dcast(data = combined, SubjectNum + Activity ~ variable, fun.aggregate = mean)

# Writes processed data to the "tidyData.txt" file in CSV format
data.table::fwrite(x = combined, file = "tidyData.txt", quote = FALSE)