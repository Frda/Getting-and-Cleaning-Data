
# Please note that the trainning data set and test data set are merged at the end of the code. This may be slightly different
#than what most people may do but the results should be  the same. Thanks.


# require dplyr

library(dplyr)


##################################################### code to merge and clean Trainning DataSet###########################
# this section of code is used to extract and prepare files needed for modifying column names in the tranning dataset and test
#test dataset

#set working directory to main folder
setwd('C:\\Users\\1\\Downloads\\getdata-projectfiles-UCI HAR Dataset (1)\\UCI HAR Dataset')

#import features file this file contains header descriptions for train file. 
features <- as.data.frame(read.table('features.txt',  stringsAsFactors = F))

#select column V2 which contains descriptions for heads of train file. 
features_Headers <- as.character(features[,'V2'])

#import activity file which contains descriptions for activity types
activity_labels <- as.data.frame(read.table('activity_labels.txt',  stringsAsFactors = F))

#rename column headers
names(activity_labels) <- c('ActivityKey', 'ActivityValue')







##################################################### code to merge and clean Trainning DataSet###########################



#set working directory of trainning set 
  setwd('C:\\Users\\1\\Downloads\\getdata-projectfiles-UCI HAR Dataset (1)\\UCI HAR Dataset\\train')

#import x_train file this file contains information measuments for activities
X_train <-as.data.frame( read.table('X_train.txt',  stringsAsFactors = F))


#import subject_test file this file contains information about test Subject and thier identities
subject_train <-as.data.frame(read.table('subject_train.txt',  stringsAsFactors = F))
  
    #Give the test subject header name a more descriptive name called 'Subject_ID'
    names(subject_train) <- 'Subject_ID'


#import y_train file this file contains information about actvity labels and their interpretation
y_train <- as.data.frame(read.table('y_train.txt',  stringsAsFactors = F))
    
    #Give the activity header name a more descriptive name called 'ActivityKey'
    names(y_train) <-'ActivityKey'


    #rename columns headers in X_train with values from features_Headers
    names(X_train)  <- features_Headers

    #Get columns names that have only mean and std in their column names meanfrequency has been excluded
    mean_vals <-  grep('mean\\(',names(X_train), value = T)
    std_vals <-    grep('std',names(X_train), value = T)

    #combine columns containing std and mean into one vector stdAndmean
    stdAndmean <- as.vector( c(mean_vals,std_vals))

    #subset only columns contanning std and mean into the x_train table
    X_train <- X_train[stdAndmean]

    #combine all data table into one table 
    combined_results_Trainning <- cbind(train,y_train,X_train)

    #Create a new column to distinguish Trainset data from test set data
    combined_results_Trainning['Set_Type'] = 'TrainSet'

    # create unique id for test subject by activity
    for(n in 1:nrow(combined_results_Trainning)){
      combined_results_Trainning[n,'Unique_ID'] = paste(combined_results_Trainning[n,'Subject_ID'],combined_results_Trainning[n,'ActivityKey'],combined_results_Trainning[n,'Set_Type'],sep='_')
    }

    # join combined_results with activity file to get a better description of activity 

    combined_results_Trainning <-    combined_results_Trainning%>%left_join(activity_labels, by = 'ActivityKey')


    ##################################################### code to merge and clean test DataSet###########################
    
    
    
    #set working directory of trainning set 
    setwd('C:\\Users\\1\\Downloads\\getdata-projectfiles-UCI HAR Dataset (1)\\UCI HAR Dataset\\test')
    
    #import x_train file this file contains information measuments for activities
    X_test <-as.data.frame( read.table('X_test.txt',  stringsAsFactors = F))
    
    
    #import subject_test file this file contains information about test Subject and thier identities
    subject_test <-as.data.frame(read.table('subject_test.txt',  stringsAsFactors = F))
    
    #Give the test subject header name a more descriptive name called 'Subject_ID'
    names(subject_test) <- 'Subject_ID'
    
    unique(subject_test)
    
    #import y_train file this file contains information about actvity labels and their interpretation
    y_test <- as.data.frame(read.table('y_test.txt',  stringsAsFactors = F))
    
    #Give the activity header name a more descriptive name called 'ActivityKey'
    names(y_test) <-'ActivityKey'
    
    
    #rename columns headers in X_train with values from features_Headers
    names(X_test)  <- features_Headers
    
    #Get columns names that have only mean and std in their column names meanfrequency has been excluded
    mean_vals_test <-  grep('mean\\(',names(X_test), value = T)
    std_vals_test <-    grep('std',names(X_test), value = T)
    
    #combine columns containing std and mean into one vector stdAndmean
    stdAndmean_test <- as.vector( c(mean_vals_test,std_vals_test))
    
    #subset only columns contanning std and mean into the x_train table
    X_test <- X_test[stdAndmean_test]
    
    #combine all data table into one table 
    combined_results_test <- cbind(subject_test,y_test,X_test)
    
    #Create a new column to distinguish Trainset data from test set data
    combined_results_test['Set_Type'] = 'TestSet'
    
    #create unique id for test subject by activity
    for(n in 1:nrow(combined_results_test)){
      combined_results_test[n,'Unique_ID'] = paste(combined_results_test[n,'Subject_ID'],combined_results_test[n,'ActivityKey'],combined_results_test[n,'Set_Type'],sep='_')
    }
    
    # join combined_results with activity file to get a better description of activity 
    
    combined_results_test <-combined_results_test%>%left_join(activity_labels, by = 'ActivityKey')
    
    
    
   ##################################################### code to combine test and tranning dataset ###########################

   
    #merge tranning set with test set
    All_merged_data <- as.data.frame( rbind(combined_results_test,combined_results_Trainning) )
    
    #calculate the means of all activities using dplyr functionality
    Means_of_all_activity<-  All_merged_data%>% group_by(Subject_ID,ActivityKey,Set_Type,Unique_ID,ActivityValue) %>% summarise_each(funs(mean))
  

 
    # replace the column names to reflect the fact that the means have been taken for those columns
    for(n in 1: length(names(Means_of_all_activity))){
      
      names(Means_of_all_activity)[n] <- paste('Means of ',  names(Means_of_all_activity)[n])
    }
    

  #write out the table for all the original data
   write.table(All_merged_data,'All_merged_data.txt',row.names = F,sep='\t')
   
   #write out the tidy data set for the summarised information. NO duplications of observations or variables. 
   write.table(Means_of_all_activity,'Means_of_all_activity.txt',row.names = F,sep='\t')
    
    
   