pollutantmean <- function(directory, pollutant, id = 1:332) {
     # load all file names
     all_files <- list.files(path=directory, full.names = TRUE)
     # selected files from user
     selected_files <- all_files[id]
     # import dat
     for (i in selected_files) {
          # first file
          if (!exists("my_data")) {
               my_data <- read.csv(i)
          }
          # multiple files
          else {
               my_data_temp <- read.csv(i)
               my_data <- rbind(my_data,my_data_temp)
               rm(my_data_temp)
          }
     }
     # select which pollutant
     my_data_pollutant <- my_data[pollutant]
     my_data_pollutant_na <- my_data_pollutant[!is.na(my_data_pollutant)]
     # take mean
     mean_pollutant <- mean(my_data_pollutant_na, na.rm = TRUE)
     # print/return mean 
     mean_pollutant 
}