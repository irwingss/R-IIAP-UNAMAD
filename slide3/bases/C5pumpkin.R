########################################################################

# R code to analyse red spot presence in pumpkinseed fish. 
# Data are from Grzegorz Zieba,
# code is from Mark Warren and Carl Smith
# Aim is to fit model to predict the presence of red operculum spots 

########################################################################

#Import the file into a dataframe
pkin <- read.table(file = "pumpkinseed.txt", header = TRUE, dec = ".")
   
# Inspect the dataframe               
str(pkin)

# $ pop   : Factor  Population of origin
# $ sex   : Factor  Sex of fish
# $ wt    : num     Fish weight in g
# $ sl    : num     Fish length in mm
# $ tactic: Factor  Mating tactic
# $ pkin  : int     Presence/absence of red spot

#Load packages
library(lattice)
library(ggplot2)
library(tidyverse)
library(lme4)
library(car)

######################################
# DATA EXPLORATION

# Are there missing values?
colSums(is.na(pkin))

# pop  sex  wt   sl   tactic  spot 
# 0    0    0    0    0       0 
# No zeros


#######################################

# OUTLIERS

# Look at outliers in continuous covariates

# Fig 5.1
Var <- c("sl", "wt")
dotplot(as.matrix(as.matrix(pkin[,Var])),
        groups=FALSE,
        strip = strip.custom(bg = 'white',
                             par.strip.text = list(cex = 1.2)),
        scales = list(x = list(relation = "free", draw = TRUE),
                      y = list(relation = "free", draw = FALSE)),
        col = 1, cex  = 0.6, pch = 16,
        xlab = list(label = "Data range", cex = 1.2),
        ylab = list(label = "Data order", cex = 1.2))

# Nothing stands out, so no obvious outliers at this stage.
# But there are interesting patterns with sl and wt
# Are these related to sex or mating tactic?

#Look at balance between sexes
table(pkin$sex)    
#  F   M 
# 425 475 

#And tactics
table(pkin$tactic)
# fem  sneak  terr 
# 425   95    380 


#Plot points for weight and length by sex
# Sex
# Fig 5.2
par(mfrow = c(1,2), mar = c(5,5,1,1), cex.lab = 1.2)
dotchart(pkin$sl, groups = pkin$sex, xlab = "Length (mm)")
dotchart(pkin$wt, groups = pkin$sex, xlab = "Weight (g)")

# And mating tactic
# Fig 5.3
par(mfrow = c(1,2), mar = c(5,5,1,1), cex.lab = 1.2)
dotchart(pkin$sl, groups = pkin$tactic, xlab = "Length (mm)")
dotchart(pkin$wt, groups = pkin$tactic, xlab = "Weight (g)")

######################################
#CALCULATE NUMBER OF ZEROS IN THE RESPONSE VARIABLE

# How many zeros for spot?

sum(pkin$spot == 0)
# total of 554 zeros

sum(pkin$spot == 0) * 100 / nrow(pkin)
#62% zeros - but this is a binomial variable


######################################
#COLLINEARITY

#Plot covariates against each other and check collinearity

Coll <- c("sl", "wt", "pop", "sex", "tactic")

#Fig 5.4
panel.cor <- function(x, y, digits=1, prefix="", cex.cor = 6)
{usr <- par("usr"); on.exit(par(usr))
par(usr = c(0, 1, 0, 1))
r1=cor(x,y,use="pairwise.complete.obs")
r <- abs(cor(x, y,use="pairwise.complete.obs"))
txt <- format(c(r1, 0.1), digits=digits)[1]
txt <- paste(prefix, txt, sep="")
if(missing(cex.cor)) { cex <- 0.6/strwidth(txt) } else {
  cex = cex.cor}
text(0.5, 0.5, txt, cex = cex * r)}
pairs(pkin[, Coll], lower.panel = panel.cor, cex.labels = 1.5)
# sl and wt are collinear      (drop weight)
# sex and tactic are collinear (drop sex)

######################################
#PLOT RELATIONSHIPS

# Plot response variable against  covariates

# Fig. 5.5
par(mfrow=c(1,2), mar=c(5,5,1,1))
plot(spot ~ sl,  data = pkin, 
     xlab = "Length (mm)", cex.lab = 1.2,
     ylab = "Presence of operculum spot")
boxplot(spot ~ tactic, data = pkin, 
        xlab = "Mating tactic", cex.lab = 1.2,
        ylab = "Presence of operculum spot")


##############################################

# Question
# What variables underpin the presence of 
# red operculum spots in pumpkinseed fish

##############################################

# So, for the model
# 1. No NAs to remove
# 2. No outliers
# 3. Lots of zeros - but that is expected
# 4. Some imbalance
# 5. Collinearity (drop sex and weight)
# 6. Presence of red spot is the response variable (binomial data)

#####################################

# Model formulation - Bernoulli GLM

Bern1 <- glm(spot ~ tactic * sl,
                 data = pkin,
                 family = binomial(link = "logit"))

# Run model without the interaction term
Bern2 <- glm (spot ~ tactic + sl,
                  data = pkin,
                  family = binomial(link = "logit"))

# Compare the models using AIC (best fitting model has low score)
AIC(Bern1,Bern2)

# df      AIC
# Bern1  6  851.0 <- better fitting model
# Bern2  4  861.9

