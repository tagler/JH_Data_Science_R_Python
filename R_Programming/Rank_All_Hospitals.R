rankhospital <- function(state, outcome, num = "best") {
     ## Read outcome data
     outcome_data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
     ## Check that state is valid
     state_abb <- c("AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI",
                    "ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN",
                    "MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH",
                    "OK","OR","PA","PR","RI","SC","SD","TN","TX","UT","VT","VI",
                    "VA","WA","WV","WI","WY","GU")
     if (!(state %in% state_abb )) {
          stop('invalid state')     
     }   
     ## subset first by state
     state_data <- subset(outcome_data, State==state)
     ## find outcome column name
     if (outcome == "heart attack") {
          c_name <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
     }
     if (outcome == "heart failure") {
          c_name <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
     }
     if (outcome == "pneumonia") {
          c_name <- "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
     }
     ## check outcome is valid
     if (!exists("c_name")) {
          stop('invalid outcome')
     }
     ## make hospital name and outcome data frame
     state_outcome_data <- subset(state_data, select=c("Hospital.Name",c_name))
     # converts 'Not available' to NAs 
     data_nas <- data.frame(state_outcome_data[,1],as.numeric(state_outcome_data[,2]))
     # remove rows with NAs
     no_na_data <- na.omit(data_nas)
     ## first sort by min value in column 2, then sort by alphabetical column 1
     ordered_data <- no_na_data[order(no_na_data[,2],no_na_data[,1]),]
     ## if num == best, then num =as 1
     if (num == "best") {
          num <- 1
     }
     ## if num == worst then num = number of rows (nrow(data))
     if (num == "worst") {
          num <- nrow(ordered_data)
     }
     ## if num > number of rankings, then num = NA
     if (num > nrow(ordered_data)) {
          print("rank exceeds number of hospitals")
          hospital_name_rank <- NA
          return
     }     
     hospital_name_rank <- ordered_data[num,1]
     ## Return hospital name in that state with the given rank 30-day death rate
     ## return as character vector, converts from factor 
     as.character(hospital_name_rank)
}