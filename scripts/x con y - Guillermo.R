install.packages("chemCal")
library(chemCal)
library(tidyverse)
data("iris")
iris_train <- iris %>% group_by(Species) %>% sample_frac(0.8) 
iris_test <- anti_join(iris, iris_train)

# Testeo 1
mod <- lm(Sepal.Length~Petal.Length, data=iris_train)
ic <-inverse.predict(mod, 5.1)$`Confidence Limits`
superior <- ic[2]
inferior <- ic[1]

pred <-inverse.predict(mod, 5.1)
unlist(pred)
unlist(pred)[1]
unlist(pred)[2]

# Datos a predecir
x_a_predecir <- iris_test %>% pull(Petal.Length) 

# Datos predictores
y_predictora <- iris_test %>% pull(Sepal.Length) 

# Data Frame a rellenar
DF<-data.frame(prediccion=rep(0, length(y_predictora)),
           se=rep(0, length(y_predictora)),
           ci=rep(0, length(y_predictora)),
           ci_bajo=rep(0, length(y_predictora)),
           ci_alto=rep(0, length(y_predictora)))

# Loop para rellenar la DF con los resultados
for (i in 1:length(y_predictora)){
  pred <-inverse.predict(mod, y_predictora[i])
  vector <-unlist(pred)
  DF[i,1] <- vector[1]
  DF[i,2] <- vector[2]
  DF[i,3] <- vector[3]
  DF[i,4] <- vector[4]
  DF[i,5] <- vector[5]
}

DF

# Si quieres ver esto:
residuales <- x_a_predecir - DF$prediccion
residuales

plot(x_a_predecir,DF$prediccion)
