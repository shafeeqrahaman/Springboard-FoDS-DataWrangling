library(dplyr)
library(tidyr)

# 0: Load the data in RStudio
titanic_original <- read.csv("titanic_original.csv")

# 1: Port of embarkation (base R) 
# titanic_original$embarked[titanic_original$embarked == ""] <- "S" 

# 2: Age (base R) 
# titanic_original$age[is.na(titanic_original$age)] <- round(mean(titanic_original$age, na.rm = TRUE))

# 3: Lifeboat (base R)
# titanic_original$boat[titanic_original$boat == ""] <- NA

titanic_clean <- titanic_original %>% 
  mutate(
    # 1: Port of embarkation 
    embarked = replace(embarked, embarked == "", "S"), 
    
    # 2: Age 
    age = replace(age, is.na(age), round(mean(age, na.rm = TRUE))), 
    
    # 3: Lifeboat 
    boat = replace(boat, boat == "", NA), 
    
    # 4: Cabin
    has_cabin_number = ifelse(cabin == "",0,1)
  )

# 6: Submit the project on Github
write.csv(titanic_clean, file = "titanic_clean.csv", row.names = FALSE)

# Task 2.2: Think about other ways you could have populated the missing values in the age column. Why would you pick any of those over the mean (or not)?
#   *Mean +/- 0.5* - as other estimated ages are in the form of **xx.5**.
#   *Median*, OR *Mean by Sex (male vs female)*.
#   All results are very close *(between 28-31)*, so without any further analysis, using the **Mean** seems to be the best way forward for now.

# Task 4: You notice that many passengers don't have a cabin number associated with them.
# Does it make sense to fill missing cabin numbers with a value?
#   Unless we can identify how the cabin numbers are coded, it doesn't make any sense to guess and fill in the missing values. 
# What does a missing value here mean?
#   Either the cabin number is Unknown OR the passenger didn't have a dedicated cabin - in which case, just the has_cabin_number flag should still help with further analysis.
