#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(ggplot2)
library(reshape)
library(stringr)

setwd("C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny")
plasma_all_stress_graph <- as.data.frame(read.table("plasma_all_stress_graph.csv", header=TRUE, sep=","))
plasma_all_stress_cor <- as.data.frame(read.table("sort_stress_top_all_plasma_cor.csv", header=TRUE, sep=","))
plasma_all_stress_cor[,1]<- str_replace_all(plasma_all_stress_cor[,1], "-", ".")
plasma_all_stress_cor[,1]<- str_replace_all(plasma_all_stress_cor[,1], ",", ".")
plasma_all_stress_cor[,1]<- str_replace_all(plasma_all_stress_cor[,1], " ", ".")
plasma_all_stress_cor[,1]<- gsub("[+]", ".",plasma_all_stress_cor[,1])
plasma_all_stress_cor[,1]<- gsub("[()]", ".",plasma_all_stress_cor[,1])
plasma_all_stress_cor[,1]<- gsub("[[]]", ".",plasma_all_stress_cor[,1])
plasma_all_stress_cor[,1]<- gsub("\\[|\\]", ".",plasma_all_stress_cor[,1])
csf_all_stress_graph <- as.data.frame(read.table("csf_all_stress_graph.csv", header=TRUE, sep=","))
csf_all_stress_cor <- as.data.frame(read.table("sort_stress_top_all_csf_cor.csv", header=TRUE, sep=","))
csf_all_stress_cor[,1]<- str_replace_all(csf_all_stress_cor[,1], "-", ".")
csf_all_stress_cor[,1]<- str_replace_all(csf_all_stress_cor[,1], ",", ".")
csf_all_stress_cor[,1]<- str_replace_all(csf_all_stress_cor[,1], " ", ".")
csf_all_stress_cor[,1]<- gsub("[()]", ".",csf_all_stress_cor[,1])
csf_all_stress_cor[,1]<- gsub("[+]", ".",csf_all_stress_cor[,1])
csf_all_stress_cor[,1]<- gsub("[[]]", ".",csf_all_stress_cor[,1])
csf_all_stress_cor[,1]<- gsub("\\[|\\]", ".",csf_all_stress_cor[,1])
colnames(csf_all_stress_graph) = str_replace_all(colnames(csf_all_stress_graph), "-", ".")
colnames(csf_all_stress_graph) = str_replace_all(colnames(csf_all_stress_graph), ",", ".")
colnames(csf_all_stress_graph) = str_replace_all(colnames(csf_all_stress_graph), " ", ".")
colnames(csf_all_stress_graph) = gsub("[()]", ".",colnames(csf_all_stress_graph))
colnames(csf_all_stress_graph) = gsub("[+]", ".",colnames(csf_all_stress_graph))
colnames(csf_all_stress_graph) = gsub("[[]]", ".",colnames(csf_all_stress_graph))
colnames(csf_all_stress_graph) =  gsub("\\[|\\]", ".",colnames(csf_all_stress_graph))
colnames(plasma_all_stress_graph) = str_replace_all(colnames(plasma_all_stress_graph), "-", ".")
colnames(plasma_all_stress_graph) = str_replace_all(colnames(plasma_all_stress_graph), ",", ".")
colnames(plasma_all_stress_graph) = str_replace_all(colnames(plasma_all_stress_graph), " ", ".")
colnames(plasma_all_stress_graph) = gsub("[()]", ".",colnames(plasma_all_stress_graph))
colnames(plasma_all_stress_graph) = gsub("[+]", ".",colnames(plasma_all_stress_graph))
colnames(plasma_all_stress_graph) = gsub("[[]]", ".",colnames(plasma_all_stress_graph))
colnames(plasma_all_stress_graph) = gsub("\\[|\\]", ".",colnames(plasma_all_stress_graph))

