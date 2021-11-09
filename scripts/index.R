library(tidyverse)
data(iris)
plotindex<- iris %>% mutate(index = 1:nrow(.)) %>% 
  ggplot(aes(x=index, y=Petal.Length, color=factor(Species,
                                                   labels = c("setosa"="A. makinensis",
                                                              "versicolor"="A. monticola",
                                                              "virginica"="A. juninensis"))))+
  geom_point(size=4, alpha=0.7)+
  labs(x="Index", y="Longitud de cola (mm)", color="Especies",
       title = "Gráfico de Index", subtitle="Para graficar una sola variable")+
  theme_minimal()+
  scale_color_brewer(palette = "Dark2")
theme(legend.position = "bottom")
plotindex