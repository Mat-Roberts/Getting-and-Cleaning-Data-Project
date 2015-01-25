
trainDataX <- read.table("./dataset/train/X_train.txt")
trainDataY <- read.table("./dataset/train/Y_train.txt")
trainDataSubject <- read.table("./dataset/train/subject_train.txt")
testDataX <- read.table("./dataset/test/X_test.txt")
testDataY <- read.table("./dataset/test/Y_test.txt")
testDataSubject <- read.table("./dataset/test/subject_test.txt")

dataX <- rbind(trainDataX, testDataX)
dataY <- rbind(trainDataY, testDataY)
dataSubject <- rbind(trainDataSubject, testDataSubject)

featureNames <- read.table("./dataset/features.txt")[,2]
meanStd <- grep("mean\\(\\)|std\\(\\)", featureNames[, 2])

dataX <- dataX[,meanStd]

names(dataX) <- gsub("\\(\\)", "", featureNames[meanStd, 2])
names(dataX) <- gsub("-", "", names(dataX))

activityNames <-  c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
activities <- activityNames[dataY]

tidy <- cbind(Subject = dataSubject, Activity = activities, dataX)


limitedColMeans <- function(data) { colMeans(data[,-c(1,2)]) }
tidyMeans <- ddply(tidy, .(Subject, Activity), limitedColMeans)
names(tidyMeans)[-c(1,2)] <- paste0("Mean", names(tidyMeans)[-c(1,2)])

write.table(tidyMeans, "tidyMeans.txt", row.names = FALSE)

