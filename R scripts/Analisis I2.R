# Indicator2: Tiempo de búsqueda de información

# Import libraries
library(readxl)
library(nortest)
library(moments)
library(Hmisc)
library(psych)

# Data read
datos <- read_excel("D:/Proyectos/Tesis_bi_microclin/Calculos Excel/Hoja de registro de tiempos.xlsx", sheet = "I2")

# Ensure that data are numerical
pretest <- as.numeric(datos$`Pretest`)

# Descriptive analysis
describe(pretest)

# ================= PRETEST ===========================


# Graphic analysis

# Histogram
hist(pretest, freq = FALSE, main = "Histograma de pretest", xlab = "Valores")
lines(density(pretest))
curve(dnorm(x, mean(pretest), sd(pretest)), add = TRUE, col = "blue", lwd = 2)
legend("topright", c("Curva observada", "Curva normal teórica"), lty = 1, lwd = 2, col = c("black", "blue"))

# Q-Q Plot
qqnorm(pretest, main = "Gráfico Q-Q para Postest")
qqline(pretest, lwd = 2)

# Boxplot
boxplot(pretest, main = "Diagrama de Caja para Pretest", ylab = "Valores")
points(mean(pretest), pch = 8, col = "blue") # Media en el bloxplot


# Lilliefors normality Test
lillie.test(pretest)