#load other data files
ALZPProcessed <- read.table("ALZ_plasma_processed.csv", header=TRUE, sep=",")
ALZCProcessed <- read.table("ALZ_csf_processed.csv", header=TRUE, sep=",")
TraumaHProcessed <- read.table("trauma_human_processed.csv", header=TRUE, sep=",")
TraumaRProcessed <- read.table("trauma_rat_processed.csv", header=TRUE, sep=",")

ALZPTP <- read.table("ALZ_plasma_tp-scores.csv", header=TRUE, sep=",")
ALZCTP <- read.table("ALZ_csf_tp-scores.csv", header=TRUE, sep=",")
THTP <- read.table("trauma_human_tp-scores.csv", header=TRUE, sep=",")
TRTP <- read.table("trauma_rat_tp-scores.csv", header=TRUE, sep=",")

TSAP <- read.table("sort_stress_top_all_plasma_cor.csv", header=TRUE, sep=",")
TSTP <- read.table("sort_stress_top_top_plasma_cor.csv", header=TRUE, sep=",")
TSAC <- read.table("sort_stress_top_all_csf_cor.csv", header=TRUE, sep=",")
TSTC <- read.table("sort_stress_top_top_csf_cor.csv", header=TRUE, sep=",")

TSAPP <- read.table("stress_top_plasma_all_pred.csv", header=TRUE, sep=",")
metabolite1<- TSAPP[1,1]
metabolite2<- TSAPP[2,1]
metabolite3<- TSAPP[3,1]
TSTPP <- read.table("stress_top_plasma_top_pred.csv", header=TRUE, sep=",")
metabolite4<- TSTPP[1,1]
TSCAP <- read.table("stress_top_csf_all_pred.csv", header=TRUE, sep=",")
metabolite5<- TSCAP[1,1]
metabolite6<- TSCAP[2,1]
metabolite7<- TSCAP[3,1]
TSTCP <- read.table("stress_top_csf_top_pred.csv", header=TRUE, sep=",")

plasma_all_stress_pred <- as.data.frame(read.table("stress_top_plasma_all_pred.csv", header=TRUE, sep=","))
csf_all_stress_pred<- as.data.frame(read.table("stress_top_csf_all_pred.csv", header=TRUE, sep=","))

check_numbers <- function(list_name) {
  
  for (x in 1:10) {
    if (startsWith(list_name, toString(x))) {
      new_name <- paste0("X", list_name)
      return(new_name)
    }
  }
  return(list_name)
}

first_metab_plasma <- check_numbers(toString(plasma_all_stress_cor[10,1]))
first_metab_plasma_head <- str_replace_all(first_metab_plasma, "-", ".")
second_metab_plasma <- check_numbers(plasma_all_stress_cor[2,1])
second_metab_plasma_head <- str_replace_all(second_metab_plasma, "-", ".")
third_metab_plasma <- check_numbers(plasma_all_stress_cor[3,1])
third_metab_plasma_head <- str_replace_all(third_metab_plasma, "-", ".")

first_metab_csf <- check_numbers(csf_all_stress_cor[6,1])
first_metab_csf_head <- str_replace_all(first_metab_csf, "-", ".")
second_metab_csf <- check_numbers(csf_all_stress_cor[2,1])
second_metab_csf_head <- str_replace_all(second_metab_csf, "-", ".")
third_metab_csf <- check_numbers(csf_all_stress_cor[3,1])
third_metab_csf_head <- str_replace_all(third_metab_csf, "-", ".")

test2<- melt(plasma_all_stress_graph)
test2[,1]<- str_replace_all(test2[,1], "Cognitive.Status.", "")
colnames(test2) <- c("x", "y", "value")

test1<- melt(csf_all_stress_graph)
test1[,1]<- str_replace_all(test1[,1], "Cognitive.Status.", "")
colnames(test1) <- c("x", "y", "value")


