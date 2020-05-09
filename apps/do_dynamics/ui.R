library(shiny)
library(DT)
library(shinycssloaders)

# ----Atur opsi loader yang digunakan----
options(spinner.color="#0275D8", spinner.color.background="#ffffff", spinner.size=2)


# ----Spesifikasikan tampilan aplikasi----

fluidPage(
  
  # Judul Aplikasi ----
  titlePanel("Dissolved Oxygen Dynamics"),
  
  # Sidebar layout dengan pendefinisian input dan output ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input : Nilai awal BOD dan DO sistem ----
      h4("Konsentrasi Awal Parameter Sistem"),
      numericInput("bod", "BOD (mg/L) :", min = 0, max = 50, value = 3.3),
      numericInput("do", "DO (mg/L) :", min = 0, max = 15, value = 8.5),
      
      br(),
      
      # Input : Parameter Sistem ----
      h4("Nilai Parameter Sistem"),
      numericInput("bodinput", "BOD Input (mg/L) :", min = 0, max = 50, value = 1),
      numericInput("k1", "Koefisien Deoksigenasi (/hari) :", min = 0, max = 0.2, value = 0.3),
      numericInput("k2", "Koefisien Reoksigenasi (/hari) :", min = 0, max = 15, value = 0.4),
      numericInput("dosat", "DO Saturasi (mg/L) :", min = 0, max = 15, value = 11),
      
      br(),
      
      # Input: Parameter Simulasi ----
      h4("Nilai Parameter Simulasi"),
      numericInput("end", "Durasi Simulasi (hari) :", min = 0, max = 1000, value = 12),
      numericInput("step", "Step Simulasi (hari) :", min = 0, max = 2, value = 0.01),
      radioButtons("method", "Metode Integrasi:",
                   c("Euler" = "euler",
                     "Runge Kutta Orde 4" = "rk4")),
      
      # br() element to introduce extra vertical spacing ----
      br(),
      
      # Input: Slider for the number of observations to generate ----
      actionButton("goButton", "Run")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", withSpinner(plotOutput("plot"), type = 3)),
                  tabPanel("Table", withSpinner(DT::dataTableOutput("table"), type = 3))
      )
      
    )
  )
)
