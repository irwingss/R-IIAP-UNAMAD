library(tidyverse)
set.seed(0)
dat <- data.frame(x=(x=runif(100, 0, 50)),
                  y=rnorm(100, 10*x, 100))

## breaks: where you want to compute densities
breaks <- seq(0, max(dat$x), len=5)
dat$section <- cut(dat$x, breaks)

## Get the residuals
dat$res <- residuals(lm(y ~ x, data=dat))

## Compute densities for each section, and flip the axes, and add means of sections
## Note: the densities need to be scaled in relation to the section size (2000 here)
dens <- do.call(rbind, lapply(split(dat, dat$section), function(x) {
  d <- density(x$res, n=50)
  res <- data.frame(x=max(x$x)- d$y*2000, y=d$x+mean(x$y))
  res <- res[order(res$y), ]
  ## Get some data for normal lines as well
  xs <- seq(min(x$res), max(x$res), len=50)
  res <- rbind(res, data.frame(y=xs + mean(x$y),
                               x=max(x$x) - 2000*dnorm(xs, 0, sd(x$res))))
  res$type <- rep(c("Empírica", "Normal"), each=50)
  res
}))
dens$section <- rep(levels(dat$section), each=100)

## Just normal
gaussian<-ggplot(dat, aes(x, y)) +
  geom_point() +
  geom_smooth(method="lm", lwd=1, color="black", fill="gray80") +
  geom_path(data=dens, aes(x, y, group=interaction(section,type), color=type), lwd=1.1) +
  #geom_path(data=dens[dens$type=="normal",], aes(x, y, group=section), color="#ff6300", lwd=1.1) +
  theme_bw()+
  labs(color="Función de Densidad", x="Variable X", y="Variable Y")+
  scale_color_manual(values=c("#00bfc4","#ff6300"))+
  geom_vline(xintercept=breaks, lty=2, color="gray40")+
  theme(legend.position = "top")
gaussian