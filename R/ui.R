#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# ------- Importing Packages ---------
library(shiny, quietly = TRUE)
library(shinydashboard, quietly = TRUE)
library(plotly, quietly = TRUE)

# -------- dashboard Header ----------
header <- shinydashboard::dashboardHeader(title = "Work From Home Dashboard",
                                          titleWidth = 300)

# -------- dashboard side bar ----------
sidebar <- shinydashboard::dashboardSidebar(
  sidebarMenu(
    menuItem("Introduction", 
             tabName = "introduction"),
    menuItem("Visualization", 
             tabName = "visualization"),
    menuItem("Data", 
             tabName = "data",
             menuSubItem("Interest over Time Data",
                         tabName = "Interest_df"),
             menuSubItem(text = "Country Trend Data", 
                         tabName = "Country_df"),
             menuSubItem(text = "Related Queries Data", 
                         tabName = "Queries_df")),
    menuItem("Source", tabName = "source")
  )
)

# -------- das  board body ----------
body <- shinydashboard::dashboardBody(
  shinydashboard::tabItems(
    shinydashboard::tabItem(
      "introduction", 
      p(
        shiny::titlePanel(title = "Work From Home Dashboard", )
      )
    ),
    
    # ------ visualization ----------
    shinydashboard::tabItem(
      "visualization",
      fluidRow(
        plotlyOutput("plot")
      ),
      br(),
      br(),
      fluidRow(
        splitLayout(cellWidths = c("49.5%", "0.2%", "49.5%"), 
                    plotlyOutput("world_map_plot"),
                    br(),
                    plotlyOutput("related_queries_plot")
        )
      )
    ),
    
    # ------ Data Tables --------
    shinydashboard::tabItem(
      "Interest_df",
      shiny::dataTableOutput("interest_df")
    ),
    shinydashboard::tabItem(
      "Country_df",
      shiny::dataTableOutput("country_df")
    ),
    shinydashboard::tabItem(
      "Queries_df",
      shiny::dataTableOutput("queries_df")
    ),
    shinydashboard::tabItem(
      "source"
    )
  )
)

# ------- UI -----------
ui <- shinydashboard::dashboardPage(
  header,
  sidebar,
  body
)