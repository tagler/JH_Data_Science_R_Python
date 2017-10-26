# homeowrk 2

# 1

library(AppliedPredictiveModeling)
library(caret)
data(AlzheimerDisease)

adData = data.frame(diagnosis,predictors)
testIndex = createDataPartition(diagnosis, p = 0.50,list=FALSE)
training = adData[-testIndex,]
testing = adData[testIndex,]

# 2

library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(975)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

library(ggplot2)
library(Hmisc)

training$Age <- cut2(training$Age, g=10)
training$FlyAsh <- cut2(training$FlyAsh, g=10)

index <- seq_along(1:nrow(training))

qplot(index, training$CompressiveStrength, color=training$Age)
qplot(index, training$CompressiveStrength, color=training$FlyAsh)

featurePlot(x=training[,1:8],y=training$CompressiveStrength, plot="pairs")
featurePlot(x=training[,1:8],y=training$CompressiveStrength)

# 3

library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(975)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

qplot(training$Superplasticizer)
log(training$Superplasticizer)
qplot(log(training$Superplasticizer+ 1))
qplot(log(training$Superplasticizer))

# 4

library(caret)
library(AppliedPredictiveModeling)
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

x <- preProcess(training[,grepl("^IL_", colnames(training))], method="pca", thresh = 0.9)
x$rotation 

# 5

library(caret)
library(AppliedPredictiveModeling)
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

training <- training[,grepl("^IL|diagnosis", colnames(training))]
testing <- testing[,grepl("^IL|diagnosis", colnames(testing))]

modelFit_all <- train(diagnosis ~ . , data=training, method="glm")
predictions <- predict(modelFit_all, newdata = testing)
confusionMatrix(predictions, testing$diagnosis)

modelFit_pca <- train(diagnosis ~ . , data=training, method="glm", preProcess="pca",
                      trControl = trainControl(preProcOptions = list(thresh = 0.8)))
predictions_pca <- predict(modelFit_pca, newdata = testing)
confusionMatrix(predictions_pca, testing$diagnosis)


