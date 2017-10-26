rankall <- function(outcome, num = "best") {
     
     ## make empty data frame to keep track of results
     results <- data.frame(hospital=character(0),state=character(0))
     
     ## states
     state_abb <- c("AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI",
                    "ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN",
                    "MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH",
                    "OK","OR","PA","PR","RI","SC","SD","TN","TX","UT","VT","VI",
                    "VA","WA","WV","WI","WY","GU")
     
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
     
     ## Read outcome data
     outcome_data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
     
     ## make hospital name and outcome data frame
     outcome_data_all_states <- subset(outcome_data, select=c("Hospital.Name","State",c_name))
     
     #loop through all states
     for (i in state_abb) {
          
          ## reset index ***because worst for each state is a different index
          num_index <- num
          
          ## subset by state
          state_data_outcome <- subset(outcome_data_all_states, State==i)
          
          # converts 'Not available' to NAs 
          data_nas <- data.frame(state_data_outcome[,1],
                                 state_data_outcome[,2],
                                 as.numeric(state_data_outcome[,3]),
                                 stringsAsFactors=FALSE)
          
          # remove rows with NAs
          no_na_data <- na.omit(data_nas)
          
          ## first sort by min value in column 2, then sort by alphabetical column 1
          ordered_data <- no_na_data[order(no_na_data[,3],no_na_data[,1]),]
          
          ## if num_index == best, then = 1
          if (num_index == "best") {
               num_index <- 1
          }
          ## if num_index == worst then = number of rows (nrow(data))
          if (num_index == "worst") {
               num_index <- nrow(ordered_data)
          }
          
          ## row containing hospital, state, and outcome that num_index coresponds to 
          hospital_name_state_rank <- ordered_data[num_index,]
          
          ## if num_index > number of rankings, then add state to <NA> value
          if (num_index > nrow(ordered_data)) {
               ## not available 
               hospital_name_state_rank[1,2] <- i
          }     
          
          ## append row to results data frame 
          results <- rbind(results,hospital_name_state_rank)
          
     }
     
     results_final <- data.frame(hospital=results[,1],state=results[,2], stringsAsFactors=FALSE)
     
     ## For each state, find the hospital of the given rank
     ## Return a data frame with the hospital names and the
     ## (abbreviated) state name
     results_final
}
