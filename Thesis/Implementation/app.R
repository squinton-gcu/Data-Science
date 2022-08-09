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
plasma_all_stress_cor[,1]<- str_replace_all(plasma_all_stress_cor[,1], "_", ".")
csf_all_stress_graph <- as.data.frame(read.table("csf_all_stress_graph.csv", header=TRUE, sep=","))
csf_all_stress_cor <- as.data.frame(read.table("sort_stress_top_all_csf_cor.csv", header=TRUE, sep=","))
csf_all_stress_cor[,1]<- str_replace_all(csf_all_stress_cor[,1], "-", ".")
csf_all_stress_cor[,1]<- str_replace_all(csf_all_stress_cor[,1], "_", ".")
colnames(csf_all_stress_graph) = str_replace_all(colnames(csf_all_stress_graph), "-", ".")
colnames(plasma_all_stress_graph) = str_replace_all(colnames(plasma_all_stress_graph), "-", ".")

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

first_metab_plasma <- check_numbers(toString(plasma_all_stress_cor[1,1]))
first_metab_plasma_head <- str_replace_all(first_metab_plasma, "-", ".")
second_metab_plasma <- check_numbers(plasma_all_stress_cor[2,1])
second_metab_plasma_head <- str_replace_all(second_metab_plasma, "-", ".")
third_metab_plasma <- check_numbers(plasma_all_stress_cor[3,1])
third_metab_plasma_head <- str_replace_all(third_metab_plasma, "-", ".")

first_metab_csf <- check_numbers(csf_all_stress_cor[1,1])
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
                            tabPanel("Main", fluidRow(
                        column(3,
                         verticalLayout(
                           plotOutput("plot", click= "plot_click"),
                           plotOutput("plot2", click= "plot_click"),
                           plotOutput("plot3", click= "plot_click"))),
                        column(8,
                         dataTableOutput("table1"),
                         plotOutput("heat", click= "plot_click")),
                  
                        column(1,
                         radioButtons("checkbox", "Location of Collection:", c("Plasma" = "Plasma", "CSF" = "CSF"), selected = "CSF"),
                         htmlOutput("text"),
                         dataTableOutput("table2")))),
                        
                        tabPanel("Processing Results", fluidRow(
                          column(3,
                            verticalLayout(
                              textOutput("text1"),
                              imageOutput("ALZPlasmaN1"),
                              imageOutput("ALZPlasmaN2"),
                              imageOutput("ALZPlasmaS1"),
                              imageOutput("ALZPlasmaS2")
                            )),
                          column(3,
                            verticalLayout(
                              textOutput("text2"),
                              imageOutput("ALZCSFN1"),
                              imageOutput("ALZCSFN2"),
                              imageOutput("ALZCSFS1"),
                              plotOutput("ALZCSFS2")
                            )),
                          column(3,
                            verticalLayout(
                              textOutput("text3"),
                              imageOutput("stressHN1"),
                              imageOutput("stressHN2"),
                              imageOutput("stressHS1"),
                              imageOutput("stressHS2")
                            )),
                          column(3,
                            verticalLayout(
                              textOutput("text4"),
                              imageOutput("stressRN1"),
                              imageOutput("stressRN2"),
                              imageOutput("stressRS1"),
                              imageOutput("stressRS2")
                            ))
                        )),
                        tabPanel("Prediction Maps", fluidRow(
                          column(3,
                            verticalLayout(
                              textOutput("text5"),
                              imageOutput("MatrixPlasma1"),
                              imageOutput("MatrixPlasma2"),
                              imageOutput("MatrixPlasma3")
                            )),
                          column(3,
                            verticalLayout(
                              textOutput("text6"),
                              imageOutput("MatrixPlasmaT1")
                            )),
                          column(3,
                            verticalLayout(
                              textOutput("text7"),
                              imageOutput("MatrixCSF1"),
                              imageOutput("MatrixCSF2"),
                              imageOutput("MatrixCSF3")
                            ))
                        )))
                )

)

# Define server logic to plot ---
server <- function(input, output, session) {
  
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
  
  output$ALZPlasmaN1 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/ALZ_plasma _normalized1.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$ALZPlasmaN2 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/ALZ_plasma _normalized2.png", contentType="image/png", width = 400, height = 500)}, deleteFile = F)
  output$ALZPlasmaS1 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/ALZ_plasma _scale1.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$ALZPlasmaS2 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/ALZ_plasma _scale2.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  
  output$ALZCSFN1 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/ALZ_csf _normalized1.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$ALZCSFN1 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/ALZ_csf _normalized2.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$ALZCSFS1 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/ALZ_csf _scale1.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$ALZCSFS2 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/ALZ_csf _scale2.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  
  output$stressHN1 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/trauma_human _normalized1.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$stressHN2 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/trauma_human _normalized2.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$stressHS1 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/trauma_human _scale1.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$stressHS2 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/trauma_human _scale1.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  
  output$stressRN1 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/trauma_rat _normalized1.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$stressRN2 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/trauma_rat _normalized2.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$stressRS1 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/trauma_rat _scale1.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$stressRS2 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/trauma_rat _scale2.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  
  output$MatrixPlasma1 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/Matrix_Plasma_ALL1.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$MatrixPlasma2 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/Matrix_Plasma_ALL2.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$MatrixPlasma3 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/Matrix_Plasma_ALL3.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  
  output$MatrixPlasmaT1 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/Matrix_Plasma_TOP1.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  
  output$MatrixCSF1 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/Matrix_CSF_ALL1.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$MatrixCSF2 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/Matrix_CSF_ALL2.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  output$MatrixCSF3 <- renderImage({list(src = "C:/Users/sophi/OneDrive/Desktop/Graduate Classes/Thesis/docs_Shiny/Matrix_CSF_ALL3.png", contentType="image/png", width = 400, height = 400)}, deleteFile = F)
  
  output$text1 <- renderText({"ALZ Plasma"})
  output$text2 <- renderText({"ALZ CSF"})
  output$text3 <- renderText({ "stress human "})
  output$text4 <- renderText({ "stress rat "})
  
  output$text5 <- renderText( { "ALZ Plasma all "})
  output$text6 <- renderText( {"ALZ Plasma top"})
  output$text7 <- renderText({"ALZ CSF All"})
}

#runGadget(ui, server, viewer = browserViewer(browser = getOption("browser")))

# Run the application 
shinyApp(ui = ui, server = server)
