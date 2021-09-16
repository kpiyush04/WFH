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
    menuItem("Introduction", tabName = "introduction"),
    menuItem("Visualization", tabName = "visualization"),
    menuItem("Data", tabName = "data"),
    menuItem("Source", tabName = "source")
  )
)

# -------- dashboard body ----------
body <- shinydashboard::dashboardBody(
  tags$head(tags$style(HTML('
        .skin-blue .main-header .logo {
          background-color: #3c8dbc;
        }
        .skin-blue .main-header .logo:hover {
          background-color: #3c8dbc;
        }
      '))),
  shinydashboard::tabItems(
    shinydashboard::tabItem(
      "introduction", 
      p(
        
      )
    ),
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
    shinydashboard::tabItem(
      "data", 
      # fluid
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