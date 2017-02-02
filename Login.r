#### Log in module ###
USER <- reactiveValues(Logged = Logged)
USER1 <- reactiveValues(REGISTERED = REGISTERED)
passwdInput <- function(inputId, label) {
  tagList(
    tags$label(label),
    tags$input(id = inputId, type="password", value="")
  )
}

output$uiLogin <- renderUI({
  if (USER$Logged == FALSE) {
    wellPanel(
      textInput("userName", "User Name:"),
      passwdInput("passwd", "Pass word:"),
      br(),
      textOutput("text1"),
      actionButton("Login", "Log in"),
      actionButton("Registered", "Register")
    )
  }
})



output$pass <- renderText ({  
  
 
  if (USER$Logged == FALSE) {
    if (!is.null(input$Login)) {
      if (input$Login > 0) {
        PASSWORD <- read.csv("pw_db.csv", header = TRUE)
        PASSWORD <- as.data.frame(PASSWORD)
        Username <- isolate(input$userName)
        Password <- isolate(input$passwd)
        Id.username <- which(PASSWORD$Username == Username)
        print(Id.username)
        Id.password <- which(PASSWORD$Password    == Password)
        if (length(Id.username) > 0 & length(Id.password) > 0) {
          if (Id.username == Id.password) {
            USER$Logged <- TRUE
          } 
        } 
        else if (length(Id.username) <= 0 & length(Id.password) <= 0) {
          output$text1 <- renderText({ 
            "Register First!"
          })
        }
        else{
          output$text1 <- renderText({ 
            "Wrong Username or Password"
          })
        }
      } 
    }
  
    if (!is.null(input$Registered)) {
      if (input$Registered > 0) {
        username <- isolate(input$userName)
        password <- isolate(input$passwd)
        USER1$REGISTERED <- TRUE
        if (input$uSem == "NO"){
          output$c <- renderText({
            "Enter previous Sem Courses"
          })
          output$page1 <- renderUI({
          sidebarMenu( #menuItem("Georgia Tech course catalog",icon = icon("dashboard"),href = "http://www.catalog.gatech.edu/courses-grad/ece/"),
            menuItem("Important Links!",icon = icon("external-link-square"),
                     menuSubItem("Your BuzzPort!! ", icon = icon("forumbee"), href = "https://buzzport.gatech.edu/cp/home/displaylogin"),
                     menuSubItem("Find your Course!!  - Georgia Tech Course Catalog", icon = icon("graduation-cap"), href = "https://oscar.gatech.edu/pls/bprod/bwckctlg.p_disp_dyn_ctlg"),
                     menuSubItem("Average Course Grade!! - Course Critique", icon = icon("book"), href = "https://critique.gatech.edu/"),
                     menuSubItem("Georgia Tech Calender", icon = icon("calendar"), href = "http://www.registrar.gatech.edu/calendar/")
            ),
                       textOutput("c"),
                       selectizeInput("course1","Enter your first course", courses$Full_Info, selected= NULL, multiple = TRUE),
                       selectizeInput("course2","Enter your second course", courses$Full_Info, selected=NULL, multiple = TRUE),
                       selectizeInput("course3","Enter your third course", courses$Full_Info, selected=NULL, multiple = TRUE),
                       selectizeInput("course4","Enter your fourth course", courses$Full_Info, selected=NULL, multiple = TRUE),
                       actionButton("done", "Done")
          )
          })
          
        }
           if (!is.null(input$done)){
             if (input$done > 0){
               LS <- data.frame(Username = username,Password= password, Name= input$name,DegreeLevel= input$mydegreelevel, Field =input$uField ,TIG=input$uTIG)
               PASSWORD <- rbind(PASSWORD,LS)
               print("saving")
               write.csv(PASSWORD, file = "pw_db.csv", row.names=FALSE)
               # output$text1 <- renderText({
               #   "Succesfully registered, please fill in Details below"
               # })
               if (input$uSem =="NO"){
                 R <- data.frame(Student.ID = input$name, Course1 = input$course1, Course2 = input$course2, Course3 = input$course3, Course4 = input$course4)
               # if (input$uTerm =="Spring"){
               #   FALL <-read.csv("C:/Users/Ishika Roy/Documents/shinyR/pw_db.csv", header = TRUE)
               #   FALL <- as.data.frame(FALL)
               #   FALL <- rbind(FALL,R)
               #   write.csv(FALL, file = "C:/Users/Ishika Roy/Documents/shinyR/pw_db.csv", row.names=FALSE)
               # }
               #   if (input$uTerm =="Fall"){
               #     SPRING <-read.csv("C:/Users/Ishika Roy/Documents/shinyR/pw_db.csv", header = TRUE)
               #     SPRING <- as.data.frame(SPRING)
               #     SPRING <- rbind(SPRING,R)
               #     write.csv(SPRING, file = "C:/Users/Ishika Roy/Documents/shinyR/pw_db.csv", row.names=FALSE)
               #   }
                 students.new <-read.csv("Student_50.csv", header = TRUE)
                   students.df.new <- as.data.frame(students.new)
                   students.df.new <- rbind(students.new,R)
                   write.csv(students.df.new, file = "Student_50.csv", row.names=FALSE)
               }
               USER$Logged <- TRUE
               
               
         }}
      }  
    }
    }
})

