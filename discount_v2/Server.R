shinyServer(function(input,output){
  #reactive resources
  #------------------
  #dataframe resource
  resource.df<-reactive({
    df_base$PRICE<-df_base[,input$usage]
    
    df<-df_base %>%
      filter(PRICE <= 25,
             PRICE >= 1, #unreaonable data out
             TDU==input$tdu,
             RATE_TYPE %in% input$rate_type,
             PREPAID %in% input$prepaid,
             TOU %in% input$tou,
             PROMOTION %in% input$promotion,
             TERM_LENGTH >= input$term_lengths[1],
             TERM_LENGTH <= input$term_lengths[2],
             RENEWABLE >= input$renewables[1],
             RENEWABLE <= input$renewables[2]) %>%
    mutate(RANK = min_rank(PRICE),
           REP_COLOR = ifelse(
             REP == input$rep1, REP_COLOR_MAP[["REP1"]], ifelse(
               REP == input$rep2, REP_COLOR_MAP[["REP2"]],ifelse(
                 REP == input$rep3, REP_COLOR_MAP[["REP3"]],
                 REP_COLOR_MAP[["OTHER"]])
             )
           )) %>%
    arrange(RANK) #sort by rank
  return(df)
  })
  
  #server output
  #--------------
  #datatable output
  output$datatable <- renderDataTable({
    df <- resource.df() %>%
      select(-c(FACTS_URL,REP_COLOR))
    return(df)
  },options = list(pageLength=10,autowidth=FALSE))
  
  #download output
  output$download_data <- downloadHandler(
    filename = function(){
      sprintf("ptc_data_%s.csv",Sys.Date())
    },
    content = function(filename){
      df<-resource.df()
      write.csv(df,file=filename,row.names = FALSE)
    }
  )
  #summary output
  output$rankingSummary <- renderUI({
    df<-resource.df()
    #
    df_best<-df %>% filter(RANK==1)
    df_top10<-df %>% filter(RANK<=10)
    df_top30<-df %>% filter(RANK<=30)
    summary<-HTML(
      # sprintf("
      #         <b>BEST:</b> %sc/kWh <small><i>(%s)</i></small><br />
      #         <b>Top10:</b> %sc/kWh<br />
      #         <b>Top30:</b> %sc/kWh<br />
      #         <b>Mean:</b> %sc/kWh <small><i>(%s products)</i></small><br /><br />
      #         <b>Top 10 REPS:</b> <small>%s</small><br />",
      #         min(df_best$PRICE),paste(df_best$PRODUCT,collapse = ","),
      #         max(df_top10$PRICE),
      #         max(df_top30$PRICE),
      #         round(mean(df$PRICE),1), nrow(df %>% filter(PRICE<mean(PRICE))),
      #         paste(df_top10$REP,collapse = ","))
    #   sprintf("<b><i><font size=3><div style=letter-spacing:1px>阶梯：</div></font></i></b>
    #           <b><i><font size=3>折扣：</font></i></b>
    #           
    #           <table width=600 align=center>
    #           
    #           <tr>
    #           <td>0~10W</td>
    #           <td>9.5折</td>
    #           </tr>
    #           <tr>
    #           <td>10~20W</td>
    #           <td>9折</td>
    #           </tr>
    #           <tr>
    #           <td>20w~</td>
    #           <td>8折</td>
    #           </tr>
    #           </table>")
    # 
    # )
    sprintf("<table align=center>
            <tr>
            <td><b>阶梯</b></td>
            <td><b>折扣</b></td>
            </tr>
            </table>
            <hr/>
            <table align=center width=600>
            <tr>
            <td>0~10W</td>
            <td>0.05</td>
            </tr>
            <tr>
            <td>10~20W</td>
            <td>0.1</td>
            </tr>
            <tr>
            <td>20w~</td>
            <td>0.2</td>
            </tr>
            </table>")
    
    )
    return(summary)
  })
  
  
  #ggvis output
  #-------------
  #tooltip helper
  tooltip_helper<-function(data){
    df=resource.df()
    sprintf("<b class='text-warning'><i>%s</i></b><br /> #color emphasize 
            <b>REP:</b> %s<br />
            <b>RANK:</b> #%s<br />
            <b>PRICE:</b> %sc/kWh<br />
            <b>TERM:</b> %sM<br />
            <b>PROMOTION</b> %s<br />",
            df$PRODUCT[df$ID==data$ID],
            df$REP[df$ID==data$ID],
            df$RANK[df$ID==data$ID],
            df$PRICE[df$ID==data$ID],
            df$TERM_LENGTH[df$ID==data$ID],
            df$PROMOTION[df$ID==data$ID])
  }
  
  #rankings plot ggvis output
  # resource.df %>%
  # ggvis(x=~PRICE,y=~REP,size=~TERM_LENGTH,
  #       fill:=~REP_COLOR,stroke="lightsteelblue",key:=~ID) %>%
  #   layer_points() %>%
  #   add_axis("x",subdivide = 4) %>%
  #   add_axis("y",title = "") %>%
  #   hide_legend("stroke") %>%
  #   add_tooltip(tooltip_helper,"hover") %>%
  #   bind_shiny("rankings_plot")
  
  # rankings_plot ggvis output
  resource.df %>% 
    ggvis(x=~PRICE, y=~REP, size=~TERM_LENGTH, fill:=~REP_COLOR, stroke="lightsteelblue", key:=~ID) %>% 
    layer_points() %>%
    add_axis("x", subdivide=4) %>%
    add_axis("y", title="") %>%
    hide_legend("stroke") %>%
    add_tooltip(tooltip_helper, "hover") %>%
    bind_shiny("rankings_plot")
  
  #market_histogram ggvis output
  resource.df %>%
    ggvis(x=~PRICE, fill:=~REP_COLOR,stroke="lightsteelblue") %>%
    group_by(REP_COLOR) %>%
    layer_histograms(width = input_slider(label = "Binwidth",min = 0.1,max = 0.2,value = 0.2,step = 0.1)) %>%
    add_axis("x",subdivide = 4) %>%
    hide_legend("stroke") %>%
    add_tooltip(histogram_tootip,"hover") %>%
    #add_tooltip(histogram_tooltip,"hover") %>%
    bind_shiny("market_histogram","market_histogram_slider")
  
  #market_scatterplot ggvis output
  resource.df %>% 
    ggvis(x=~PRICE, y=~TERM_LENGTH, size:=50, fill:=~REP_COLOR, stroke="lightsteelblue", key:=~ID) %>% 
    layer_points() %>% 
    add_axis("x", subdivide=4) %>%
    hide_legend("stroke") %>%
    add_tooltip(tooltip_helper, "hover") %>%
    bind_shiny("market_scatterplot")
})