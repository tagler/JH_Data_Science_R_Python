library(jpeg)
x <- readJPEG("getdata-jeff.jpg", native=TRUE)
y <- quantile(x, probs = seq(0, 1, 0.1))