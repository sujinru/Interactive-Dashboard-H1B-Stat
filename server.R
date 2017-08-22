library(shiny)
library(dplyr)
library(maps)
library(ggplot2)
h1b_count = read.csv("data/h1b_count.csv", row.names = 1)
h1b_map = read.csv("data/h1b_map.csv", row.names = 1)
#states = as.character(unique(h1b_count$STATE)[order(unique(h1b_count$STATE))])
#remove <- c ("HAWAII", "ALASKA")
#states = states[! states %in% remove]
#jobs = as.character(unique(h1b_count$JOB_TITLE))

shinyServer(function(input, output){
  data_count<-reactive({
    if (input$state!='ALL' & input$job!='ALL'){
      d = subset(h1b_count, YEAR>=input$year[1] & YEAR<=input$year[2] & STATE == input$state & JOB_TITLE == input$job)
      d
    }
    else if(input$state=='ALL' & input$job!='ALL'){
      d = subset(h1b_count, YEAR>=input$year[1] & YEAR<=input$year[2] & JOB_TITLE == input$job)
      d
    }
    else if (input$state!='ALL' & input$job=='ALL'){
      d = subset(h1b_count, YEAR>=input$year[1] & YEAR<=input$year[2] & STATE == input$state)
      d
    }
    else{
      d = subset(h1b_count, YEAR>=input$year[1] & YEAR<=input$year[2])
      d
    }
  })
  data_map<-reactive({
    if (input$state!='ALL' & input$job!='ALL'){
      d = subset(h1b_map, YEAR>=input$year[1] & YEAR<=input$year[2] & STATE == input$state & JOB_TITLE == input$job)
      d
    }
    else if(input$state=='ALL' & input$job!='ALL'){
      d = subset(h1b_map, YEAR>=input$year[1] & YEAR<=input$year[2] & JOB_TITLE == input$job)
      d
    }
    else if (input$state!='ALL' & input$job=='ALL'){
      d = subset(h1b_map, YEAR>=input$year[1] & YEAR<=input$year[2] & STATE == input$state)
      d
    }
    else{
      d = subset(h1b_map, YEAR>=input$year[1] & YEAR<=input$year[2])
      d
    }
  })
  output$AppNum <- renderTable({
    s = data_count()%>%
      group_by(EMPLOYER_NAME) %>%
      dplyr::summarise(Apps = sum(cer_COUNT)+sum(non_COUNT),
                       Cer_apps = sum(cer_COUNT))
    s = s[order(s$Apps, decreasing = TRUE),]
    colnames(s) = c("Company","No. of Applications", "No. of Certified Apps.")
    head(subset(s, Company!='OTHER'), 10)
  })
  
  output$Trend <- renderPlot({
    s = data_count()%>%
      group_by(YEAR) %>%
      dplyr::summarise(apps = sum(non_COUNT) + sum(cer_COUNT))
    barplot(height=s$apps, las=1, main = 'No. of Applications by Year', names.arg = s$YEAR)
  })
  
  output$map <- renderPlot({
    all_states <- map_data("state")
    all_states <- subset(all_states, region%in%tolower(unique(data_map()$STATE)))
    locations = data_map()%>%
      group_by(lon, lat) %>%
      dplyr::summarise(TotalNumber = sum(count),
                       MedianSalary=mean(median))
    locations = subset(locations, lon > -124.4 & MedianSalary<120000)
    
    p <- ggplot()+labs(x="", y="")
    p <- p + geom_polygon(data=all_states, aes(x=long, y=lat, group = group), colour="white")
    p <- p+geom_point(aes(x = lon, 
                          y = lat,
                          size = TotalNumber, color=MedianSalary), data=locations,
                      show.legend = TRUE)
    p<-p+ scale_colour_gradient(low='yellow', high='red')
    p
  })
})