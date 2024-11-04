# Primero cargamos los datos de Excel
library(readxl)
library(psych) 
library(psychTools)

misDatos1 = read_excel("D:/Proyectos/Tesis_bi_microclin/Calculos Excel/Validacion cuestionario.xlsx", sheet="Omega")
View(misDatos1)

x11()
om <- omega(misDatos1)
om