# Define UI  ----
ui <- mainPanel(titlePanel("The Investigation of Alzheimer's disease and Stress with Metabolomics Data"),fluidPage(
  tabsetPanel(type = "tabs",
              tabPanel("Introduction", fluidRow(
                column(12,
                       verticalLayout(
                         htmlOutput("intro1"),
                         htmlOutput("intro2"),
                         htmlOutput("intro3"),
                         htmlOutput("intro4")
                       ))
              )),
              tabPanel("Main", fluidRow(
                column(3,
                       verticalLayout(
                         htmlOutput("label1"),
                         plotOutput("plot", click= "plot_click"),
                         plotOutput("plot2", click= "plot_click"),
                         plotOutput("plot3", click= "plot_click"))),
                column(6,
                       htmlOutput("label2"),
                       dataTableOutput("table1"),
                       htmlOutput("label3"),
                       plotOutput("heat", click= "plot_click")),
                
                column(3,
                       radioButtons("checkbox", "Location of Collection:", c("Plasma" = "Plasma", "CSF" = "CSF"), selected = "CSF"),
                       htmlOutput("text"),
                       htmlOutput("label4"),
                       dataTableOutput("table2")))),
              
              tabPanel("Prediction Maps", fluidRow(
                column(3,
                       verticalLayout(
                         htmlOutput("text5"),
                         textOutput("met1"),
                         imageOutput("MatrixPlasma1"),
                         textOutput("met2"),
                         imageOutput("MatrixPlasma2"),
                         textOutput("met3"),
                         imageOutput("MatrixPlasma3")
                       )),
                column(3,
                       verticalLayout(
                         htmlOutput("text6"),
                         textOutput("met4"),
                         imageOutput("MatrixPlasmaT1")
                       )),
                column(3,
                       verticalLayout(
                         htmlOutput("text7"),
                         textOutput("met5"),
                         imageOutput("MatrixCSF1"),
                         textOutput("met6"),
                         imageOutput("MatrixCSF2"), 
                         textOutput("met7"),
                         imageOutput("MatrixCSF3")
                       ))
              )),
              tabPanel("Download Data", titlePanel("Download Data"),
                       sidebarPanel(
                         selectInput("dataset", "Choose a dataset:", choices = c("ALZPlasmaProcessed", "ALZCSFProcessed", "TraumaHumanProcessed", "TraumaRatProcessed",
                                                                                 "ALZPlasmaTvaluePvalue", "ALZCSFTvaluePvalue", "TraumaHumanTvaluePvalue", "TraumaRatTvaluePvalue",
                                                                                 "TopStressAllPlasma", "TopStressTopPlasma", "TopStressAllCSF", "TopStressTopCSF",
                                                                                 "TopStressAllPlasmaPredictions", "TopStressTopPlasmaPredictions", "TopStressAllCSFPredictions", "TopStressTopCSFPredictions")),
                         downloadButton("downloadData", "Download")
                       ),
                       mainPanel(
                         tableOutput("tableTest"))
              )
  )
  
  
)
)


