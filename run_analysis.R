library(dplyr)
library(tidyr)

# 0: Load the data in RStudio
features <- read.table("UCI HAR Dataset/features.txt") 
features <- features %>% 
  setNames(c("Key", "Name")) %>% 
  mutate(Name = make.names(Name, unique = TRUE)) 

act_labels <- read.table("UCI HAR Dataset/activity_labels.txt") 
act_labels <- act_labels %>% 
  setNames(c("ActivityLabel", "ActivityName"))

test_act <- read.table("UCI HAR Dataset/test/y_test.txt") 
test_act <- test_act %>% 
  setNames(c("ActivityLabel")) 

test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt") 
test_subject <- test_subject %>%
  setNames(c("Subject"))

test <- read.table("UCI HAR Dataset/test/X_test.txt") 
test <- test %>% 
  setNames(features$Name) %>% 
  mutate(ActivityLabel = test_act$ActivityLabel, Subject = test_subject$Subject)

train_act <- read.table("UCI HAR Dataset/train/y_train.txt") 
train_act <- train_act %>% 
  setNames(c("ActivityLabel")) 

train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt") 
train_subject <- train_subject %>%
  setNames(c("Subject"))

train <- read.table("UCI HAR Dataset/train/X_train.txt")
train <- train %>% 
  setNames(features$Name) %>% 
  mutate(ActivityLabel = train_act$ActivityLabel, Subject = train_subject$Subject)

# 1: Merge data sets
ucihar <- bind_rows(test, train)

# 2: Mean and standard deviation
ucihar <- ucihar %>% 
  mutate(ActivityMean = rowMeans(ucihar), ActivityStdDev = apply(ucihar, 1, sd)) 

# 3: Add new variables
ucihar <- left_join(ucihar, act_labels, by = "ActivityLabel")

# 4: Create tidy data set
run_analysis <- ucihar %>% 
  group_by(ActivityLabel, ActivityName, Subject) %>% 
  summarise_each(funs(mean(., na.rm = TRUE))) 
  
# 5: Submit on github
write.csv(run_analysis, file = "run_analysis.csv", row.names = FALSE)
