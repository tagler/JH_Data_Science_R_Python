best <- function(state, outcome) {
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
     ## make  hospital name and outcome data frame
     state_outcome_data <- subset(state_data, select=c("Hospital.Name",c_name))
     ## sort into alphabetical order 
     ordered_state_outcome_date <- state_outcome_data[order(state_outcome_data$Hospital.Name), ]
     ## Return hospital name in that state with lowest 30-day death rate
     find_min <- which.min(ordered_state_outcome_date[,2])
     hospital_answer <- ordered_state_outcome_date[find_min,1]
     hospital_answer
}


