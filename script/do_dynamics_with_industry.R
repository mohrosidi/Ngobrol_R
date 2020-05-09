#-----------Memuat Library-----------

# install.packages(c("desolve", "tidyverse"))

library(deSolve)
library(tidyverse)

#----------Spesifikasi Kondisi Awal dan Konstanta----------

BODr <- 3.3; DOr <- 8.5; Qr <- 300000
BODe <- 40; DOe <- 2; Qe <- 100000

BODmix <- ((BODr*Qr)+(BODe*Qe))/(Qr+Qe)
DOmix <- ((DOr*Qr)+(DOe*Qe))/(Qr+Qe)

stocks <- c(BOD = BODmix, DO = DOmix)
auxs <- c(BODinput = 1.5, k1 = 0.3, k2 = 0.4, DOsat = 11,
          Qr = 300000, Qe = 100000, DOe = 2, BODe = 40)

#----------Spesifikasi Durasi Simulasi----------

START <- 0
FINISH <- 20
STEP <- 0.01

simtime <- seq(START, FINISH, STEP)

#----------Fungsi Dinamika Sistem----------

model <- function(time, stocks, auxs){
  with(as.list(c(stocks, auxs)),{
    
    BODout <- k1*BOD
    Deoksigenasi <- k1*BOD
    Reoksigenasi <- (DOsat - DO) * k2
    
    dBOD_dt <- BODinput - BODout
    dDO_dt <- Reoksigenasi - Deoksigenasi
      
    return(list(c(dBOD_dt, dDO_dt),
                Deoksigenasi = Deoksigenasi,
                Reoksigenasi = Reoksigenasi))
  })
}


#----------Simulasi----------

data <- data.frame(ode(y = stocks, times = simtime,
                       func = model, parms = auxs, method = "euler"))

#----------Visualisasi----------

data %>%
  gather(key = "parameter", value = "konsentrasi",
         -time) %>%
  ggplot(aes(x = time, y = konsentrasi)) +
  geom_line() +
  labs(x = "Waktu (hari)", y = "Konsentrasi (mg/l)") +
  facet_wrap(~parameter, scales = "free_y") +
  theme_classic()
