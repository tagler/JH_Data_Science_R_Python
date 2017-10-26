# 1

library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)
set.seed(125)

adData = data.frame(segmentationOriginal)
training = subset(adData, Case == "Train", select = -Case)
testing = subset(adData, Case == "Test", select = -Case)

modelFit <- train(Class ~ . , data=training, method="rpart")

modelFit$finalModel

library(rattle) 
fancyRpartPlot(modelFit$finalModel)

# 3

library(pgmm)
data(olive)
olive = olive[,-1]

modelFit <- train(Area ~ . , data=olive, method="rpart")
newdata = as.data.frame(t(colMeans(olive)))
predict(modelFit, newdata=newdata)

# 4

library(ElemStatLearn)
data(SAheart)
SAheart$chd <- as.factor(SAheart$chd)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]

set.seed(13234)
modelFit <- train(chd ~ age + alcohol + obesity + typea + tobacco + ldl, data=trainSA, method="glm", family = binomial(link = "logit"))
predict_train <- predict(modelFit, newdata=trainSA)
predict_test <- predict(modelFit, newdata=testSA)

missClass = function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}

missClass(trainSA$chd, predict_train)
missClass(testSA$chd, predict_test)

confusionMatrix(predict_train, trainSA$chd)
confusionMatrix(predict_test, testSA$chd)

# 5

library(ElemStatLearn)
data(vowel.train)
data(vowel.test) 

vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)

set.seed(33833)

model <- train( y ~ ., data = vowel.train, method = "rf")
varImp(model)




