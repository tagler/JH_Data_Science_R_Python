## question 1 
library(datasets)
data(mtcars)
fit <- lm(mtcars$mpg ~ factor(mtcars$cyl) + mtcars$wt)
fit

## question 2
fit <- lm(mtcars$mpg ~ factor(mtcars$cyl) + mtcars$wt)
fit2 <- lm(mtcars$mpg ~ factor(mtcars$cyl))

## question 3
fit <- lm(mtcars$mpg ~ factor(mtcars$cyl) + mtcars$wt)
fit3 <- lm(mtcars$mpg ~ factor(mtcars$cyl) * mtcars$wt)
library(lmtest)
lrtest(fit,fit3)
anova(fit,fit3)

## question 4
fit4 <- lm(mpg ~ I(wt * 0.5) + factor(cyl), data = mtcars)

## question 5
x <- c(0.586, 0.166, -0.042, -0.614, 11.72)
y <- c(0.549, -0.026, -0.127, -0.751, 1.344)

## question 6
fitxy <- lm(y ~ x)
dfbetas(fitxy)
hatvalues(fitxy)



