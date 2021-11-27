library(tidyverse)
# Create some data
set.seed(20000)
n <- 500
x1 <- runif(n,0,100)
x2 <- runif(n,2,1000)
y <- ((x2 - x1 + rnorm(n,sd=20))/100) %>% round(0) 
y<- ifelse(y==-1,1,y)
range(x1)
zorrito <- tibble(crias=y, intentos=10, genAD92 = x1, gen208S = x2)
zorrito <- zorrito %>% mutate(cri_int = crias/intentos) 

# Fit a binomial regression model
model <- glm(cri_int ~ genAD92 + gen208S, data=zorrito, family=binomial(link = "logit"), weights = intentos)
summary(model)
exp(coef(model))

performance::check_overdispersion(model2)
performance::check_model(model2)

plot_m

zorrito3 %>% openxlsx::write.xlsx("zorrito.xlsx")
zorrito <- openxlsx::read.xlsx("datasets/zorrito.xlsx")

zorrito2 <- zorrito %>% mutate(genAD922 = sqrt(genAD92)/cri_int, 
                               gen208S2 = gen208S/intentos/cri_int) %>% 
  filter(genAD922!=Inf & gen208S2!=Inf)

zorrito3 <- zorrito2 %>% mutate(genAD922 = genAD922/(1+genAD922), 
                               gen208S2 = ((gen208S/1000))) %>% 
  filter(genAD922!=Inf & gen208S2!=Inf)
zorrito<-zorrito3
modelo <- glm(cri_int ~ genAD922 + gen208S2, data=zorrito, 
              family=binomial(link = "logit"), weights = intentos)
summary(modelo)
exp(coef(modelo))

library(sjPlot)

plot_model(modelo, type="pred", show.data = T, colors = "#00ff00", terms = c("gen208S2"))+
  theme_bw()+geom_smooth(color="#5f00db", fill="#e9d9ff")+
  labs(title="", x="Expresión", y="Probabilidad")


df <- ggeffects::ggpredict(modelo, terms = c("gen208S2"))

png("figs/gen208S2.png", res=600, units = "cm", width = 20, height = 13)
ggplot(data=df, aes(x, predicted)) + 
  scale_x_continuous(expand=c(0,0))+
  coord_cartesian(clip = "off")+
  geom_point(data=zorrito, aes(x=gen208S2, y=cri_int), color="#646464", alpha=0.2, size=2)+
  geom_line(color="#5f00db", lwd=1) +
  geom_ribbon(aes(ymin=conf.low, ymax=conf.high), fill="#5f00db", alpha=0.1) +
  labs(y="Probabilidad", x="Gen 208S2",
       title="Predicción de la probabilidad de obtención de crías grises",
       subtitle = expression(paste("por la expresión del gen 208S2 en poblaciones de Ecuador y Perú de Zorro de Sechura", italic(" Lycalopex sechurae"))))+
  theme_bw()+
  theme(plot.title = element_text(colour = "#5f00db", face=2, size=13),
        plot.subtitle = element_text(size=10),
        text = element_text(colour = "#646464"))
dev.off()



devtools::install_github("strengejacke/ggeffects")

### SEPARADOS

# Colores a usar
library(scales)
show_col(hue_pal()(3))
hue_pal()(3)


t <- ggplot(data=subset(df, df$group=="Territorial"), aes(x=x, y=predicted)) + 
  scale_x_continuous(breaks = seq(0,150,20), expand=c(0,0))+
  geom_jitter(data=subset(pez, pez$tactica=="Territorial"), aes(x=longitud, y=punto_rojo, group=tactica), color="#619CFF", alpha=0.2, size=2,width = 0.05, height = 0.02)+
  geom_line(color="#619CFF", lwd=1) +
  geom_ribbon(aes(ymin=conf.low, ymax=conf.high), fill="#619CFF", alpha=0.1) +
  labs(x="Longitud del Pez (mm)", y="Probabilidad de tener Punto Rojo en el Opérculo", title="Territorial", color="Táctica")+
  theme_bw() + theme(text = element_text(colour = "#646464"))

h <- ggplot(data=subset(df, df$group=="Hembra"), aes(x=x, y=predicted)) + 
  scale_x_continuous(breaks = seq(0,150,20), expand=c(0,0))+
  geom_jitter(data=subset(pez, pez$tactica=="Hembra"), aes(x=longitud, y=punto_rojo, group=tactica), color="#F8766D", alpha=0.2, size=2,width = 0.05, height = 0.02)+
  geom_line(color="#F8766D", lwd=1)+
  geom_ribbon(aes(ymin=conf.low, ymax=conf.high), fill="#F8766D", alpha=0.1) +
  labs(x="Longitud del Pez (mm)", y="Probabilidad de tener Punto Rojo en el Opérculo", title="Hembra", color="Táctica")+
  theme_bw() + theme(text = element_text(colour = "#646464"))

f <- ggplot(data=subset(df, df$group=="Furtivo"), aes(x=x, y=predicted)) + 
  scale_x_continuous(breaks = seq(0,150,20), expand=c(0,0))+
  geom_jitter(data=subset(pez, pez$tactica=="Furtivo"), aes(x=longitud, y=punto_rojo, group=tactica), color="#00BA38", alpha=0.2, size=2,width = 0.05, height = 0.02)+
  geom_line(color="#00BA38", lwd=1) +
  geom_ribbon(aes(ymin=conf.low, ymax=conf.high), fill="#00BA38", alpha=0.1) +
  labs(x="Longitud del Pez (mm)", y="Probabilidad de tener Punto Rojo en el Opérculo", title="Furtivo", color="Táctica")+
  theme_bw() + theme(text = element_text(colour = "#646464"))

png("figs/long-tact3.png", res=600, units = "cm", width = 30, height = 14)
ggpubr::ggarrange(h,f,t, ncol=3, nrow=1)
dev.off()
