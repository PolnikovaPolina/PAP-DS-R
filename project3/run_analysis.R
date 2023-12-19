# Задає вектор пакетів, які будуть використовуватися в коді
packages <- c("data.table", "reshape2")

# Завантажує пакети, перевіряючи їх наявність
sapply(packages, require, character.only=TRUE, quietly=TRUE)

# Задає шлях робочої директорії
path <- getwd("D:/КПІ/3-курс/Data Science/3 курс/4 тиждень")

# Задає URL для завантаження даних
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# Завантажує файл із вказаного URL та зберігає його у заданому шляху
download.file(url, file.path(path, "dataFiles.zip"))

# Розпаковує завантажений архів
unzip(zipfile = "dataFiles.zip")

# Зчитує дані міток активностей та ознак
activityLabels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt"), col.names = c("classLabels", "activityName"))
features <- fread(file.path(path, "UCI HAR Dataset/features.txt") , col.names = c("index", "featureNames"))

# Відбирає ознаки, які мають "mean" або "std" у їхніх назвах
featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames])
measurements <- features[featuresWanted, featureNames]

# Видаляє круглі дужки з назв ознак
measurements <- gsub('[()]', '', measurements)

# Зчитує та обробляє навчальні дані
train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, featuresWanted, with = FALSE]
data.table::setnames(train, colnames(train), measurements)
trainActivities <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt"), col.names = c("Activity"))
trainSubjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt") , col.names = c("SubjectNum"))
train <- cbind(trainSubjects, trainActivities, train)

# Зчитує та обробляє тестові дані
test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, featuresWanted, with = FALSE]
data.table::setnames(test, colnames(test), measurements)
testActivities <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt") , col.names = c("Activity"))
testSubjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt")   , col.names = c("SubjectNum"))
test <- cbind(testSubjects, testActivities, test)

# Об'єднує дані навчання та тестування
combined <- rbind(train, test)

# Замінює числові мітки активностей на їх текстовий еквівалент
combined[["Activity"]] <- factor(combined[, Activity], levels = activityLabels[["classLabels"]]   , labels = activityLabels[["activityName"]])

# Змінює номери суб'єктів на фактор
combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])

# Перетворює дані у довжинний формат
combined <- reshape2::melt(data = combined, id = c("SubjectNum", "Activity"))

# Створює широкий формат, обчислюючи середні значення
combined <- reshape2::dcast(data = combined, SubjectNum + Activity ~ variable, fun.aggregate = mean)

# Записує оброблені дані у файл "tidyData.txt" у форматі CSV
data.table::fwrite(x = combined, file = "tidyData.txt", quote = FALSE)