remotes::install_github("jfq3/ggordiplots")
library(ggordiplots)
gg_ordisurf(ord = RDA_vare, env.var = varechem$Al, 
            pt.size = 3,var.label = "Aluminum")$plot +
  theme_bw()+
  scale_color_gradient(low="gold",high="red")

gg_ordisurf(ord = RDA_vare, env.var = varechem$pH,
             pt.size = 3,var.label = "pH")$plot +
  theme_bw()+
  scale_color_gradient(low="gold",high="red")

gg_ordisurf(ord = RDA_vare, env.var = varechem$N,
            pt.size = 3, var.label = "N")$plot +
  theme_bw()+
  scale_color_gradient(low="gold",high="red")

gg_ordisurf(ord = RDA_vare, env.var = varechem$Baresoil,
            pt.size = 3, var.label = "Bare")$plot +
  theme_bw()+
  scale_color_gradient(low="gold",high="red")


gg_ordibubble(ord = RDA_vare, env.var = varechem$Fe,
              var.label = "Fe")$plot +
  theme_bw()

gg_ordisurf(ord = RDA_vare, env.var = varechem$Baresoil,
            pt.size = 3, var.label = "Bare")$plot +
  theme_bw()+
  scale_color_gradient(low="gold",high="red")

gg_ordiplot(pca_hell, groups=aravo$env$PhysD, ellipse=TRUE)
gg_ordiplot(pca_hell, groups=aravo$env$ZoogD, spiders=TRUE, ellipse=FALSE)
gg_ordiplot(pca_hell, groups=aravo$env$ZoogD, hull=TRUE, ellipse=FALSE)


gg_envfit(ord = pca_hell, env = aravo$env, 
          perm = 9999, pt.size = 2, alpha = 0.2)

envfit(pca_hell, env = aravo$env, permutations = 9999)

gg_ordisurf(ord = pca_hell, env.var = aravo$env$Slope,
            pt.size = 3, var.label = "Nieve")$plot +
  theme_bw()+
  scale_color_gradient(low="gold",high="red")
