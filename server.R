library(shiny)
library(datasets)
library(survival)
library(ggplot2)
library(survminer)
library(GGally)
library(glmnet)
options(shiny.maxRequestSize = 70 * 1024 ^ 2)
load_obj <- function(f)
{
  env <- new.env()
  nm <- load(f, env)[1]
  env[[nm]]
}
shinyServer(function(input, output, session) {
  
  
  data <- reactive({
    req(input$file1)
    df<-load_obj(input$file1$datapath)
    
    # Update inputs (you could create an observer with both updateSel...)
    # You can also constraint your choices. If you wanted select only numeric
    # variables you could set "choices = sapply(df, is.numeric)"
    # It depends on what do you want to do later on.
    
    updateSelectInput(
      session,
      inputId = 'row',
      label = 'Row',
      choices = 1:nrow(df),
      selected = 1
    )
    updateSelectInput(
      session,
      inputId = 'col',
      label = 'Column',
      choices = names(sapply(df, is.numeric)),
      selected = names(df)[2]
    )
    updateSelectInput(
      session,
      inputId = 'col1',
      label = 'Column1',
      choices = names(sapply(df, is.numeric)),
      selected = names(df)[4]
    )
    updateSelectInput(
      session,
      inputId = 'col2',
      label = 'Column2',
      choices = names(sapply(df, is.numeric)),
      selected = names(df)[5]
    )
    updateSelectInput(
      session,
      inputId = 'col3',
      label = 'Cox Variable',
      choices = names(sapply(df, is.numeric)),
      selected = names(df)[5]
    )
    updateSelectInput(
      session,
      inputId = 'col4',
      label = 'AFT Variable',
      choices = names(sapply(df, is.numeric)),
      selected = names(df)[5]
    )
    return(df)
  })
  
  output$contents <- renderTable({
    df<-data()
    return (head(df[,1:10]))
  })
  
  output$row_summary <- renderPrint({
    df<-data()
    row<-as.numeric(df[input$row, 2:ncol(df)])
    summary(row)
  })
  
  output$col_summary <- renderPrint({
    df<-data()
    column<-df[,input$col]
    summary(column)
  })
  
  
  output$surPlot <- renderPlot({
    
    plot.survival <- function(data)
    {
      ggsurv(survfit(
        Surv(data$OS, data$status) ~ 1,
        type = "kaplan-meier",
        conf.type = "log-log"
      ),
      main = "Survival Plot(K-M estimate)")
     
    }
    
    print(plot.survival(data()))
    
  })
  
  output$scaPlot <- renderPlot({
    df<-data()
    column1<-df[,input$col1]
    column2<-df[,input$col2]
    plot(column1, column2)
  })
  
  output$reg_summary <-renderPrint({
   df=data()
   column3=df[,input$col3]
   
   res.cox=coxph(Surv(df$OS,df$status) ~ column3, data=df)
   summary(res.cox)
  })
  
  output$reg_Plot <- renderPlot({
    df=data()
    column3=df[,input$col3]
    res.cox=coxph(Surv(df$OS,df$status) ~ column3, data=df)
    ggsurvplot(survfit(res.cox), palette = "#2E9FDF",ggtheme = theme_minimal(),data = df)
  })

  output$aft_summary <-renderPrint({
    df=data()
    column4=df[,input$col4]
    res.aft=survreg(Surv(df$OS,df$status) ~ column4, data=df, dist="lognormal")
    summary(res.aft)
  })
  
  output$GlmnetPlot <- renderPlot({
    df=data()
    y1=cbind(time=df$OS,status=df$statu)
    x1 <- subset(df, select = -c(bcr,OS, status))
    x1=data.matrix(x1, rownames.force = NA)
    fit1=glmnet(x1,y1,family="cox")
    plot(fit1)
  })
  
#  output$aft_Plot <- renderPlot({
#    df=data()
#    df=df[-c(which(df$OS==0)),]
#    column4=df[,input$col4]
#    res.aft=survreg(Surv(df$OS,df$status) ~ column4, data=df, dist="lognormal")
#    ggsurvplot(survfit(res.aft), color = "#2E9FDF",ggtheme = theme_minimal(),data = df)
#  })
  
})
