ambiente <- openxlsx::read.xlsx("slide1/bases/variables ambientales.xlsx")
library(GGally)
png("slide1/figs/ggpairs.png",res=600, units="cm",height=20, width=45)
ggpairs(ambiente,
        upper= list(continuous= wrap("cor", method="spearman",
                                     color="#5f00db", size=3)),
        lower= list(continuous= wrap("points", 
                                     color="#5f00db", alpha=0.5)),
        diag= list(continuous= wrap("densityDiag", 
                                    fill="#5f00db", alpha=0.5)))+
  theme_test()
dev.off()
