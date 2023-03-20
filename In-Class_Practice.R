#Multiple Linear Regression Heart Data
library(tidyverse)
dataset=read.csv("heart.data.csv")

#Explore the data
view(dataset)
glimpse(dataset)
length(dataset)
names(dataset)
summary(dataset)

#Fixing Missing Values
colSums(is.na(dataset))

#biking
ggplot(data=dataset,
       aes(biking))+
  geom_density()

biking_median=median(dataset$biking, na.rm=TRUE)
dataset$biking=ifelse(is.na(dataset$biking),
                      biking_median,
                      dataset$biking) 
colSums(is.na(dataset))
#smoking
ggplot(data=dataset,
       aes(smoking))+
  geom_density()

smoking_median=median(dataset$smoking, na.rm=TRUE)
dataset$smoking=ifelse(is.na(dataset$smoking),
                       smoking_median,
                       dataset$smoking)
colSums(is.na(dataset))
#heart disease
ggplot(data=dataset,
       aes(heart.disease))+
  geom_histogram()

hd_mean=mean(dataset$heart.disease, na.rm=TRUE)
dataset$heart.disease=ifelse(is.na(dataset$heart.disease),
                             hd_mean,
                             dataset$heart.disease)

colSums(is.na(dataset)) #all missing data has been imputed 

#Splitting the data into 2 sets
library(caTools)
set.seed(10)
split=sample.split(dataset$heart.disease, SplitRatio = 0.8) #80% training, 20% test
training_set=subset(dataset, split=TRUE)
test_set=subset(dataset, split=FALSE)

#MLR training
names(dataset)
MLR=lm(formula=heart.disease~.,
       data=training_set)
summary(MLR)
# 14.956879 - 0.200113*(biking) + 0.179576*(smoking)
## Above is the equation for the variable heart.disease 
### All above variables are statistically significant because their P-values are less than 0.05

#Mean Square Error 
summ=summary(MLR)
MSE=(mean(summ$residuals^2))
paste("Mean squared error :", MSE)

#R-square
summary(MLR)
#The R Square value is 0.7039, which is a good, high value meaning this is a good model

#Testing Set Prediction 
y_pred=predict(MLR, newdata=test_set) #Setting a variable for the predicted y values
data=data.frame(test_set$heart.disease, y_pred)
head(data)

#Validation
new=read.csv("Heart_validation.csv") #Reading the validation file
new
new_x=new[c(1:2)] #Separating the x and y variables 
new_x
data.frame(new[c(3)], predict(MLR, newdata=new_x))
