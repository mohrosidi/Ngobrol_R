#-----------Memuat Library-----------

library(deSolve)
library(tidyverse)

#----------Spesifikasi Kondisi Awal dan Konstanta----------

Susceptible <- 200000000; Infected <- 1; Recovered <- 0
TotalPopulation <- Susceptible + Infected + Recovered

stocks <- c(sSusceptible = Susceptible, sInfected = Infected, 
            sRecovered = Recovered)
auxs <- c(aTotalPopulation = TotalPopulation, aEffective.Contact.Rate = 2, 
          aDelay = 2)

#----------Spesifikasi Durasi Simulasi----------

START <- 0
FINISH <- 30
STEP <- 0.125

simtime <- seq(START, FINISH, STEP)

#----------Fungsi Dinamika Sistem----------

model <- function(time, stocks, auxs){
  with(as.list(c(stocks, auxs)),{
    aBeta <- aEffective.Contact.Rate / aTotalPopulation
    aLambda <- aBeta * sInfected
    
    fIR <- sSusceptible * aLambda
    fRR <- sInfected / aDelay
    
    dS_dt <- -fIR
    dI_dt <- fIR - fRR
    dR_dt <- fRR
    
    return(list(c(dS_dt, dI_dt, dR_dt),
                IR = fIR, RR = fRR))
  })
}


#----------Simulasi----------

data <- data.frame(ode(y = stocks, times = simtime,
                       func = model, parms = auxs, method = "euler"))

#----------Visualisasi----------

data %>%
  gather(key = "parameter", value = "nilai",
         -time) %>%
  ggplot(aes(x = time, y = nilai)) +
  geom_line() +
  labs(x = "Waktu (hari)", y = "nilai") +
  facet_wrap(~parameter, scales = "free_y") +
  theme_classic()
