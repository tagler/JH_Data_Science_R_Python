#1 

library(caret)
library(ElemStatLearn)
data(vowel.train)
data(vowel.test) 
vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)

set.seed(33833)

mod1 <- train(y ~ ., method="rf", data=vowel.train)
mod2 <- train(y ~ ., method="gbm", data=vowel.train)

pred1 <- predict(mod1, newdata=vowel.test)
pred2 <- predict(mod2, newdata=vowel.test)

confusionMatrix(pred1, vowel.test$y) # 61% RF
confusionMatrix(pred2, vowel.test$y) # 53% BOOSTING 

a <- data.frame(pred1, pred2, y=vowel.test$y)
amatch <- subset(a, pred1 == pred2)
confusionMatrix(amatch$pred1, amatch$y) # 66% when models agree
confusionMatrix(amatch$pred2, amatch$y)

# 2

library(caret)
library(gbm)
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

set.seed(62433)

mod1 <- train(diagnosis ~ ., method="rf", data=training)
mod2 <- train(diagnosis ~ ., method="gbm", data=training)
mod3 <- train(diagnosis ~ ., method="lda", data=training)

pred1 <- predict(mod1, newdata=testing)
pred2 <- predict(mod2, newdata=testing)
pred3 <- predict(mod3, newdata=testing)

confusionMatrix(pred1, testing$diagnosis) # 76.83%
confusionMatrix(pred2, testing$diagnosis) # 79.3%
confusionMatrix(pred3, testing$diagnosis) # 76.83%

library(caretEnsemble)

myControl <- trainControl(method='cv', number=10, classProbs=TRUE)
models <- caretList(diagnosis ~ ., 
                    data=training, 
                    methodList=c('rf', 'gbm','lda'),
                    trControl=myControl)

caretEsm <- caretEnsemble(models)
caretSt <- caretStack(models, method="rf")

pred4 <- predict(caretEsm, newdata=testing)
pred5 <- predict(caretSt, newdata=testing)

pred4_2 <- as.factor(pred4 > 0.5)
levels(pred4_2) <- c("Impaired","Control")

confusionMatrix(pred4_2, testing$diagnosis) # 80.2%
confusionMatrix(pred5, testing$diagnosis) # 79.3%

# 3

set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]

set.seed(233)
mod <- train(CompressiveStrength ~ ., method="lasso", data=training)
plot.enet(mod$finalModel, xvar = "penalty", use.color = TRUE)

# 4

library(lubridate)  # For year() function below
dat = read.csv("gaData.csv")
training = dat[year(dat$date) < 2012,]
testing = dat[(year(dat$date)) > 2011,]
tstrain = ts(training$visitsTumblr)

library(forecast)
fit <- bats(tstrain)
fcast <- forecast(fit, level = 95, h= dim(testing)[1] )
fcast$upper
fcast$lower

b <- 0
a <- testing$visitsTumblr
for (i in 1:length(a)) {
          if (fcast$upper[i] > a[i] & fcast$lower[i] < a[i] ) {
                    b <- b+1
          }
}
print(b)
print(b/length(a))








# 5


library(e1071)
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]

set.seed(325)
mod <- train(CompressiveStrength ~ ., data=training, method="svmRadial")
p <- predict(mod, newdata=testing)

sqrt((sum((p-testing$CompressiveStrength)^2)/length(p)))

# Set the seed to 325 and fit a support vector machine using the e1071 package to predict 
# Compressive Strength using the default settings. Predict on the testing set. What is the RMSE?








√