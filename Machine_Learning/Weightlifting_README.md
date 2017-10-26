# Qualitative Activity Recognition of Weight Lifting Exercises

## About

This project analyzes accelerometer data from weightlifting exercises and develops models to predict whether the exercises were performed correctly or incorrectly. Accelerometers were placed on the belt, forearm, arm, and dumbbell of six male participants between 20-28 years old. Participants were asked to perform lifts using a 1.25 kg dumbbell correctly and incorrectly in four different ways. The participants performed one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl in five different fashions: according to the specification (class A), throwing elbows to the front (class B), lifting the dumbbell only halfway (class C), lowering the dumbbell only halfway (class D), and throwing hips to the front (class E). In sum, class A corresponds to the correct execution of the exercise, whereas the other four classes correspond to mistakes.

The best model used the random forest algorithm. Using cross-validation, the accuracy of the random forest model was estimated to be about 99% and out-of-sample error was estimated to be about 1%. Moreover, this model was optimized, and the number of features was reduced from 52 to 7. The accuracy of the optimized model was estimated to be about 98% and out-of-sample error was estimated to be about 2%.
