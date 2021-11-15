png(units="cm", res=600, height=20, width=30, "rda scaling 1.png")
autoplot(RDA_vare, scaling=2, geom="point")+
  theme_bw()+
  geom_hline(yintercept = 0, color='gray60', lty=2)+geom_vline(xintercept = 0,color='gray60', lty=2)+
  scale_color_manual(values = c("#ff0037", "#0062eb"))+
  theme(legend.position = "none", aspect.ratio=5/4,
        panel.spacing.x=unit(0, "lines"),
        panel.spacing.y=unit(0, "lines"),
        plot.margin = margin(0, 0, 0, 0, "cm"))
dev.off()

gg_ordiplot(RDA_vare, groups=rep("G1", nrow(varespec)), ellipse=FALSE,
            scaling=2)$plot+
  theme_bw()+
  theme(legend.position="none")+
  scale_color_manual(values="black")
gg_envfit(RDA_vare, env=varechem)

library(ggord)

# Automáticamente en escalado simétrico 
ggord(RDA_vare,  ptslab = TRUE,
      addsize = 3.5, size = 3.5,
      obslab=TRUE,   axes = c("1", "2"), repel=TRUE, force=TRUE,
      labcol = "blue", veccol = "blue", addcol = "red")


remotes::install_github("wdy91617/ggords")
library(ggords)

# Automático 
png(units="cm", res=600, height=15, width=15, "rda scaling 0.png")
ggrda(RDA_vare, obslab = TRUE, scaling=0, obssize=4, 
      obsFonts = "sans",
      speFonts = "sans",
      fFonts = "sans")+
  theme_minimal()+
  theme(aspect.ratio=5/5)
dev.off()


ggord(CA, grp_in=factor(ambiente$WaterContent), ellipse=FALSE)+
  xlim(-3,1)+
  ylim(-0.6,1.5)
