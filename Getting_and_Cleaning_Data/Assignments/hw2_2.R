acs <- read.csv("getdata-data-ss06pid.csv")

library(sqldf)

sqldf("select pwgtp1 from acs where AGEP < 50")
sqldf("select * from acs where AGEP < 50")
sqldf("select * from acs")
sqldf("select pwgtp1 from acs")

unique(acs$AGEP)

sqldf("select unique * from acs")
sqldf("select distinct pwgtp1 from acs")
sqldf("select distinct AGEP from acs")
sqldf("select unique AGEP from acs")