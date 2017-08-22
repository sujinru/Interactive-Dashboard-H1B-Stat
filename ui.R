library(shiny)
states = c("ALABAMA", "ALASKA", "ARIZONA", "ARKANSAS", "CALIFORNIA", "COLORADO", "CONNECTICUT" ,"DELAWARE","DISTRICT OF COLUMBIA", "FLORIDA", "GEORGIA",  "IDAHO", "ILLINOIS","INDIANA","IOWA","KANSAS", "KENTUCKY", "LOUISIANA", "MAINE","MARYLAND",
           "MASSACHUSETTS","MICHIGAN","MINNESOTA","MISSISSIPPI", "MISSOURI", "MONTANA", "NEBRASKA", "NEVADA", "NEW HAMPSHIRE",
           "NEW JERSEY",           "NEW MEXICO",           "NEW YORK",             "NORTH CAROLINA",       "NORTH DAKOTA",        
           "OHIO",                 "OKLAHOMA",             "OREGON",               "PENNSYLVANIA",                
           "SOUTH CAROLINA",       "SOUTH DAKOTA" ,        "TENNESSEE",            "TEXAS",                "UTAH",                
           "VERMONT",              "VIRGINIA",             "WASHINGTON",           "WEST VIRGINIA",        "WISCONSIN","WYOMING")
jobs = c("BUSINESS ANALYST", "CONSULTANT", "DATABASE/DATA SCIENTIST/ANALYST", "OTHER",
          "PROFESSOR/RESEARCHER","SOFTWARE DEVELOPMENT", "ACCOUNTANT" )
fluidPage(
  titlePanel("H1B Statistics"),
  fluidRow(
    column(4, "", 
           sliderInput(inputId = "year",
                       label = "Year Range", sep='',
                       min = 2011, round=TRUE, ticks = FALSE,
                       max = 2016, dragRange=TRUE,
                       value = c(2011, 2016)
           ),
           selectInput(inputId = "state",
                       label = "State",
                       choices = c('ALL', states)
           ),
           selectInput(inputId = "job",
                       label = "Job Title",
                       choices = c('ALL', jobs)
           )
    ),
    column(6, "",
           plotOutput("map")
    )
  ),
  fluidRow(
    column(6, tableOutput("AppNum")),
    column(6, plotOutput("Trend"))
  ),
  fluidRow(
    "Acknowledgement: the dataset is based on Kaggle H-1B Visa Petitions 2011-2016. The data contains New H1B petitions(before the lottery) + Extension Petitions + Positions exempt from H-1B visa cap ( PHD, Researchers )."
  )
)
