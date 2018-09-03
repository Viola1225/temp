shinyUI(fluidPage(
  tags$head(tags$link(rel="stylesheet",type="text/css",href="app.css")),
  
  titlePanel("阶梯折扣生成系统"),
  
  sidebarLayout(
    sidebarPanel(
      p(class="text-small",
        a(href="http://1-------------", target="_blank","by BAS"),
        a(href="https://github.com/Viola1225", target="_blank",icon("github"))," | "
        ),
      hr(),
      p(class="text-small","请选择客户属性及期望折扣类型: "),
      hr(),
      
      selectInput(inputId="tdu",label = "客户所属行业: ",choices = choices$tdus,selected = choices$tdus[[1]]),
      selectInput(inputId="usage",label = "建议产品类型: ",choices = choices$usage,selected = choices$usage[[2]]),
      checkboxGroupInput(inputId="rate_type",label="是否有淡旺季:",choices = choices$rate_types,selected = choices$rate_types[[1]]),
      #radioButtons(inputId="rate_types", label="是否有淡旺季:", choices=choices$rate_types),
      hr(),
      
     
      selectInput(inputId="rep1", label="暂定 1:", choices=choices$reps, selected=choices$reps[[1]]),
      selectInput(inputId="rep2", label="暂定 2:", choices=choices$reps, selected=choices$reps[[2]]),
      selectInput(inputId="rep3", label="暂定 3:", choices=choices$reps, selected=choices$reps[[3]]),
      p(class="text-small", "(暂定: 等待最终分类变量确定)"),
      hr(),
      
      # radioButtons("radio", label = "是否为新客户",
      #              choices = list("是" = 1, "否" = 2), 
      #              selected = 1), 
      
      radioButtons(inputId="prepaid", label="是否为新客户:", choices=choices$prepaid),
      radioButtons(inputId="tou", label="是否特殊通道:", choices=choices$tou),
      radioButtons(inputId="promotion", label="是否月结:", choices=choices$promotion),
      # checkboxGroupInput(inputId="prepaid", label="是否为新客户:", choices=choices$booleans, selected=choices$booleans),
      # checkboxGroupInput(inputId="tou", label="是否特殊通道:", choices=choices$booleans, selected=choices$booleans),
      # checkboxGroupInput(inputId="promotion", label="是否月结:", choices=choices$booleans, selected=choices$booleans),
      sliderInput(inputId="term_lengths", label="签约时长:", min=0, max=12, value=c(0, 12)),
      sliderInput(inputId="renewables", label="预估门槛:", min=0, max=200, value=c(0, 100)),
      hr(),
      
      numericInput("num", label = "建议折扣阶数：", value = 3, min = 1, max = 10),
      hr(),
      
      dateRangeInput("dates", label = "参考折扣历史"),
      hr(),
      
      actionButton("action", label = "提交"),
    
      
      # downloadButton(outputId = "download_data", label="Download Data"),
      width=3
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("阶梯折扣生成",
                  h3("折扣方案："),
                  p(class="text-small", "根据左侧选择的客户特征及要求生成的阶梯折扣方案如下， 
                    该方案基于过去同类型客户签约折扣的历史数据生成："),
                  hr(),
                  
                  h3("方案描述"),
                  htmlOutput("rankingSummary"),
                  hr(),
                  
                  h3("Rankings Plot"),
                  p(class="text-small","Rankings of products at a given price range and associated variables. "),
                  ggvisOutput("rankings_plot"),
                  hr()
        ),
        tabPanel("历史纪录",
                 h3("同类客户历史签约折扣情况："),
                 p(class="text-small", "根据左侧选择的客户特征，相似客户在（2016年1月~2018年7月）
                   的折扣方案最小值，最大值，中位数如下："),
                 hr(),
                 p(class="text-small", "若该客户为老客户，其在（2016年1月~2018年7月）
                   的已签约折扣方案如下："),
                 hr(),
                 
                 h3("Market Histogram"),
                 p(class="text-small", "Histogram of products at a given price range and binwidth, highlighting selected REPs in the market."),
                 ggvisOutput("market_histogram"),
                 div(class="row offset1", uiOutput("market_histogram_slider")),
                 hr(),
                 
                 h3("Market scatterplot"),
                 p(class="text-small", "Scatterplot of products at a given price range, highlighting selected REPs in the market."),
                 ggvisOutput("market_scatterplot"),
                 hr()
        ),
        tabPanel("数据查看",
                 h3("历史数据"),
                 p(class="text-small", "同类客户的历史数据，数据来自2016年1月至2018年6月的签约客户运单级数据",
                   a(href="http://www.powertochoose.org", target="_blank", "www.powertochoose.org")),
                 hr(),
                 
                 h3("Datatable"),
                 dataTableOutput("datatable"),
                 hr()
        )
    ),
    width = 9
  )
)))