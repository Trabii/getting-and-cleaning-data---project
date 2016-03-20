# getting-and-cleaning-data---project

The run_analys.R consists of three parts.

1. `clean_data function`:

   - This function is also the core of the work. It scans through the working directory for any .txt file.
   - Its argument is main, and should be "test" or "train". This helps to initiate automatized naming of the variables.
    Also this information provides information for creating an empty vector of a specific length. (For train 7352, or test 2947 rows) This given length is used that there are no errors when putting the vectors together (next step).
  -  When it reads a file, the script checks if it makes sense to take mean and standardderivation (sd). 
    For instance for the y and subject variable, it doesn't make sens to take the mean, or it cannot even take a sd from one-dimensional vectors. 
   - However, should it be the case, that it is any of the other file, it will calculate the mean and sd of each row, and saves these as vectors. Then it "cbinds" it to the already existing dataframe (if there is nothing yet, to the empty vector).
    - While looping over the files in the working directory, the skrip also creates the variable names. This is: Take the name of the file (e.g. X_test.txt), remove the last part (_test.txt) and use the remaining (X) as variable name. If you take the mean, add _mean (for sd add _sd) to X. So the names that are generated will be X_mean, X_sd. 
    - Last but not least, the names are getting attached to the output matrix, and the empty vector from the beginning is removed. 
    - Most of the files that are red contain many rows, and many columns. The mean and sd is calculated for each row over all the columns.
    - For further information, please have a look at the code, where everything is well commented



2. Directory:
    - This part only makes sure that the next part can run properly. It requires that you set the WD before running the code to the directory where the samsung data is stored. If the code is not running, check that you set the directory correctly, or you can change the code here manually.

3. Go through all the folders using the clean_data function
    - Basically the code jumps from folder to folder, and calls the function `clean_data` on each directory, and saves parts of the final file, and puts the two train files as well as the two test files together. 
    - Finally the program puts the new train and the new test file together into one final_file, and saves it.
