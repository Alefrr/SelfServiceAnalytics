library(shinythemes)
library(ggplot2)
library(rintrojs)

ui <- fluidPage( 
  introjsUI(),
  theme = shinytheme("slate"),
  navbarPage(
    # theme = "cerulean",  # <--- To use a theme, uncomment this
    "Self Service Analytics",
    # tags$script(
    #   HTML("var header = $('.navbar > .container-fluid');
    #                           header.append('<div style=\"float:right; padding-top: 8px\"><button id=\"help\" type=\"button\" class=\"btn btn-primary action-button\">Press for instructions</button></div>')")
    # ),
    tabPanel("Visualization",
             sidebarPanel(
              introBox(fileInput("file", "File input:"),
                       data.step = 1, data.intro = "Upload a csv dataset here"),
              introBox(selectInput("column1", "X", choices=""),
                       data.step = 2, data.intro = "Select X variable to be plotted"),
              introBox(selectInput("column2", "Y", choices=""),
                       data.step = 3, data.intro = "Select Y variable to be plotted"),
               selectInput("column3", "Color", choices="", selected = NULL),
               sliderInput("slider", "% Observations Read input:", 1, 100, 30),
               radioButtons("tipo_grafico", "Tipologia Grafico",
                            c("Scatterplot", "Line", "Heatmap")),
              
              actionButton("help","Press for instructions")
               # tags$h5("Default actionButton:"),
               # actionButton("action", "Search"),
               # 
               # tags$h5("actionButton with CSS class:"),
               # actionButton("action2", "Action button", class = "btn-primary")
             ),
             mainPanel(
               tabsetPanel(
                 tabPanel("Plot",
                          tableOutput("table"),
                          verbatimTextOutput("txtout"),
                          plotOutput("dynamicplot")
                 ),
                 tabPanel("Predict", "This panel is intentionally left blank")
                 # tabPanel("Tab 3", "This panel is intentionally left blank")
               )
             )
    )
    # tabPanel("Navbar 2", "This panel is intentionally left blank"),
    # tabPanel("Navbar 3", "This panel is intentionally left blank")
  )
  
)