# So Bern1 (with interaction) is better fitting model

# MODEL VALIDATION

# Get the fitted values
E1 <- resid(Bern1, type = "pearson")
F1 <- fitted(Bern1)

# Fig 5.6
# Plot residuals versus fitted values
par(mfrow = c(1,1), mar = c(5,5,1,1), cex.lab = 1.2)

Fitted <- fitted(Bern1)
Resid  <- resid(Bern1, type = "pearson")
par(mfrow = c(1,1), mar = c(5,5,2,2), cex.lab = 1.2)
plot(x = Fitted, y = Resid,
     xlab = "Fitted values", 
     ylab = "Pearson Residuals")
abline(h = 0, lty = 2)

# Fig 5.7
#Plot residuals vs sl
par(mfrow = c(2,2), mar = c(5,5,1,1), cex.lab = 1.2)
plot(x = pkin$sl,
     y = Resid,
     cex.lab = 1.2,
     xlab = "sl (mm)",
     ylab = "Pearson residuals")
abline(h = 0, lty = 2) 

# Plot the residuals vs mating tactic type.
boxplot(Resid ~ tactic, 
        cex.lab = 1.2,
        data = pkin, 
        xlab = "Mating tactic",
        ylab = "Pearson residuals",
        cex.lab = 1.2)
abline(0,0, lty=2)

#Plot residuals vs weight
plot(x = pkin$wt,
     y = Resid,
     cex.lab = 1.2,
     xlab = "weight (g)",
     ylab = "Pearson residuals")
abline(h = 0, lty = 2) 

# Plot the residuals vs sex.
boxplot(Resid ~ sex, 
        cex.lab = 1.2,
        data = pkin, 
        xlab = "Sex",
        ylab = "Pearson residuals",
        cex.lab = 1.2)
abline(0,0, lty=2)

# Fig 5.8
# Plot cook's distance to identify influential observations.
par(mfrow = c(1,1), mar = c(5,5,2,2), cex.lab = 1.2)
plot(cooks.distance(Bern1),
     xlab = "Observation", 
     ylab = "Cook's distance",
     type = "h", 
     ylim = c(0, 1.2),
     cex.lab =  1.2)
abline(h = 1, lty = 2)

#Model summary
summary(Bern1)

#                 Estimate  Std. Error  z value  Pr(>|z|)    
# (Intercept)    -5.006844   0.531217  -9.425  < 2e-16
# tacticsneak    -2.896331   1.963055  -1.475    0.14010    
# tacticterr     -0.306384   0.865575  -0.354    0.72336    
# sl              0.042615   0.005955   7.156    8.31e-13
# tacticsneak:sl  0.081898   0.031052   2.637    0.00835
# tacticterr:sl   0.030570   0.010692   2.859    0.00425
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 1199.16  on 899  degrees of freedom
# Residual deviance:  839.03  on 894  degrees of freedom
# AIC: 851.03

# R2 = 1199 - 839 / 1199 = 30%

############################################################

# Figure
# 1. Prob red spot against sl for different tactics

#Create data on grid, and the matching X matrix
range(pkin$sl)
# 35 - 143

MyData <- expand.grid(
         tactic = levels(pkin$tactic),
         sl = seq(35, 145, length = 100))

X <- model.matrix(~ tactic * sl, data = MyData)
head(MyData)

#Calculate predicted values for model M1
MyData$Pred <- X %*% coef(Bern1)

#Calculate on the predictor scale
MyData$Pi  <- exp(MyData$Pred) / (1 + exp(MyData$Pred))

#Calculate standard errospot (SE) for predicted values for model M2
MyData$se <- sqrt(  diag(X %*% vcov(Bern1) %*% t(X))  )

#Calculate the SEs on the scale of the predictor function
MyData$SeUp  <- exp(MyData$Pred + 1.96 *MyData$se) / 
               (1 + exp(MyData$Pred  + 1.96 *MyData$se))
MyData$SeLo  <- exp(MyData$Pred - 1.96 *MyData$se) / 
               (1 + exp(MyData$Pred  - 1.96 *MyData$se))

head(MyData)


# Define labels
label_tactic <- c(fem = "Female", sneak = "Sneaker", terr = "Territorial")

p <- ggplot()
p <- p + geom_jitter(data = pkin, position = position_jitter
        (width = 0.05, height = 0.02), aes(y = spot, x = sl), 
        shape = 19, size = 1)
p <- p + xlab("Fish length (mm)") + ylab("Probability of red spot")
p <- p + scale_x_continuous(limits = c(30, 150))
p <- p + scale_y_continuous(limits = c(-0.03, 1.03))
p <- p + theme(text = element_text(size=13)) 
p <- p + theme(panel.background = element_blank())
p <- p + theme(panel.border = element_rect(fill = NA, colour = "black", size = 1))
p <- p + theme(strip.background = element_rect
         (fill = "white", color = "white", size = 1))
p <- p + geom_line(data = MyData, aes(x = sl, y = Pi), colour = "black", size = 1)
p <- p + geom_ribbon(data = MyData, aes(x = sl, 
                     ymax = SeUp, ymin = SeLo), alpha = 0.4)
p <- p + facet_grid(.~ tactic, 
                       scales = "fixed", space = "fixed", labeller=labeller     
                       (tactic = label_tactic))
p

##END OF EXERCISE