library(readxl)
library(psych)

#Obtener datos
misDatos1 <- read_excel("D:/CARRERA-HUAMANJULCA/Calculos Excel/Validacion cuestionario.xlsx", sheet = "Alfa")
misDatos1

# Prueba de Alfa de Cronbach
Alfa <- alpha(misDatos1)
Alfa
