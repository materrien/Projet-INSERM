#Handles the 'actions' that are done within the application
server <- function(input, output, session) {
  
  #Hides the results table as they will be empty/non-existant
  hideTab(inputId = "results_tabs", target = "Significant Genes")
  hideTab(inputId = "results_tabs", target = "Non_Canonic")
  hideTab(inputId = "results_tabs", target = "Canonic")
  hideTab(inputId = "results_tabs", target = "References")
  
  #Create a function
  #The function is declared here as it contains server specific objects (output), thus it can only be declared within the server
  show_results <- function(List_of_results)
  {
    
    output$sig_genes <- DT::renderDataTable({
      DT::datatable(data=List_of_results[["sig_genes"]], options=list(scrollX = TRUE,scrollY=TRUE,paging=FALSE),class = 'cell-border stripe', rownames = FALSE, fillContainer = TRUE)
    })
    output$Ncan <- DT::renderDataTable({
      DT::datatable(data=List_of_results[["ncan"]], options=list(scrollX = TRUE,scrollY=TRUE,paging=FALSE),class = 'cell-border stripe', rownames = FALSE, fillContainer = TRUE)
    })
    output$Can <- DT::renderDataTable({
      DT::datatable(data=List_of_results[["can"]], options=list(scrollX = TRUE,scrollY=TRUE,paging=FALSE),class = 'cell-border stripe', rownames = FALSE, fillContainer = TRUE)
    })
    output$refs <- DT::renderDataTable({
      DT::datatable(data=List_of_results[["refs"]], options=list(scrollX = TRUE,scrollY=TRUE,paging=FALSE),class = 'cell-border stripe', rownames = FALSE, fillContainer = TRUE)
    })
  }
  
  observeEvent(input$close, 
               {
                 js$closeWindow()
                 stopApp()
               })
  
  
  
  
  #Create the MA plot
  observeEvent(input$create_MA,{output$custom_MA_plot <-renderPlot({isolate({custom_MA_plot(input$file_custom_MA$datapath, 
                                                                                            sig_pval = input$p_value_thresh_MA, 
                                                                                            main=input$title_of_MA_plot,
                                                                                            labelsig = input$text_choice_MA)})})
  })
  
  #Download the MA plot
  output$download_MA_Plot <- downloadHandler(
    filename = function(){
      paste(input$title_of_MA_plot,".png",sep="")
    },
    content = function(file){
      if (input$text_choice_MA==FALSE){
        png(file,width=1200, height=1000, pointsize=20)
      }else{
        png(file,width=5200, height=5000, pointsize=20)
      }
      
      isolate({custom_MA_plot(input$file_custom_MA$datapath, 
                              sig_pval = input$p_value_thresh_MA, 
                              main=input$title_of_MA_plot,
                              labelsig = input$text_choice_MA)})
      dev.off()
    }
  )
  
  
  
  #Download the MA plot data
  output$download_MA_data <- downloadHandler(
    filename = function(){
      paste(input$title_of_MA_plot,".csv",sep="")
    },
    content = function(file){
      x <-read.csv(file = input$file_custom_MA$datapath,check.names=FALSE)
      x <-subset(x, padj<input$p_value_thresh_MA)
      #Remove an unecessary row
      x<-x[,-1]
      write.csv(x,file)
    }
  )
  
  
  
  #Create the volcano plot
  observeEvent(input$create_Volcano,{output$custom_Volcano_plot <-renderPlot({isolate({custom_Volcano_plot(input$file_custom_Volcano$datapath, 
                                                                                                           lfcthresh = input$lfc_value_thresh,
                                                                                                           sigthresh = input$p_value_thresh_Volcano,
                                                                                                           main=input$title_of_Volcano_plot,
                                                                                                           legendpos=input$legend_position,
                                                                                                           labelsig = input$text_choice_MA)})})
  })
  
  
  
  
  #Download the Volcano plot
  output$download_Volcano_Plot <- downloadHandler(
    filename = function(){
      paste(input$title_of_Volcano_plot,".png",sep="")
    },
    content = function(file){
      
      if (input$text_choice_Volcano==FALSE){
        png(file,width=1200, height=1000, pointsize=20)
      }else{
        png(file,width=5200, height=5000, pointsize=20)
      }
      
      isolate({custom_Volcano_plot(input$file_custom_Volcano$datapath, 
                                   lfcthresh = input$lfc_value_thresh,
                                   sigthresh = input$p_value_thresh_Volcano,
                                   main=input$title_of_Volcano_plot,
                                   legendpos=input$legend_position,
                                   labelsig = input$text_choice_MA)})
      dev.off()
    }
  )
  
  #Download the Volcano plot data
  output$download_Volcano_Data <- downloadHandler(
    filename = function(){
      paste(input$title_of_Volcano_plot,".csv",sep="")
    },
    content = function(file){
      x <-read.csv(file = input$file_custom_Volcano$datapath,check.names=FALSE)
      x <-subset(x, padj<input$p_value_thresh_Volcano & abs(log2FoldChange)>input$lfc_value_thresh)
      #Remove an unecessary row
      x<-x[,-1]
      write.csv(x,file)
    }
  )
  
  
  #This creates a reactive variable
  DB_Connect <- reactiveValues(
    DB=NULL
  )
  
  #Used to check if the email is valid when clicking the 'connect' button
  observeEvent(input$connect_DB, {(
    if (isValidEmail(input$email)==FALSE){
      output$connect_db_status <- renderText("Please enter a valid email address")
    }else if (nchar(input$comments)>300){
      output$connect_db_status <- renderText(paste("Too many characters in comment box. Characters used:",nchar(input$comments)))
    }else{
      output$connect_db_status <- renderText(paste("Email address is valid. Characters in comment box:",nchar(input$comments)))
      #Change the value of the reactive variable
      DB_Connect$DB<-Connect_to_database()
    }
  )})
  
  
  #This observe event handles the setting of the directory
  observeEvent(
    ignoreNULL = TRUE,
    eventExpr = {
      input$directory
    },
    handlerExpr = {
      if (input$directory > 0) {
        # condition prevents handler execution on initial app launch
        
        # launch the directory selection dialog with initial path read from the widget
        path = choose.dir(default = readDirectoryInput(session, 'directory'))
        # update the widget value
        updateDirectoryInput(session, 'directory', value = path)
        setwd(path)
      }
    }
  )
  
  #This creates a reactive variable which will be used as a verification for the enabling of the launch button
  #Using this, the application will prevent the user from starting an analysis without having entered a dataset
  check_if_upload_File1 <- reactiveValues(
    check_upload_File1=0
  )
  
  #Sets the check_if_upload variable to one if a file has been entered by the user
  observeEvent(input$file1, {(check_if_upload_File1$check_upload_File1 <- c(1))})
  
  #This creates a reactive variable which will be used as a verification for the enabling of the launch button
  #Using this, the application will prevent the user from starting an analysis without having entered a dataset
  check_if_upload_File2 <- reactiveValues(
    check_upload_File2=0
  )
  
  #Sets the check_if_upload variable to one if a file has been entered by the user
  observeEvent(input$file2, {(check_if_upload_File2$check_upload_File2 <- c(1))})
  
  #Enables the launch button when it all necessary prerequisites are met
  observe(if(check_if_upload_File1$check_upload_File1==1 && check_if_upload_File2$check_upload_File2==1&&
             input$condition1!=""&&input$condition2!="" && is.null(DB_Connect$DB)==FALSE){
    enable("launch")
    output$launch_status <- renderText("")
  }else{
    disable("launch")
    if(is.null(DB_Connect$DB)==TRUE){
      output$launch_status <- renderText("You are not yet connected to the data base")
    }else{
      output$launch_status <- renderText("Connected to database")
    }
  })
  
  
  #The first action done when a user launches an analysis
  observeEvent(input$launch,{showModal(modalDialog("Working... you will be notified when the analysis is done"))})
  
  
  #Okay, so this one is complexe, this line of code does several things at once, and this was the only way I found to circumvent a certain error
  #This line starts by holding the message send by the launchMuma function, if the Launch function works well, it will return a string of characters, no issues here
  #If the launch function has an error in it's 'catch', the function returns itself as a variable of type 'closure', I was unable to prevent this
  #This means that the code can't simply show the message return as in some instances the message will not be of character type
  #So the second part of this line of code is to check the type of the 'message' that was returned, if it is of character type, all is well and it can be shown as it is,
  #If it is not of character type, it means there was an error, thus I manually add in the error message that should have been sent by the 'launchMuma' function.
  #This line of code could not be split as the stored 'message' is only present for the duration of this line of code.
  observeEvent(input$launch,{(my_list <-suppressWarnings(DESeq2_pre_processing(input$file1$datapath,input$file2$datapath, 
                                                                               input$condition1,input$condition2,input$Make_MA,input$Make_Volcano)))
    
    
    (showModal(modalDialog(
      if (typeof(my_list[["message"]])!="character"){
        paste("Error, please check the 'Error_and_Warning_Log.txt' located here:",getwd())
      }else{
        my_list[["message"]]
        
      })))
    
    if(typeof(my_list[["message"]])=="character"){
      #shinyjs::show("contents")
    }
    
    
    Final_Results <- Non_canonic_analysis(DB_Connect$DB,my_list[["file"]])
    #Below is the format of 'Final_Results'
    #list("sig_genes"=file_to_analyze,"ncan"=non_canonic_results,"can"=canonic_results,"refs"=ref_results)
    
    
    #Call a function to print the results
    show_results(Final_Results)
    showTab(inputId = "results_tabs", target = "Significant Genes")
    showTab(inputId = "results_tabs", target = "Non_Canonic")
    showTab(inputId = "results_tabs", target = "Canonic")
    showTab(inputId = "results_tabs", target = "References") 
    
  })
  
}