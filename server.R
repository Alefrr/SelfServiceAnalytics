

tipi_grafico <-
  data.frame(
    tipo   = c("Scatterplot", "Line", "Heatmap"),
    string = c(
      "geom_point() + geom_smooth(method = 'lm')",
      "geom_line()",
      "geom_tile()"
    ),
    stringsAsFactors = F
  )

server <- function(input, output, session) {
  data_uploaded <- reactive({
    #if (is.null(input$file)) return(NULL)
    
    req(input$file)
    
    if (!is.null(input$file)) {
      read.csv(file = input$file$datapath)
      
    }
    
  })
  
  observe({
    vars_name <- colnames(data_uploaded())
    updateSelectInput(session, "column1", choices = c(vars_name, "NULL"))
    updateSelectInput(session, "column2", choices = c(vars_name, "NULL"))
    updateSelectInput(session, "column3",
                      choices = c('NULL', vars_name))
    
  })
  
  output$txtout <- renderPrint({
    if (is.null(data_uploaded())) {
      return("ciao")
    }
    else{
      obs_filtered <- sample(1:dim(data_uploaded())[1],
                             input$slider / 100 * dim(data_uploaded())[1])
      
      str(data_uploaded()[obs_filtered, ])
    }
  })
  
  output$table <- renderTable({
    data_plot <- data_uploaded()
    
    head(data_plot[, c(input$column1, input$column2), drop = FALSE])
    
  })
  
  output$dynamicplot <- renderPlot({
    obs_filtered <- sample(1:dim(data_uploaded())[1],
                           input$slider / 100 * dim(data_uploaded())[1])
    
    columnx     <- sym(input$column1)
    columny     <- sym(input$column2)
    columncolor <- sym(input$column3)
  
  data_plot <- data_uploaded()[obs_filtered,]
  
  base_call <- if (!input$column3=="NULL") {
    print("entro qua")
    deparse(quote(ggplot(
      data = data_plot, aes(
        x    = !!columnx,
        y    = !!columny,
        color = !!columncolor
      )
    )))
  } else{
    print("entro la")
    verifica <- !is.null(eval(parse(text=input$column3)))
    print(verifica)
    deparse(quote(ggplot(data = data_plot, aes(
      x    = !!columnx,
      y    = !!columny)
      )))
    
  }
  
  theme_call <- deparse(quote(theme_minimal()))
  
  selected_call <-
    tipi_grafico$string[tipi_grafico$tipo == input$tipo_grafico]
  
  call_build = paste(base_call,
                     selected_call,
                     theme_call,
                     sep = " + ")
  
  eval(parse(text = call_build))
  
  })

observeEvent(input$help,
             introjs(session, options = list("nextLabel"="Next",
                                             "prevLabel"="Back"
                                             # "skipLabel"="Don't be a quitter"
             )
             # events = list("oncomplete"=I('alert("Glad that is over")'))
             )
)
}