# Define server logic to plot ---
server <- function(input, output, session) {
  
  output$intro1 <- renderText({
    paste("<b>Correlation Graphs: </b>Correlation graphs take the highest p-value metabolites from the correlation module. The top three will change based on which
    metabolite was selected. The correlation is a logistic regression. The x-axis represents the expression of the metabolite. The y-axis is Alzheimer's disease.
    Zero is no Alzheimer's disease and one is Alzheimer's disease. This represents the success of the correlation module.<br><br>")
  })
  output$intro2 <- renderText({
    paste("<b>Heatmap: </b>The heatmap represents the results of the feature selection module. The X-axis represents each metabolite that is selected from the feature selection 
    module. The y-axis represents the samples. AD represents Alzheimer's disease and MCI(Mild Cognitive Impairment) and CN(Clinically Normal) represent no Alzheimer's disease. These graphs do not reveal detailed
    information.<br><br>")
  })
  output$intro3 <- renderText({
    paste("<b>Tables: </b>Two tables are used in this study. The top middle table of the Main tab represents the correlation metrics of the given collection site. The right bottom
    table represents the metrics from the prediction module.<br><br>")
  })
  
  output$intro4 <- renderText({
    paste("<b>Prediction graphs: </b>These are confusion matrices represented as a plot that show the success of the predictions. The top left of the confusion matrix graph represents true negative predictions.
    The bottom left represents false positives. The top right represents false negatives. The bottom right represents true positives. The numerical representation of this visual
    representation can be seen in the metrics table of the Main tab. One represents Alzheimer's disease and zero represent no Alzheimer's disease. If a value is one, and is predicted
    to be one, it will fall in the bottom right corner. If a sample is one but is predicted to be zero, then it falls in the bottom left corner. The first column of graphs is from the 
    three most predicted metabolites where the selected stress and all Alzheimer's disease are compared. The second column is only one graph because only one metabolite is represented in the 
    group. It represents the top metabolite that is comparative in the selected plasma Alzheimer's disease and the selected stress metabolites. The third column represents the comparative 
    analysis between the selected stress metabolites and all CSF Alzheimer metabolites.<br><br>")
  })
  
  output$label1 <- renderText({paste("<b>Correlation Plots: 0 is no ALZ and 1 is ALZ<br>")})
  output$label2 <- renderText({paste("<b>Corellation Metrics Table<br>")})
  output$label3 <- renderText({paste("<b>Feature Selection Heatmap: Y-axis is disease or no disease, X-axis is metabolites<br>")})
  output$label4 <- renderText({paste("<b>Predictive analysis metrics Table<br>")})
  
  output$plot <- renderPlot({
    if(input$checkbox == "Plasma"){
      sample = plasma_all_stress_graph
      name = first_metab_plasma_head
      header = first_metab_plasma_head
    }
    else if(input$checkbox == "CSF"){
      sample = csf_all_stress_graph
      name = first_metab_csf_head
      header = first_metab_csf_head
    }
    ggplot(sample, aes_string(x=name, y="y")) + geom_point(size=2, shape=23) +
      geom_smooth(method="glm", se=FALSE, method.args = list(family = "binomial")) + ggtitle(paste0(header, " and ALZ")) +
      xlab(paste0("Expression of ", header)) + ylab("ALZ")}
  )
  output$plot2 <- renderPlot({
    if(input$checkbox == "Plasma"){
      sample = plasma_all_stress_graph
      name = second_metab_plasma_head
      header = second_metab_plasma_head
    }
    else if(input$checkbox == "CSF"){
      sample = csf_all_stress_graph
      name = second_metab_csf_head
      header = second_metab_csf_head
    }
    ggplot(sample, aes_string(x=name, y="y")) + geom_point(size=2, shape=23) +
      geom_smooth(method="glm", se=FALSE, method.args = list(family = "binomial")) + ggtitle(paste0(header, " and ALZ")) +
      xlab(paste0("Expression of ", header)) + ylab("ALZ")}
  )
  output$plot3 <- renderPlot({
    if(input$checkbox == "Plasma"){
      sample = plasma_all_stress_graph
      name = third_metab_plasma_head
      header = third_metab_plasma_head
    }
    else if(input$checkbox == "CSF"){
      sample = csf_all_stress_graph
      name = third_metab_csf_head
      header = third_metab_csf_head
    }
    ggplot(sample, aes_string(x=name, y="y")) + geom_point(size=2, shape=23) +
      geom_smooth(method="glm", se=FALSE, method.args = list(family = "binomial")) + ggtitle(paste0(header, " and ALZ")) +
      xlab(paste0("Expression of ", header)) + ylab("ALZ")}
  )
  
  output$table1 <- renderDataTable({
    if(input$checkbox == "Plasma"){
      plasma_all_stress_cor
    } else{
      csf_all_stress_cor
    } }, options = list(pageLength = 5))
  
  output$heat <- renderPlot({
    if(input$checkbox == "Plasma"){
      sample = test2
    }
    else if(input$checkbox == "CSF"){
      sample = test1
    }
    ggplot(sample, aes(x = y, y=x, fill = value)) + geom_tile(color="black") + 
      scale_fill_gradient2(low = "#075AFF",
                           mid = "#FFFFCC",
                           high = "#FF0000", limits=c(-30,30))  + coord_fixed() + 
      theme(axis.text.x = element_text(angle=90, size=9))},
    width=500, height=1000)
  
  output$text <- renderUI({
    if(input$checkbox == "CSF"){
      tags$h1("Pathways, click to see metabolic patways")
      HTML("<p> Pathway 1: <a href='https://metacyc.org/META/NEW-IMAGE?object=PWY0-781'>L-homoserine</a></p> Pathway 2: <a href='https://metacyc.org/META/NEW-IMAGE?object=PWY-5048'>L-phenylalanine</a></p>")
    }
    else if(input$checkbox == "Plasma"){
      tags$h1("Pathways, click to see metabolic patways")
      HTML("<p> Pathway 1: <a href='https://metacyc.org/META/NEW-IMAGE?object=PWY-6004'>dimethyglycine</a></p> Pathway 2: <a href='https://metacyc.org/META/NEW-IMAGE?object=HOMOSER-THRESYN-PWY'>D-homoserine</a></p>")
      
    }})
  output$table2 <- renderDataTable({
    if(input$checkbox == "Plasma"){
      plasma_all_stress_pred
    } else{
      csf_all_stress_pred
    } }, options = list(pageLength = 5))
  
  setwd("C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/")

  output$MatrixPlasma1 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/Matrix_Plasma_ALL1.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$MatrixPlasma2 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/Matrix_Plasma_ALL2.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$MatrixPlasma3 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/Matrix_Plasma_ALL3.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  
  output$MatrixPlasmaT1 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/Matrix_Plasma_TOP1.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  
  output$MatrixCSF1 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/Matrix_CSF_ALL1.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$MatrixCSF2 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/Matrix_CSF_ALL2.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$MatrixCSF3 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/Matrix_CSF_ALL3.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  
  output$text5 <- renderText( {paste("<b>ALZ Plasma all<br>")})
  output$text6 <- renderText( {paste("<b>ALZ Plasma top<br>")})
  output$text7 <- renderText({paste("<b>ALZ CSF All<br>")})
  
  output$met1 <- renderText({metabolite1})
  output$met2 <- renderText({metabolite2})
  output$met3 <- renderText({metabolite3})
  output$met4 <- renderText({metabolite4})
  output$met5 <- renderText({metabolite5})
  output$met6 <- renderText({metabolite6})
  output$met7 <- renderText({metabolite7})
  
  datasetInput <- reactive({
    switch(input$dataset,
           "ALZPlasmaProcessed" = ALZPProcessed,
           "ALZCSFProcessed" =ALZCProcessed,
           "TraumaHumanProcessed" =TraumaHProcessed,
           "TraumaRatProcessed" =TraumaRProcessed,
           
           "ALZPlasmaTvaluePvalue" =ALZPTP,
           "ALZCSFTvaluePvalue" =ALZCTP,
           "TraumaHumanTvaluePvalue" =THTP,
           "TraumaRatTvaluePvalue" =TRTP,
           "TopStressAllPlasma" =TSAP,
           "TopStressTopPlasma" =TSTP,
           "TopStressAllCSF" =TSAC,
           "TopStressTopCSF" =TSTC,
           "TopStressAllPlasmaPredictions" = TSAPP,
           "TopStressTopPlasmaPredictions" =TSTPP,
           "TopStressAllCSFPredictions" =TSCAP,
           "TopStressTopCSFPredictions" =TSTCP
          )
  })
  
  output$tableTest <- renderTable({
    datasetInput()
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, ".csv", sep="")
    },
    content = function(file) {
      write.csv(datasetInput(), file, row.names = FALSE)
    
    })
}

#runGadget(ui, server, viewer = browserViewer(browser = getOption("browser")))

# Run the application 
shinyApp(ui = ui, server = server)
