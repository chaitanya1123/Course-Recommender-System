## app.R ##
library(shiny)
library(shinydashboard)

ui <- dashboardPage( skin = "red",
  dashboardHeader(   
        title = "Course Recommender System",
        titleWidth = 400
        ),
  
  
  
  
  dashboardSidebar( 
    
  

    width = 400,
    uiOutput("page1")
      
  
    
  ),
  dashboardBody(
    
    tagList(
      tags$head(
        tags$link(rel="stylesheet", type="text/css",href="style.css"),
        tags$script(type="text/javascript", src = "md5.js"),
        tags$script(type="text/javascript", src = "passwdInputBinding.js"),
        #########################################################################
        tags$style(type="text/css",
                   ".shiny-output-error { visibility: hidden; }",
                   ".shiny-output-error:before { visibility: hidden; }"
        )
        ##########################################################################
      )
    ),
    
    
    ## Login module;
    div(class = "login",
        uiOutput("uiLogin"),
        textOutput("pass")
    ), 
    
    uiOutput("page2")
    
   
  )
)
