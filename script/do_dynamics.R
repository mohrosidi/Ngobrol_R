#-----------Memuat Library-----------

# install.packages(c("desolve", "tidyverse"))

library(deSolve)
library(tidyverse)

#----------Spesifikasi Kondisi Awal dan Konstanta----------

stocks <- c(BOD = 3.33, DO = 8.5)
auxs <- c(BODinput = 1, k1 = 0.3, k2 = 0.4, DOsat = 11)

#----------Spesifikasi Durasi Simulasi----------

START <- 0
FINISH <- 20
STEP <- 0.25

simtime <- seq(START, FINISH, STEP)

#----------Fungsi Dinamika Sistem----------

model <- function(time, stocks, auxs){
  with(as.list(c(stocks, auxs)),{
    
    
    BODout <-  BOD * k1
    Deoksigenasi <-  BOD * k1
    Reoksigenasi <-  ( DOsat - DO ) * k2
    
    
    dBOD = BODinput  - BODout 
    dDO = Reoksigenasi  - Deoksigenasi 
    
    return(list(c(dBOD, dDO),
                `Laju Deoksigenasi` = Deoksigenasi,
                `Laju Reoksigenasi` = Reoksigenasi))
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
