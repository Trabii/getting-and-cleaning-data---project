

################################################################################################
####     1. Source the clean_data function
################################################################################################


# Here is a short description what the clean_data funcion does does:
# It searchs in the current working-directory for all .txt files. 
# If the name if the file either "subjects" or "y", put it directly to the dataframe,
# Else take the mean and standard_derivation of each row, and put this to the dataframe
# It's argument indicates wheter you are regarding the test or the train files, for names and rownumber.
# Finally, it generically gives names to each variable: filename without _train.txt or _test.txt, + mena or sd 







clean_data <- function(main){
  # main indicates if you are searching for a train (7352) or a test (2947) file
  
  header <- c("d") 
  
  # initiate the correct number of rows, depending on the files (test or train)
  if (main == "test"){
    output_df <- vector(mode = "character", length = 2947) 
  } else if (main =="train") {
    output_df <- vector(mode = "character", length = 7352) 
  }
  # here an empty vector "d" is created. It is used that R can bind the vectors to something without any problem
  # It will be deleted at the end of the function
  
  
  filelist <- list.files(pattern = "\\.txt$")  # get the files of the current working folder over which the script is going to loop
  
  for (file in filelist){
    
    # read the file and get a nice name for it under "header"
    filename <- sub(paste0("_",main,".txt"),"",file) # creates a nice filename (e.g. subject out of "subject_test.txt)
    loaded_file <- read.table(file, header = FALSE) # loads that file, and stores it as "loaded_file"
    
    # now take the mean and the SD for each
    # but keep in mind that from the file "subject" or "y" you loaded_filedo not need to do that 
    
    
    if (filename == "subject"){
      output_df <- cbind(output_df, loaded_file)
      header <- c(header, "subject")  # Stores the correct column name for later
    } else if (filename == "y"){
      output_df <- cbind(output_df, loaded_file)
      header <- c(header, "y")        # Stores the correct column name for later
    } else {
      # however if the file is neither "subject" nor "y", the script should calculate mean and sd.
      
      
      # generate the mean variable and attach it to the main_data_frame (output_df)
      meanfile_name <- paste0(filename,"_mean") # Create the variable name for mean
      header <- c(header, meanfile_name) # Has to be added later on and not here, since it has only one dimension
      mean_file <- rowMeans(loaded_file) # will be added to the data frame together with the standard_derivation
      
      # and the same for the standard deviation
      standarddeviation_name <- paste0(filename,"_sd") # To create the variable name for standrad_derivation
      header <- c(header, standarddeviation_name) 
      sd_file <- apply(loaded_file, 1, sd)
      output_df <- cbind(output_df, mean_file, sd_file)
      
      # and cleaning up a bit in order to save some storage 
      rm(filename)
      rm(mean_file)
      rm(sd_file)
      rm(meanfile_name)
      rm(standarddeviation_name)
    }
  }
  # After looping over all files, and attaching them to the output_df,
  # the columns get their names
  colnames(output_df) <- header 
  
  # since in the beginning I started with some empty vectors, now, I remove them here
  output_df <- output_df[,2:dim(output_df)[2]]   # removes the empty vector from the beginning
  return(output_df)
  
}



################################################################################################
#### 2. get the correct working directory
################################################################################################

# If you did not set the WD, set it here:
# wd <- ("~/Dokumente/Data_Science/Getting and Cleaning Data/Course Project/UCI HAR Dataset")
# or if it is already set, use this line:

wd <- getwd()
wd <- paste0(wd, "/UCI HAR Dataset")
setwd(wd)


################################################################################################
#### 3. run the actual analys
################################################################################################




#starting with the train files
setwd("./train")
train1 <- clean_data("train")  # first put the first three files in the train folder together and save them
setwd("./Inertial Signals") 
train2 <- clean_data("train")  # then get the data from the folder

train <- cbind(train1, train2)  # put them together
rm(train1, train2) # cleaning up to save storage

# doing the same with the test files, and be careful to'go to the right folder ;-)
setwd(wd)
setwd("./test")
test1 <- clean_data("test")
setwd("./Inertial Signals") 
test2 <- clean_data("test")

test <- cbind(test1, test2) 
rm(test1, test2)

#finally, we want to have all 10299 observations in one single file:
final_file <- rbind(train, test)
# go back to the UCI HAR Dataset directory (such that the data is not saved in one of the folders where the 
# skirpt will loop over )

setwd(wd)
write.table(final_file, file = "final_file", row.names = FALSE)

