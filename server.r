library(shiny)
library(shinydashboard)
library(arules)
library(stringr)
library(datasets)
#####################################################################################################################
source("Apriori.r", local = TRUE)
#####################################################################################################################
Logged = FALSE;
REGISTERED = FALSE;
#PASSWORD <- data.frame(Username = "1", Password = "1")
PASSWORD <- read.csv("pw_db.csv", header = TRUE)
PASSWORD <- as.data.frame(PASSWORD)
print(PASSWORD)
#source("Login.r",  local = TRUE)
server <- function(input, output){
  
  source("Login.r", local = TRUE)
  ############
  output$text1 <- renderText({ 
    "Welcome"
  })
  
  observe({
    
    if(!is.null(input$logout)){
      if(input$logout > 0){
        stopApp()
      }
    }
    
    if (USER1$REGISTERED == TRUE){
      print("True")
      
      output$page1 <- renderUI({
        
        sidebarMenu( 
          #menuItem("Georgia Tech Course Catalog",icon = icon("dashboard"),href = "http://www.catalog.gatech.edu/courses-grad/ece/"),
                     
                    menuItem("Links!",icon = icon("external-link-square"),
                             menuSubItem("Your BuzzPort!! ", icon = icon("dashboard"), href = "https://buzzport.gatech.edu/cp/home/displaylogin"),
                             menuSubItem("Find your Course!!  - Georgia Tech Course Catalog", icon = icon("dashboard"), href = "https://oscar.gatech.edu/pls/bprod/bwckctlg.p_disp_dyn_ctlg"),
                             menuSubItem("Average Course Grade!! - Georgia Tech Course Critique", icon = icon("dashboard"), href = "https://critique.gatech.edu/")
                             ),
                     
                     title=("Enter personal information"),
                     textInput("name","Enter your name",""),
                     selectInput("mydegreelevel","Enter your degree level",c("UG" ,"Master's", "PhD", " "),selected= " ", selectize = TRUE),
                     #selectInput("uField","Enter your field of study",choices = c("ECE" =1 ,"CS"=2, " "=3),selected= " ", selectize = TRUE)
                     selectInput("uField","Enter your field of study",c("ECE" ,"CS", " "),selected= " ", selectize = TRUE),
                     selectInput("uTIG","Enter your TIG", tig.list, selected= " ", selectize = TRUE),
                     selectInput("uTerm","Enter your Term", c("Fall","Spring"," " ),selected=" ",selectize = TRUE, multiple = FALSE),
                     selectInput("uSem","Is this your 1st sem?", c("YES","NO"," " ),selected=" ",selectize = TRUE, multiple = FALSE),
                     uiOutput("y2"),
                
                    actionButton("done", "Done")
                   
        )
      })
    
    }
    
    
    
    if (USER$Logged == TRUE){
      
      
      output$page1 <- renderUI({
        
       sidebarMenu( 
         #menuItem("Georgia Tech course catalog",icon = icon("dashboard"),href = "http://www.catalog.gatech.edu/courses-grad/ece/"),
         menuItem("Important Links!",icon = icon("external-link-square"),
                  menuSubItem("Your BuzzPort!! ", icon = icon("forumbee"), href = "https://buzzport.gatech.edu/cp/home/displaylogin"),
                  menuSubItem("Find your Course!!  - Georgia Tech Course Catalog", icon = icon("graduation-cap"), href = "https://oscar.gatech.edu/pls/bprod/bwckctlg.p_disp_dyn_ctlg"),
                  menuSubItem("Average Course Grade!! - Course Critique", icon = icon("book"), href = "https://critique.gatech.edu/"),
                  menuSubItem("Georgia Tech Calender", icon = icon("calendar"), href = "http://www.registrar.gatech.edu/calendar/")
         ),
         
         
         
        selectInput("uTerm","Enter your Term", c("Fall","Spring"," " ),selected=" ",selectize = TRUE), 
        selectInput("uTIG","Enter your TIG", tig.list, selected= " ", selectize = TRUE),
        selectInput("uCourse","Enter your courses taken", courses$Full_Info, selected=" ",selectize = TRUE, multiple = TRUE),
        
        #checkboxGroupInput("Tabs", label=h4("tabpanel"),choices=list("tabs"="Tabs"),selected = NULL)
        actionButton("logout", "Logout")
        
        )
      })
      
      
      
      
      
      output$page2 <- renderUI({
        
       fluidRow( (title="Personal information"),
        textOutput("myname"),
        textOutput("mydegreelevel"),
        textOutput("myufield"),
        textOutput("myuTIG"),
        #selectInput("myusem"),
        
        tabsetPanel(
          tabPanel("All courses", dataTableOutput("mydatabase1")),
          tabPanel("Recommended",dataTableOutput("mydatabase"))
          
          
        )
       )
      })
      
      PASSWORD <- read.csv("pw_db.csv", header = TRUE)
      PASSWORD <- as.data.frame(PASSWORD)
      Username <- isolate(input$userName)
      Password <- isolate(input$passwd)
      pwd <- read.csv("pw_db.csv")
      Id.username <- which(PASSWORD$Username == Username)
      n1 <- pwd[Id.username[1],3]
      output$myname <- renderText(
        paste("Name is:", n1 ))
      n2 <- pwd[Id.username[1],4]
      output$mydegreelevel <- renderText(
        paste("Degree Level:",n2 ))
      n3 <- pwd[Id.username[1],5]
      output$myufield <- renderText(
        paste("Field is:",n3) )
      n4 <- pwd[Id.username[1],6]
      
      output$myuTIG <- renderText(
        paste("TIG :",n4) )
     
      # output$myuCourse <- renderText(
      #   paste("Courses :",input$uCourse) )
    ###########################################################  
      # m <- dim(rules2)[1]
      # n <- dim(rules2)[2]
      # mat <- matrix(0:0 ,m,n)
      
      #mat[1, ] <- rules1[1, ]
      
      output$mydatabase <- renderDataTable({
        
        # rulesmat <-  as.matrix(rules2)
        # for (i in 1:dim(rules2)[1]){
        #   if(all(is.na(str_match(rulesmat[i,1],input$uCourse)))==FALSE){
        #     mat[i, ]<-rulesmat[i, ]
        #   }
        #   
        #   
        # }
        # # mat <- mat[(all(is.na(str_match(mat[ ,1],"LSC")))==FALSE)]
        # mat <- mat[mat[ ,1]!=0, ]
        # matt <- as.data.frame(mat)
        # reco<-matt[ ,3]
        # recommend <- levels(reco)
        # 
        # recommend1 <- as.data.frame(recommend)
        # recommend1mat <- as.matrix(recommend1)
        ########################################################################################
       if(input$uTerm == "Fall") 
       {
        course.input <- input$uCourse
        rules.search <- rules2[grep(paste(course.input, collapse="|"), rules2$lhs),]
        rules.search1 <- as.data.frame(unique(rules.search[, 2]))
       }
      else{
          course.input <- input$uCourse
          rules.search <- rules2.spring[grep(paste(course.input, collapse="|"), rules2.spring$lhs),]
          rules.search1 <- as.data.frame(unique(rules.search[, 2]))
          }  
        ########################################################################################
        recommend1mat <- as.matrix(rules.search1)
        a <- dim(recommend1mat)[1]
        b <- dim(recommend1mat)[2]
        temp <- matrix(0:0 ,a,b)
        
        if(a!=0){
          
          for (i in 1:a)
          {
            
            if(all(is.na(str_match(recommend1mat[i,1],input$uCourse)))==TRUE){
              temp[i,1 ]<-recommend1mat[i,1 ]
            }
            
          }
          
          temp <- temp[temp[ ,1]!=0, ]
          tempdata <- as.data.frame(temp)
          
          ######################################################################################
          
          tempdata[]
          
          
        }else{
          
          
          rules.search1[]
          
        }
        
      })
    
      
      #############################################################################################3
      
      output$mydatabase1 <- renderDataTable({
        
        tig.ece <- switch(input$uTIG,
                     "BioEngineering" = courses.by.tig.ece[,1],
                     "Computer Systems and Software" = courses.by.tig.ece[,2],
                     "Digital Signal Processing" = courses.by.tig.ece[,3],
                     "Electrical Energy" = courses.by.tig.ece[,4],
                     "Electromagnetics" = courses.by.tig.ece[,5],
                     "Electronic Design and Applications" = courses.by.tig.ece[,6],
                     "Microelectronics" = courses.by.tig.ece[,7],
                     "Optics & Photonics" = courses.by.tig.ece[,8],
                     "Systems ad Controls" = courses.by.tig.ece[,9],
                     "Telecommunications" = courses.by.tig.ece[,10],
                     "VLSI" = courses.by.tig.ece[,11],
                     "Computation Perception and Robotics" = courses.by.tig.ece[,12],
                     "Computer Graphics" = courses.by.tig.ece[,13],
                     "Computing Systems" = courses.by.tig.ece[,14],
                     "Human Computer Interaction" = courses.by.tig.ece[,15],
                     "Interactive Intelligence" = courses.by.tig.ece[,16],
                     "Electronic Design and Applications" = courses.by.tig.ece[,17],
                     "Machine Learning" = courses.by.tig.ece[,18],
                     "Social Computing" = courses.by.tig.ece[,19],
                     "Visual Analytics" = courses.by.tig.ece[,20]
                     
                     
                     
                     
        )
        
        # tig.cs <- switch(input$uTIG,
        #                   "Computation Perception and Robotics" = courses.by.tig.cs[,1],
        #                   "Computer Graphics" = courses.by.tig.cs[,2],
        #                   "Computing Systems" = courses.by.tig.cs[,3],
        #                   "Human Computer Interaction" = courses.by.tig.cs[,4],
        #                   "Interactive Intelligence" = courses.by.tig.cs[,5],
        #                   "Electronic Design and Applications" = courses.by.tig.cs[,6],
        #                   "Machine Learning" = courses.by.tig.cs[,7],
        #                   "Social Computing" = courses.by.tig.cs[,8],
        #                   "Visual Analytics" = courses.by.tig.cs[,9]
        #                                         
        # )
        
        tig1.ece <-as.data.frame(tig.ece)
        #tig1.cs <-as.data.frame(tig.cs)
        #output$mydatabase1 <- renderDataTable({
        if (n2 == "Master's")
          
        {
          
          tig1.ece[]
        }
        
      })
      
    }
  })
}