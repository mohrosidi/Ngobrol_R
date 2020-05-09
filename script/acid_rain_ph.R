# ----Memuat library----
library(rootSolve)

# ----Definisikan nilai koefisien atau konstanta----

# Koefisien kesetimbangan
K1 <- 10^(-6.3) # konstanta kesetimbangan Co2
K2 <- 10^(-10.3) # konstanta kesetimbangan bikarbonat
Kw <- 10^(-14) # konstantan kesetimbangan air
Kh <- 10^(-1.46) # konstanta Henry

# Nilai tekanan parsial CO2 tahun 1958 dan 2003

pCO2_1958 <- 315
pCO2_2003 <- 375

# ----Definisikan fungsi persamaan non-linier ----

fun_1958 <- function(H){
  
  (K1/(10^(6)*H))*Kh*pCO2_1958 + 2*(K1*K2/(10^(6)*H^(2)))*Kh*pCO2_1958 + (Kw/H) - H
}

fun_2003 <- function(H){
  
  (K1/(10^(6)*(H)))*Kh*pCO2_2003 + 2*(K1*K2/(10^(6)*(H^(2))))*Kh*pCO2_2003 + (Kw/H) - H
}

# ----Mencari akar persamaan melalui visualisasi data----

# 1958
curve(fun_1958, from = 10^(-14) , to = 10^(-1))

# 2003
curve(fun_2003, from = 10^(-14) , to = 10^(-1))

# ----Mencari akar persamaan melalui fungsi uniroot.all----

# 1958
-log10(uniroot.all(fun_1958, interval = c(10^(-2), 10^(-12))))

# 2003
-log10(uniroot.all(fun_2003, interval = c(10^(-2), 10^(-12))))

