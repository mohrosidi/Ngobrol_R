# Memuat Library ----

library(shiny)
library(tidyverse)
library(deSolve)
library(DT)

# Definisikan Fungsi Model ----

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

# Definisikan Proses Perhitungan Dalam Server ----

function(input, output) {
  
  data <- eventReactive(input$goButton, {
    # nilai awal sistem
    BODr <- input$bod; DOr <- input$do; Qr <- input$qr
    BODe <- input$bode; DOe <- input$doe; Qe <- input$qe
    
    BODmix <- ((BODr*Qr)+(BODe*Qe))/(Qr+Qe)
    DOmix <- ((DOr*Qr)+(DOe*Qe))/(Qr+Qe)
    
    stocks <- c(BOD = BODmix, DO = DOmix)
    auxs <- c(BODinput = input$bodinput, k1 = input$k1, k2 = input$k2, DOsat = input$dosat)
    
    # menghitung step simulasi
    simtime <- seq(0, input$end, input$step)
    
    # simulasi
    
    data.frame(ode(y = stocks, times = simtime,
                   func = model, parms = auxs, method = input$method))
    
  })
  
  # visualisasi data
  output$plot <- renderPlot({
    data() %>%
      gather(key = "parameter", value = "konsentrasi",
             -time) %>%
      ggplot(aes(x = time, y = konsentrasi)) +
      geom_line() +
      labs(x = "Waktu (hari)", y = "Konsentrasi (mg/l)") +
      facet_wrap(~parameter, scales = "free_y") +
      theme_classic()
  })
  
  # tabel data
  output$table <- DT::renderDataTable({
    DT::datatable(data())
  })
}