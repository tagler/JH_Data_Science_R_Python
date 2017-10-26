# load data
load("raw_data.Rdata")

# sample data 100,000 lines
b_sample <- sample(blogs, 100000)
n_sample <- sample(news, 100000)
t_sample <- sample(twitter, 300000)

# save data
save(b_sample, n_sample, t_sample, file="sample_data.Rdata")