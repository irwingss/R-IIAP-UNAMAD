# 1. Análisis Exploratorio Básico

## 1.1. ggpairs para explorar rápidamente

El siguiente código no es necesario siempre que se use `ggpairs()`, solamente es para hacer que una parte del gráfico se vea diferente.

```{r}
# Función de graficación densidad_ggpairs()
densidad_ggpairs <- function(data, mapping, ...){
  p <- ggplot(data = data, mapping = mapping) +
    stat_density2d(aes(fill=..density..), 
                   geom="tile", contour = FALSE) +
    scale_x_continuous(expand=c(0,0,0,0))+
    scale_y_continuous(expand=c(0,0,0,0))+
    scale_fill_distiller(palette= "Spectral", direction=-1)+
    geom_point(size=0.9, shape=3)
  
  p
}

# Función de graficación regression_ggpairs()
regresion_ggpairs <- function(data, mapping, ...){
  p <- ggplot(data = data, mapping = mapping) + 
    geom_point(color="#0090d1", size=1.5, alpha=0.6,...) + 
    geom_smooth(method="lm", fill="#6ed2ff", color="#0079b0", ...)
  p
}
```

Generemos los gráficos del análisis exploratorio con `ggpairs()`. Esta función pertenece a la librería `GGally`.

```{r}
# Carga el excel "variable ambientales.xlsx"
ambiente <- openxlsx::read.xlsx("bases/variables ambientales.xlsx")
ambiente <- openxlsx::read.xlsx(file.choose())

# Resumen numérico de las variales
str(ambiente)
summary(ambiente)

# Gráfico únicamente variables numéricas
library(GGally)

ggpairs(env)+
  theme_test()

ggpairs(env, lower=list(continuous=regresion_ggpairs))+
  theme_test()

ggpairs(env, lower=list(continuous=densidad_ggpairs))+
  theme_test()

# Gráfico variables numéricas y categóricas
library(ade4)
data("aravo")
aravo$env$ZoogD <- factor(aravo$env$ZoogD)

ggpairs(aravo$env, aes(color=aravo$env$ZoogD))+
  theme_test()

# Gráfico para comparaciones entre especies
View(aravo$spe)
ggpairs(aravo$spe[,1:10], 
        lower=list(continuous=regresion_ggpairs),
        upper=list(continuous=wrap("cor",method="kendall")))
cor(aravo$spe[,1:10], method="kendall")
```
