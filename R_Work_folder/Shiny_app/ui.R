#The ui for the application
ui <- dashboardPage(skin="blue",
                    dashboardHeader(title="INSERM 33"),
                    dashboardSidebar(
                      sidebarMenu(
                        useShinyjs(),
                        # Web site for the icons: https://fontawesome.com/icons?d=gallery&m=free
                        menuItem("Information", tabName = "info", icon = icon("book-open")),
                        menuItem("Connect to database", tabName = "connect_DB",icon= icon("database")),
                        menuItem("Run analysis with DESeq2", tabName = "DESeq2_analysis", icon= icon("chart-bar")),
                        menuItem("Results",tabName = "res", icon=icon("dna")),
                        menuItem("Custom MA plots",tabName = "cus_MA", icon=icon("file-image")),
                        menuItem("Custom Volcano plots",tabName = "cus_Volcano", icon=icon("file-image")),
                        menuItem("Citation", tabName = "citation", icon= icon("book")),
                        
                        #Sets up the code for the close button
                        extendShinyjs(text = "shinyjs.closeWindow = function() { window.close(); }", functions = c("closeWindow")),
                        
                        #Use of a flui row to set the button at the bottom
                        #Issue is that it is set there using pixel margins, so it will have to be manually adjusted when adding tabs
                        fluidRow(
                          column(6,style="margin-top: 500px;",actionButton("close", "Exit App"))
                        )
                        
                      )
                      
                    ),
                    #The main panel is set up to only contain a datatable of the dataset the user will enter, the height is limited as to ensure the table is adapted to low resolution screens
                    
                    dashboardBody(
                      useShinyjs(),
                      tabItems(
                        tabItem(tabName = "info",
                                h2("Information tab content")
                        ),
                        
                        tabItem(tabName = "connect_DB",
                                h2("Establish connection to the database"),
                                textInput("email","Email Address:"),
                                
                                selectInput("study_type", "Type of Study",
                                            choices = list("Metabolic" = "Metabolic",
                                                           "Epigenetic" = "Epigenetic",
                                                           "Metabolomic" = "Metabolomic",
                                                           "Others" = "Others"),
                                            selected = 1),
                                
                                selectInput("user_position", "Position held",
                                            choices = list("Researcher" = "Researcher",
                                                           "PhD" = "PhD",
                                                           "Student" = "Student",
                                                           "Intern" = "Intern",
                                                           "Other" = "Other"),
                                            selected = 1),
                                
                                textAreaInput("comments", "Comments", placeholder = "Feel free to add a comment",width="500px"),
                                actionButton("connect_DB", "Connect to database"),
                                textOutput("connect_db_status")
                        ),
                        
                        tabItem(tabName = "DESeq2_analysis",
                                h2("Run an analysis using DESeq2"),
                                
                                
                                useShinyjs(),
                                #Setting up the file input system of the application
                                fileInput("file1", "Choose CSV File 1",
                                          accept = c(
                                            "text/csv",
                                            "text/comma-separated-values,text/plain",
                                            ".csv")
                                ),
                                fileInput("file2", "Choose CSV File 2",
                                          accept = c(
                                            "text/csv",
                                            "text/comma-separated-values,text/plain",
                                            ".csv")
                                ),
                                
                                directoryInput('directory', label = 'select a directory', value = '~'),
                                #Adds the text_input which will take in the first condition
                                textInput("condition1", "Name of the condition for file 1", "Condition_1"),
                                
                                #Adds the text_input which will take in the first condition
                                textInput("condition2", "Name of the condition for file 2", "Condition_2"),
                                
                                #A simple checkbox which will allow users to choose if they want to do MA plots
                                checkboxInput("Make_MA", "Create standard MA Plots", value = TRUE, width = NULL),
                                
                                #A check box which will allow users to choose if they want to do Volcano plots
                                checkboxInput("Make_Volcano", "Create standard Volcano Plots", value = TRUE, width = NULL),
                                
                                #The action button which will set the analysis in motion, it is initially disabled to prevent users form clicking the button while the requirements are not fufilled
                                disabled(actionButton("launch", "Launch Analysis")),
                                textOutput("launch_status")
                        ),
                        
                        tabItem(tabName = "res",
                                h2("Results tab"),
                                textOutput("results_status"),
                                
                                tabsetPanel(id="results_tabs",type="tabs",
                                            tabPanel("Significant Genes", DT::dataTableOutput("sig_genes",width = 'auto',height = 500)),
                                            tabPanel("Non_Canonic", DT::dataTableOutput("Ncan",width = 'auto',height = 500)),
                                            tabPanel("Canonic", DT::dataTableOutput("Can",width = 'auto',height = 500)),
                                            tabPanel("References", DT::dataTableOutput("refs",width = 'auto',height = 500))
                                )
                        ),
                        
                        tabItem(tabName = "cus_MA",
                                h2("Generate custom MA plots"),
                                fluidRow(
                                  column(4,
                                         fileInput("file_custom_MA", "Choose CSV File",
                                                   accept = c(
                                                     "text/csv",
                                                     "text/comma-separated-values,text/plain",
                                                     ".csv")
                                         )
                                  ),
                                  column(4,offset=2,
                                         downloadButton('download_MA_Plot', 'Download Plot'),
                                         downloadButton('download_MA_data','Download Data')
                                  )
                                ),
                                
                                fluidRow(
                                  column(3,
                                         numericInput("p_value_thresh_MA", label = "P-value significance", value = 0.05,min = 0.0,max = 1,step = 0.01),
                                  ),
                                  column(3,
                                         textInput("title_of_MA_plot","Title of the plot","my_MA_plot")
                                  ),  
                                  
                                  column(3,
                                         tags$b("Add text to red genes"),
                                         checkboxInput("text_choice_MA","Render text", value=FALSE, width = NULL)
                                  ),
                                  column(3,
                                         tags$b("Create the plot"),
                                         actionButton("create_MA","create_MA")
                                  )
                                ),
                                plotOutput("custom_MA_plot")
                                
                                
                        ),
                        tabItem(tabName = "cus_Volcano",
                                h2("Generate custom Volcano plots"),
                                fluidRow(
                                  column(4,
                                         fileInput("file_custom_Volcano", "Choose CSV File",
                                                   accept = c(
                                                     "text/csv",
                                                     "text/comma-separated-values,text/plain",
                                                     ".csv")
                                         )
                                  ),
                                  column(2, offset=2,
                                         downloadButton('download_Volcano_Plot', 'Download Plot'),
                                         #br()/break is not working
                                         br(),
                                         downloadButton('download_Volcano_Data', 'Download Data')
                                  )
                                  # column(3,style="margin-top: 25px;",offset=1,
                                  #        downloadButton('download_Volcano_Data', 'Download Data')
                                  # )
                                ),
                                
                                fluidRow(
                                  column(3,
                                         numericInput("p_value_thresh_Volcano", label = "P-value significance", value = 0.05,min = 0.0,max = 1,step = 0.01),
                                  ),
                                  column(3,
                                         textInput("title_of_Volcano_plot","Title of the plot","my_Volcano_plot")
                                  ),  
                                  
                                  column(3,
                                         tags$b("Add text to red genes"),
                                         checkboxInput("text_choice_Volcano","Render text", value=FALSE, width = NULL)
                                  ),
                                  column(3,
                                         tags$b("Create the plot"),
                                         actionButton("create_Volcano","create_Volcano")
                                  ),
                                ),
                                fluidRow(
                                  column(4,offset=1,
                                         numericInput("lfc_value_thresh", label = "LFC threshold", value = 1,min = 0.0,max = 5,step = 0.5),
                                  ),
                                  column(4,offset=1,
                                         selectInput("legend_position", "Position of legend on graph",
                                                     choices = list("bottomleft" = "bottomleft",
                                                                    "bottom" = "bottom",
                                                                    "bottomright" = "bottomright",
                                                                    "left" = "left",
                                                                    "center" = "center",
                                                                    "right" = "right",
                                                                    "topleft" = "topleft",
                                                                    "top" = "top",
                                                                    "topright"="topright"),
                                                     
                                                     selected = 1),
                                  )
                                ),
                                plotOutput("custom_Volcano_plot")
                        ),
                        tabItem(tabName = "citation",
                                h2("How to cite this tool")
                        )
                        
                      ),
                      
                      #DT::dataTableOutput("contents",width = 'auto',height = 500)
                    )
)
