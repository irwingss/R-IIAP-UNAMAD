library(ade4)
data("atlas")


library(vegan)

hell <-decostand(atlas$birds, method="hellinger")
hell
dist <- vegdist(hell, method="euclidean")
dendro <- hclust(dist, method="ward.D2")%>% as.dendrogram()
plot(dendro)
dendro$height

dendro2 <- hclust(dist, method="complete") %>% as.dendrogram()
dendro3 <- hclust(dist, method="average") %>% as.dendrogram()

library()

tanglegram(dendro,dendro3)
dend_list <- dendlist(dendro, dendro3)
tanglegram(dendro, dendro3,
           highlight_distinct_edges = FALSE, # Turn-off dashed lines
           common_subtrees_color_lines = TRUE, # Turn-off line colors
           common_subtrees_color_branches = TRUE, # Color common branches 
           main = paste("entanglement =", round(entanglement(dend_list), 2)))
#Baker’s Gamma Index
set.seed(123)
cor_bakers_gamma(dendro1, dendro3)
cor_cophenetic(dendro, dendro3)
?cor_bakers_gamma
  
n<-9999
lista <- list()
for (i in 1:n){
  sample_col<-function(x){
    x[sample(length(x))]
  }
  permutado <- apply(hell, 2, sample_col)
  distancia <- vegdist(permutado, method="euclidean")
  dendro_objeto <- hclust(distancia, method="ward.D2")
  lista[[i]] <- dendro_objeto$height <= dendro$height 
}

df<-do.call(rbind.data.frame, lista)
colnames(df)<-paste0("nodo",1:ncol(df))
colMeans(df) %>% round(3)

dendro$height

function(objeto_dendro) {
require(dendextend)
require(tidyverse)
dend <- as.dendrogram(objeto_dendro) %>% hang.dendrogram()
dend <- dend %>% set_labels(points$ID[dend %>% labels()])
xy <- dend %>% get_nodes_xy()
is_internal_node <- is.na(dend %>% get_nodes_attr("leaf"))
is_internal_node[which.max(xy[,2])] <- FALSE
xy <- xy[is_internal_node,]
plot(objeto_dendro)
text(xy[,1]+.02, xy[,2]+.02, labels=format(xy[,2], digits=2), col="red",cex = 1)
}

fviz_nbclust(hell, FUN = hcut, method = "wss")

# Gráfico exploratorio de fviz_dend()
fviz_dend(dend)
?fviz_dend
# Adicionar agrupamientos por color
fviz_dend(dend, k=5)

# Convertir a horizontal
fviz_dend(dendro.eu.war, k=3, horiz=TRUE)

# Eliminar el título y modificar títulos de ejes
fviz_dend(dendro.eu.war, k=3, horiz=TRUE, main="", 
          ylab="Altura de los nodos", 
          xlab = "Observaciones")+
  labs(caption = "Método de distancia: Euclidean \nMétodo de aglomeración: Ward.D2")

# Cambiar los colores del gráfico
library(RColorBrewer)
cols <- brewer.pal(n=3,"Dark2")

fviz_dend(dendro.eu.war, k=3, horiz=TRUE, main="", 
          ylab="Altura de los nodos", 
          xlab = "Observaciones",
          k_colors = cols)  +
  labs(caption = "Método de distancia: Euclidean \nMétodo de aglomeración: Ward.D2")

?fviz_dend

# Cambiar el tema del gráfico
fviz_dend(dendro.eu.war, k=3, horiz=TRUE, main="", 
          ylab="Altura de los nodos", 
          xlab = "Observaciones",
          k_colors = cols)  +
  labs(caption = "Método de distancia: Euclidean \nMétodo de aglomeración: Ward.D2") + 
  theme_minimal()

# Poner las etiquetas correctas en las hojas de árbol
library(dendextend)
labels(dendro)

ordenadas <- hell$id[order.dendrogram(as.dendrogram(dendro))]
ordenadas

labels(dendro) <- ordenadas

dendro %>% as.dendrogram() %>%  get_nodes_attr("height")

fviz_dend(dendro, k=5, horiz=TRUE, main="", 
          ylab="Altura de los nodos", 
          xlab = "Observaciones")  +
  labs(caption = "Método de distancia: Euclidean \nMétodo de aglomeración: Ward.D2") + 
  theme_minimal()

fviz_dend(dendro, k=5, horiz=TRUE, main="", 
          ylab="Altura de los nodos", 
          xlab = "Observaciones",
          labels_track_height=-0.3,
          palette = "Dark2",
          rect=TRUE, 
          rect_fill = TRUE,
          rect_border="Dark2")  +
  labs(caption = "Método de distancia: Euclidean \nMétodo de aglomeración: Ward.D2") + 
  theme_minimal()
##
library(pvclust)
result <- pvclust(hell, method.dist="cor", 
                  method.hclust="ward.D2", nboot=1000)
plot(result)
pvrect(result)

