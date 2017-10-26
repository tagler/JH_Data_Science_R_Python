## question 1-3

library(MASS)
data(shuttle)

glm1 <- glm( use ~ wind, family="binomial", data = shuttle)
exp(cbind(OR = coef(glm1), confint(glm1)))

glm2 <- glm( use ~ wind + magn, family="binomial", data = shuttle)
exp(cbind(OR = coef(glm2), confint(glm2)))

glm3 <- glm( I(abs(as.numeric(shuttle$use)-2)) ~ wind + magn, family="binomial", data = shuttle)
exp(cbind(OR = coef(glm3), confint(glm3)))

## question 4

library(datasets)
data(InsectSprays)
InsectSprays

p1 <- glm( count ~ as.factor(spray), family="poisson", data=InsectSprays)
exp(cbind(OR = coef(p1), confint(p1)))

# question 5

t <- 2
t2 <- log(10) + 2
p2 <- glm(count ~ as.factor(spray) + offset(t), family = poisson, data = InsectSprays)
p3 <- glm(count ~ as.factor(spray) + offset(t2), family = poisson, data = InsectSprays)

# question 6

x <- -5:5
y <- c(5.12, 3.93, 2.67, 1.87, 0.52, 0.08, 0.93, 2.05, 2.54, 3.87, 4.97)
plot(x,y)
knots <- 0
splineTerms<-sapply(knots,function(knot)(x>knot)*(x-knot))
xMat<-cbind(1,x,splineTerms)
yhat<-predict(lm(y~xMat-1))
plot(x,y,frame=FALSE,pch=21,bg="lightblue",cex=2)
lines(x,yhat,col="red",lwd=2)








