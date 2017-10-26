## question 1 - weighted average
x <- c(0.18, -1.54, 0.42, 0.95)
w <- c(2, 1, 3, 1)
weighted.mean(x,w)

## question 2 - linear regression through origin 
x <- c(0.8, 0.47, 0.51, 0.73, 0.36, 0.58, 0.57, 0.85, 0.44, 0.42)
y <- c(1.39, 0.72, 1.55, 0.48, 1.19, -1.59, 1.23, -0.65, 1.49, 0.05)
lm( y ~ x - 1 )
lm( y ~ x + 0 )
plot(x,y, xlim=c(-1,1) )
abline( lm( y ~ x + 0 ) )

## question 3 data(mtcars) regression
data(mtcars) 
plot(mtcars$wt , mtcars$mpg)
fit <- lm( mtcars$mpg ~ mtcars$wt  )
abline(fit)

## question 4
## B1-hat = Cor(Y,X) Sd(Y) / Sd(X)
0.5*2/1

## question 5
## y = x * cor(x,y) if normalized with mean 0 and sd of 1
0.4*1.5 

## question 6 normalize data to mean of 0 and var of 1
x <- c(8.58, 10.46, 9.01, 9.64, 8.86)
xmean <- mean(x)
xsd <- sd(x)
xnormal <- (x-xmean)/xsd

## question 7 - linear regression 
x <- c(0.8, 0.47, 0.51, 0.73, 0.36, 0.58, 0.57, 0.85, 0.44, 0.42)
y <- c(1.39, 0.72, 1.55, 0.48, 1.19, -1.59, 1.23, -0.65, 1.49, 0.05)
lm( y ~ x)

## question 9
x <- c(0.8, 0.47, 0.51, 0.73, 0.36, 0.58, 0.57, 0.85, 0.44, 0.42)
mean(x)





