# load data
blogs <- readLines("~/Downloads/Coursera/final/en_US/en_US.blogs.txt")
news <- readLines("~/Downloads/Coursera/final/en_US/en_US.news.txt")
twitter <- readLines("~/Downloads/Coursera/final/en_US/en_US.twitter.txt", skipNul = TRUE) 

# save data
save(blogs, news, twitter, file = "raw_data.Rdata")