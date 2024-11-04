# Cargar el paquete readxl para leer archivos Excel
library(readxl)

# Leer los datos
misDatos <- read_excel("D:/Proyectos/Tesis_bi_microclin/Calculos Excel/Validacion cuestionario.xlsx", sheet = "Kendall")

# Mostrar los datos
print(misDatos)

# Instalar paquete
if (!require(irr)) {
  install.packages("irr")
}
library(irr)

# Prueba Kendall
kendall(t(misDatos), correct = TRUE)
