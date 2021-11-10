#class: hide-logo
# remotes::install_github("jhelvy/xaringanBuilder")
# remotes::install_github('rstudio/chromote')
# xaringanBuilder::build_pdf("MULTIVARIADOS_1.Rmd", complex_slides = TRUE)
# pagedown::chrome_print("MULTIVARIADOS_1.html",output="test.pdf")

# xaringan::inf_mr()
# http://arm.rbind.io/slides/xaringan.html
# <center> <span style= 'color: #949494;'>  </span> </center>
# Math expressions https://www.authorea.com/users/77723/articles/110898-how-to-write-mathematical-equations-expressions-and-symbols-with-latex-a-cheatsheet

library(xaringan)
decktape("https://irwingss.github.io/R-IIAP-UNAMAD/", 
                   "xaringan.pdf", 
                   docker = FALSE,
         args="--chrome-arg=--disable-web-security")

decktape(
  "https://irwingss.github.io/R-IIAP-UNAMAD/slide1/",
  "/prueba.pdf",
  args = "--chrome-arg=--disable-web-security",
  docker = Sys.which("decktape") == "",
  version = "",
  open = TRUE
)

decktape("index.html", "analisis.pdf")

decktape("https://stackoverflow.com/questions/48753691/cannot-access-cssrules-from-local-css-file-in-chrome-64/49160760#49160760", 
                   "web.pdf")
getwd()
xaringanBuilder::build_pdf("slide1/index.html", complex_slides = TRUE)

cd ./AppData/Roaming/npm/node_modules/decktape/node_modules/puppeteer/lib/cjs/puppeteer/node

npm run install

?pagedown::chrome_print

cd ./AppData/Roaming/npm/node_modules/decktape

npm run 




install.packages("rlang")
remotes::install_github("rstudio/chromote")
install.packages(c("progress", "jsonlite", "pdftools", "digest"))


source("https://git.io/xaringan2pdf")
xaringan_to_pdf("https://irwingss.github.io/R-IIAP-UNAMAD")
xaringan_to_pdf("https://slides.garrickadenbuie.com/extra-special-xaringan/")
xaringan_to_pdf("slide1/index.html")

pagedown::chrome_print("C:/Users/irwin/Documents/Proyectos_de_R/R-IIAP-UNAMAD/R-IIAP-UNAMAD/slide1/index.html",output="test.pdf")
library(chromote)
ChromoteSession$new(auto_events = FALSE)
xaringan_to_pdf("https://irwingss.github.io/R-IIAP-UNAMAD/slide1")
xaringan_to_pdf("https://slides.garrickadenbuie.com/extra-special-xaringan/")

pagedown::chrome_print("C:/Users/irwin/Documents/Proyectos_de_R/R-IIAP-UNAMAD/R-IIAP-UNAMAD/slide1/index.html", output="diapos.pdf")


pagedown::chrome_print("C:/Users/irwin/Documents/Proyectos_de_R/R-IIAP-UNAMAD/R-IIAP-UNAMAD/slide1/index.html", output="slides1.pdf")

remotes::install_github('rstudio/pagedown', force=TRUE)
pagedown::chrome_print("http://127.0.0.1:7276/slide1/index.html", output="ejemplo.pdf")

pagedown::chrome_print("slide1/index.html", format = "pdf")
