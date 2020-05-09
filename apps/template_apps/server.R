# Memuat Library ----

library(shiny)
library(tidyverse)
library(deSolve)
library(DT)

# Definisikan Fungsi Model ----

model <- function(time, stocks, auxs){
  with(as.list(c(stocks, auxs)),{
    
    "<Definisikan fungsi model>"
  })
}

# Definisikan Proses Perhitungan Dalam Server ----

function(input, output) {
  
  data <- eventReactive(input$goButton, {
    # nilai awal sistem
    stocks <- c("<Definisikan input stocks>")
    auxs <- c("<Definisikan input auxs>")
    
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