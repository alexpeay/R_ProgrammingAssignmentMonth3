
setwd("/Users/alexpeay/Desktop/UCI HAR Dataset/")

if (!require("data.table")) {
 install.packages("data.table")
}

require("data.table")

if (!require("reshape2")) {
 install.packages("reshape2")
}

require("reshape2")


labels <- read.table("activity_labels.txt")[,2]

column_names <- read.table("features.txt")[,2]

measurements <- grepl("mean|std", column_names)

test_x <- read.table("test/X_test.txt")
test_y <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

names(test_x) = column_names

test_x = test_x[,measurements]

test_y[,2] = labels[test_y[,1]]
names(test_y) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

test_data <- cbind(as.data.table(subject_test), test_y, test_x)

train_x <- read.table("train/X_train.txt")
train_y <- read.table("train/y_train.txt")

subject_train <- read.table("train/subject_train.txt")

names(train_x) = column_names

train_x = train_x[,measurements]

train_y[,2] = activity_labels[train_y[,1]]
names(train_y) = c("ID", "Label")
names(subject_train) = "subject"

train_data <- cbind(as.data.table(subject_train), train_y, train_x)

data = rbind(test_data, train_data)

id_labels   = c("subject", "ID", "Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")
