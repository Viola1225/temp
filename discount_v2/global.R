#load libraries
library(shiny)
library(dplyr)
library(ggvis)
source("datascrape.R",encoding = "utf-8")
#source("D:\\user1\\01378037\\docum\\GitHub\\elecprice\\datascrape.R",encoding = "utf-8")

#get base-df
df_base<-get_df()

#ui.R vars
choices<-list(tdus=unique(df_base$TDU),
              reps=unique(df_base$REP),
              rate_types=unique(df_base$RATE_TYPE),
              prepaid=unique(df_base$PREPAID),
              tou=unique(df_base$TOU),
              promotion=unique(df_base$PROMOTION),
              booleans=c(TRUE,FALSE),
              usage=c("重货","others","时效","冷运","国际件","电商","特惠")
)

# function(input, output) {
#   
#   # You can access the values of the widget (as a vector)
#   # with input$radio, e.g.
#   output$value <- renderPrint({ input$radio })
#   
# }

#added
function(input, output) {
  
  # You can access the value of the widget with input$action, e.g.
  output$value <- renderPrint({ input$action })
  
}

function(input, output) {
  
  # You can access the values of the widget (as a vector of Dates)
  # with input$dates, e.g.
  output$value <- renderPrint({ input$dates })
  
}

#server.R vars & functions
#------------------------
#histogram_tooltip helper function
histogram_tootip=function(data){
  if(is.null(data)) return(NULL)
  sprintf("price: %s - %s c/kwh<br />
          Count: %s<br />",
          round(data$xmin,1), round(data$xmax,1),
          data$stack_upr - data$stack_lwr)
}

#color map 
REP_COLOR_MAP<-c(
  "REP1" = "#1f77b4",
  "REP2" = "#ff7f0e",
  "REP3" = "#2ca02c",
  "OTHER" = "#dddddd"
)
  
