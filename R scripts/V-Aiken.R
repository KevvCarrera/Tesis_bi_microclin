V_Aiken <- function(puntajes, minimo, maximo){
  m <- nrow(puntajes)
  n <- ncol(puntajes)
  k <- maximo-minimo
  X <- rowSums(puntajes)/n
  V <- (X-minimo)/k
  return(V)
}

# Lectura de datos
library(readxl)
misDatos <- read_excel("D:/Proyectos/Tesis_bi_microclin/Calculos Excel/Validacion cuestionario.xlsx", sheet = "V-Aiken")
View(misDatos)

puntajes <- misDatos
puntajes
class(puntajes)
valores_V <- V_Aiken(puntajes,1,5)
valores_V

validezInstrumento <- mean(valores_V)
validezInstrumento