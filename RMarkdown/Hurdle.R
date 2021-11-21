# **5. Hurdle Models**

Usaremos la función `hurdle()` de la librería `pscl` para realizar este modelo mixto.

```{r}
# Explorar la base de datos
plot(table(aves$r_total), col="red")

lechu <- openxlsx::read.xlsx("slide3/bases/Lechuzas.xlsx")
plot(table(lechu$), col="red")


r_total ~ temp_pa + nieve, data=aves
# Crear un modelo de poison para iniciar el testeo
phd.pois <- glm(articles ~ ., data=PhdPubs, family=poisson(link="log"))

# Chequeo de la sobre dispersión para decidir si hacer 
# un modelo de poisson o un modelo binomial negativo
check_overdispersion(phd.pois)

# Chequeo de Ratio de Ceros en el Modelo Poisson
check_zeroinflation(phd.pois)

# Creación del Hurdle Model
hdm.bn <- hurdle(articles ~ ., data=PhdPubs, dist = "negbin", #"poisson" 
                 zero.dist = "binomial", link = "logit")
hdm.null.bn <- update(hdm.bn, . ~ 1)

# Ver la significancia del modelo full vs modelo nulo
AIC(hdm.null.bn) - AIC(hdm.bn)
logLik(hdm.null.bn) - logLik(hdm.bn)

library(lmtest)
lrtest(hdm.bn, hdm.null.bn)

# Ver resultados
summary(hdm)
coef(hdm) %>% exp() %>% as.data.frame() %>% View()
confint(hdm)
predict(hdm.bn, type = "prob") %>% View()
sum(predict(hdm.bn, type = "prob")[,"0"]) 
# Hurdle model siempre predice la misma cantidad de ceros que nuestra base
predict(hdm.bn, type = "response")[1:5]

# Rootgram (Gráfico de raíz)
library(countreg)
countreg::rootogram(hdm.bn, max = max(PhdPubs$articles))

# Gráfico para Interpretar los coeficientes
plot_model(hdm.bn, type="est", sort.est = TRUE, show.values = TRUE,
           show.p = TRUE, width = 0.4,  dot.size = 1, colors = "Dark2",
           vline.color = "gray90",value.offset = 0.35, value.size=2.5)+
  theme_bw()+
  scale_y_continuous(breaks = seq(0.5,3, 0.1))
```

# **5. Modelos Zero-Inflados**

#### **Problema:**

En esta base de datos se buscaba modelar cuántos peces eran capturados por pescadores en un Parque Nacional. Se realizaron encuestas a los visitantes por grupos **(n=250 grupos)** para anotar cuántos peces pescaron (`count`), cuántos niños había en el grupo (`child`), cuántas personas había en el grupo (`persons`) y si habían traído o no una auto-caravana al parque (`camper`).

Además de predecir el número de peces capturados, hay interés en predecir la existencia de un exceso de ceros, es decir, la probabilidad de que un grupo pesque cero (ningún pez).

```{r}
# Carga la base de datos peces.xlsx
peces <- openxlsx::read.xlsx("peces.xlsx")
str(peces)
View(peces)

plot(table(peces$count), col="red")

pois.prev <- glm(count ~ ., data = peces, family="poisson")

# Obtener las predicciones del modelo
mu <- predict(pois.prev, type = "response")

# Obtener las probabilidades de que un conteo sea 0 y sumarlas
exp <- sum(dpois(x = 0, lambda = mu))

# Redondear la suma de las probabilidades para saber
# cuántos 0 espero según mi modelo
round(exp) 

# Cuantos 0 tengo originalmente en variable respuesta 
sum(peces$count < 1)                      


# Crear el modelo Cero inflado
# usar barra vertical para separar predictores del Proceso de Poisson (para conteos)
# de los Predictores Binomiales (para los ceros)
zero <- zeroinfl(count ~ child + camper | persons, data = peces)

# Ver si el pvalor del modelo es significativo comparado con el modelo Nulo
# df es el número de predictores (var X) en el modelo full
pchisq(2 * (logLik(zero) - logLik(zero.null)), df = 3, lower.tail = FALSE)

# Ver resultados
summary(zero)
coef(zero) %>% exp() %>% as.data.frame() 

# Gráfico para Interpretar los coeficientes
plot_model(zero, type="est", sort.est = TRUE, show.values = TRUE,
           show.p = TRUE,width = 0.4, dot.size = 1,
           vline.color = "gray90",value.offset = 0.35, value.size=2.5)+
  theme_bw()
```


