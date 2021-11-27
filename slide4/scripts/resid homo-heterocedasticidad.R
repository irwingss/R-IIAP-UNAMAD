data(iris)
library(tidyverse)
library(ggfortify)
lm(Sepal.Length ~ Petal.Length, data=iris %>% 
    filter(Species=="versicolor")) %>%
  autoplot(which = 1,  colour = "purple",  label = FALSE,
           smooth.colour = "black", ad.colour = "gray60",
           nrow=1, ncol=1, size=3, alpha=0.5)+
  labs(title="Homocedasticidad")+
  theme_test()+
  theme(plot.title=element_text(hjust=0.5))

data(iris)
library(tidyverse)
library(ggfortify)
lm(Sepal.Length ~ Petal.Length, data=iris) %>% 
  plot(1, pch=16, lwd=2, main="Heterocedasticidad")
lm(Sepal.Length ~ Petal.Length, data=iris) %>%
  autoplot(which = 1,  colour = "purple",  label = FALSE,
           smooth.colour = "black", ad.colour = "gray60",
           nrow=1, ncol=1, size=3, alpha=0.5)+
  labs(title="Heterocedasticidad")+
  theme_test()+
  theme(plot.title=element_text(hjust=0.5))


data(iris)
library(tidyverse)
library(ggfortify)
library(lme4)
data("Arabidopsis")
View(Arabidopsis)
flycat <- read.csv(url("https://www.zoology.ubc.ca/~bio501/R/data/flycatcher.csv"), 
                   stringsAsFactors = FALSE)
mod <- lm(Sepal.Length ~ Petal.Length+popu, data=Arabidopsis)
broom::augment(mod) %>% 
  
  ggplot(aes(x=iris$Species, y=.resid, color=Arabidopsis$Species,
             fill=iris$Species))+
  geom_boxplot()+
  labs(y="Residuales", x="Grupos")+
  scale_fill_manual(values=c("#efd6ff","#ffebd6","#d6ebff"))+
  scale_color_manual(values=c("purple","darkorange","cyan4"))+
  theme_test()+
  theme(legend.position="none")

flycat <- read.csv(url("https://www.zoology.ubc.ca/~bio501/R/data/flycatcher.csv"), stringsAsFactors = FALSE)

ggplot(flycat, aes(y = patch, x = factor(year))) +  
  geom_point(size = 5, col = "firebrick", alpha = 0.5) + 
  geom_line(aes(group = bird)) +
  labs(x = "Year", y = "Patch length (mm)") + 
  theme_classic()
z <- lmer(patch ~ 1 + (1|bird), data = flycat)
summary(z)

VarCorr(z)
# Repeatability
1.11504^2/(1.11504^2 + 0.59833^2)
plot(z)
