# Lectura de datos

library("readxl")
library("irr")

datokappa <- read_excel("D:/Proyectos/Tesis_bi_microclin/Calculos Excel/Validacion cuestionario.xlsx", sheet = "Fleiss")
View(datokappa)

kappam.fleiss(datokappa)

