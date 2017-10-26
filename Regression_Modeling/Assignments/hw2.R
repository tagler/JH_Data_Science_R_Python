## question 1 and 2
x <- c(0.61, 0.93, 0.83, 0.35, 0.54, 0.16, 0.91, 0.62, 0.62)
y <- c(0.67, 0.84, 0.6, 0.18, 0.85, 0.47, 1.1, 0.65, 0.36)
fit <- lm(y ~ x)
summary(fit)

## question 3,4,5,6
data(mtcars)
x <- mtcars$wt
y <- mtcars$mpg
fit <- lm( y ~ x)
plot(x, y)
abline(fit)
averagewt <- mean(x)
conf.int <-  predict(fit, data.frame(x = c(averagewt)), interval="confidence")
pred.int <-  predict(fit, data.frame(x = c(3)), interval="prediction")

x <- mtcars$wt/2
y <- mtcars$mpg
fit <- lm( y ~ x)
plot(x, y)
abline(fit)

fit2<-lm(y~I(x/2))
tbl2<-summary(fit2)$coefficients
mn<-tbl2[2,1]      #mean is the estimated slope
std_err<-tbl2[2,2] #standard error
deg_fr<-fit2$df    #degree of freedom
#Two sides T-Tests
mn + c(-1,1) * qt(0.975,df=deg_fr) * std_err

## question 9
fit <- lm( y ~ x)
s1 <- resid(fit)
fit2 <- lm( y ~ 1)
s2 <- resid(fit2)
anova(fit)
anova(fit2)


