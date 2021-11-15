remotes::install_github("hhwagner1/LandGenCourse")
library(LandGenCourse)
gen <- read.csv(system.file("extdata", "wolf_geno_samp_10000.csv", 
                            package = "LandGenCourse"), row.names=1)
gen.imp <- apply(gen, 2, function(x) replace(x, is.na(x), as.numeric(names(which.max(table(x))))))

write.csv(gen.imp, "gen.imp.csv")
