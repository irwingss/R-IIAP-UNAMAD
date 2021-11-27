bas <- openxlsx::read.xlsx("base.xlsx")

library(tidyverse)
str(bas)
ss<- bas$Meses
fix(ss)
bas$Meses <- factor(bas$Meses, levels=c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Setiembre"))

bas %>% 
  gather("key", "values", 2:4) %>% 
  ggplot(aes(x=Meses, y=values, fill=key, 
             color=key, group=key))+
  geom_line()+
  geom_point()+
  scale_y_sqrt(breaks=c(100,250,500,1000,1500,3000,5000,
                        10000,15000,20000,25000))+
  theme_bw()
  

graph<-bas %>% 
  gather("key", "values", 2:4) %>% 
  ggplot(aes(x=Meses, y=values, fill=key, 
             color=key, group=key))+
  geom_line()+
  geom_point()+
  facet_grid(key~., scales="free_y")+
  theme_bw()+
  scale_color_manual(values=c("darkorange","purple","cyan4"))+
  labs(x="Meses",y="Frecuencia")+
  theme(legend.position="none")
graph

g <- ggplot_gtable(ggplot_build(graph))
stripr <- which(grepl('strip-r', g$layout$name))
fills <- c("#ffd8ad","#efd1ff","#cfffee")
k <- 1
for (i in stripr) {
  j <- which(grepl('rect', g$grobs[[i]]$grobs[[1]]$childrenOrder))
  g$grobs[[i]]$grobs[[1]]$children[[j]]$gp$fill <- fills[k]
  k <- k+1
}

png("grafico.png", res=600, units="cm", height=16, width=15)
graph
dev.off()

