library(shiny)
library(DT)
library(shinycssloaders)

# ----Atur opsi loader yang digunakan----
options(spinner.color="#0275D8", spinner.color.background="#ffffff", spinner.size=2)


# ----Spesifikasikan tampilan aplikasi----

fluidPage(
  
  # Judul Aplikasi ----
  titlePanel("<Judul Aplikasi>"),
  
  # Sidebar layout dengan pendefinisian input dan output ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input : Nilai awal BOD dan DO sistem ----
      h4("Konsentrasi Awal Parameter Sistem"),
      "<Definisikan input stock>",
      
      br(),
      
      # Input : Parameter Sistem ----
      h4("Nilai Parameter Sistem"),
      "<Definisikan input koefisien atau variabel eksogen>",
      
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
                  tabPanel("Plot", withSpinner(plotOutput("plot"), type = 2)),
                  tabPanel("Table", withSpinner(DT::dataTableOutput("table"), type = 2))
      )
      
    )
  )
)
