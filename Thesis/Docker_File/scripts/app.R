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

plasma_all_stress_graph <- as.data.frame(read.table("plasma_all_stress_graph.csv", header=TRUE, sep=","))
plasma_all_stress_pred <- as.data.frame(read.table("stress_top_plasma_all_pred.csv", header=TRUE, sep=","))
csf_all_stress_graph <- as.data.frame(read.table("csf_all_stress_graph.csv", header=TRUE, sep=","))
csf_all_stress_pred <- as.data.frame(read.table("stress_top_csf_all_pred.csv", header=TRUE, sep=","))
colnames(csf_all_stress_graph) = str_replace_all(colnames(csf_all_stress_graph), "-", ".")
colnames(plasma_all_stress_graph) = str_replace_all(colnames(plasma_all_stress_graph), "-", ".")

test2<- melt(plasma_all_stress_graph)
test2[,1]<- str_replace_all(test2[,1], "Cognitive.Status.", "")
colnames(test2) <- c("x", "y", "value")

test1<- melt(csf_all_stress_graph)
test1[,1]<- str_replace_all(test1[,1], "Cognitive.Status.", "")
colnames(test1) <- c("x", "y", "value")


# Define UI  ----
ui <- fluidPage(headerPanel("The Investigation of Alzheimer's disease and Stress with Metabolomics Data"),
                fluidRow(
                  column(4,
                         verticalLayout(
                           plotOutput("plot", click= "plot_click"),
                           plotOutput("plot2", click= "plot_click"),
                           plotOutput("plot3", click= "plot_click"))),
                  column(5,
                         dataTableOutput("table1"),
                         plotOutput("heat", click= "plot_click")),
                  
                  column(3,
                         radioButtons("checkbox", "Location of Collection:", c("Plasma" = "Plasma", "CSF" = "CSF"), selected = "CSF"),
                         htmlOutput("text")))
                #ActionLink("pathways", "dimethyglycine", onclick ="location.href='https://metacyc.org/META/NEW-IMAGE?object=PWY-6004';"),
                #ActionLink("pathways2", "homoserine", onclick ="location.href='https://metacyc.org/META/NEW-IMAGE?object=HOMOSER-THRESYN-PWY';")
)

# Define server logic to plot ---
server <- function(input, output, session) {
  
  output$plot <- renderPlot({
    if(input$checkbox == "Plasma"){
      sample = plasma_all_stress_graph
      name = "Propionylglycinemethylester"
    }
    else if(input$checkbox == "CSF"){
      sample = csf_all_stress_graph
      name = "L.4.Hydroxy.3.methoxy.a.methylphenylalanine"
    }
    ggplot(sample, aes_string(x=name, y="y")) + geom_point(size=2, shape=23) +
      geom_smooth(method="glm", se=FALSE, method.args = list(family = "binomial")) + ggtitle(paste0(name, " and ALZ")) +
      xlab(paste0("Expression of ", name)) + ylab("ALZ")}
  )
  output$plot2 <- renderPlot({
    if(input$checkbox == "Plasma"){
      sample = plasma_all_stress_graph
      name = "Propionylglycine.methyl.ester"
    }
    else if(input$checkbox == "CSF"){
      sample = csf_all_stress_graph
      name = "D.Homoserine"
    }
    ggplot(sample, aes_string(x=name, y="y")) + geom_point(size=2, shape=23) +
      geom_smooth(method="glm", se=FALSE, method.args = list(family = "binomial")) + ggtitle(paste0(name, " and ALZ")) +
      xlab(paste0("Expression of ", name)) + ylab("ALZ")}
  )
  output$plot3 <- renderPlot({
    if(input$checkbox == "Plasma"){
      sample = plasma_all_stress_graph
      name = "Capryloylglycine"
    }
    else if(input$checkbox == "CSF"){
      sample = csf_all_stress_graph
      name = "Glutarylglycine"
    }
    ggplot(sample, aes_string(x=name, y="y")) + geom_point(size=2, shape=23) +
      geom_smooth(method="glm", se=FALSE, method.args = list(family = "binomial")) + ggtitle(paste0(name, " and ALZ")) +
      xlab(paste0("Expression of ", name)) + ylab("ALZ")}
  )
  
  output$table1 <- renderDataTable({
    if(input$checkbox == "Plasma"){
      plasma_all_stress_pred
    } else{
      csf_all_stress_pred
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
                           high = "#FF0000")  + coord_fixed() + 
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
}

#runGadget(ui, server, viewer = browserViewer(browser = getOption("browser")))

# Run the application 
shinyApp(ui = ui, server = server)
