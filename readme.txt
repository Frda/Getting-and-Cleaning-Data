Steps required to reproduce results

         Data prepration

1) Import the features file into a table called features.
2) select column 2 which is named as 'V2' from the data table this information will be used to repalce the column headers for X_train and X_test.
3) Import activity_lables.txt into datatable activity_labels.This data table will be used to give descriptive names to the activity type in the final table.
4) rename activity_lable headers with descriptive headers to 'ActivityKey', 'ActivityValue'

			code to merge and clean Trainning DataSet

1) Import all the files for the tranning data set X_train, y_train and subject_train.
2) Replace the subject header for the trainning set with "Subject_ID".
3) Replace teh subject header for y_train with ActivityKe
5) change the name of X_train header values with vector "feature Headers" 
   which was created in the data preparation step. This gives the data table a more descriptive names than V1 v2    and such
6) use grep to obtain only columns that have mean and std in their description and add them to one vector called stdAndMean
7) combine all the different tables into a major data set by doing the followin cbind(train,y_train,X_train)
8) # optinal create a new column to identify rows comming from the trainning dataset fill values for these with the value    'TrainSet'
9)  # optinal create a unique Id for each dataset type by combining Subject_ID','ActivityKey','Set_Type' this also should in case the same values are overlaping in the test data set and trainning data set.

10) The last step is to  join the combined dataset with the activity dataset so that descriptive activities can be added to 	the anlaysis as activity label. The final set is called combined_results_Trainning


                     code to merge and clean test DataSet 
The above steps are completed for the test dataset too. see steps 1 through 10 above.
save the resulting data set as combined_results_test


                     code to merge all tranning set and test set.

1) using rbind combined_result_test and combined_results_Trainning into one data table.

2) use dplyr's group by and sumarise functions to create a tidy dataset for the means of all the means and std columns

3) write the data tables out to a file using the write.table function. 