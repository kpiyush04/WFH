#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# ------- Loading Packages ---------
library(shiny)
library(shinydashboard)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(plotly)
library(tidyquant)
library(gtrendsR)


# --------- Google Trends API ---------
# --------- Search Terms ---------
search_trems <- c(
  "work from home"
)

# -------- Read Search terms ------
Read_Search_terms <- search_trems %>%
  gtrendsR::gtrends(geo = "",
                    time = "all")

# ------- Inspect Trends ---------
Read_Search_terms %>% names()

# ------ Interest over time -------
Interest_over_time <- Read_Search_terms %>%
  purrr::pluck("interest_over_time") %>%
  dplyr::mutate(hits = as.numeric(hits)) %>%
  tibble::as_tibble() %>%
  ggplot2::ggplot(aes(date, hits)) +
  ggplot2::geom_line() +
  tidyquant::theme_tq() +
  ggplot2::geom_smooth(span = 0.2, se = FALSE) +
  ggplot2::labs(title = "Work From Home Trend") +
  ggplot2::facet_wrap(~keyword, nrow = 1, scales = "free_y")

# ------ Interest by Country -------
Interest_by_country <- Read_Search_terms %>%
  purrr::pluck("interest_by_country") %>%
  tibble::as_tibble()

world_df <- ggplot2::map_data('world') %>%
  tibble::as_tibble() %>%
  dplyr::mutate(region = stringr::str_to_title(region))

Country_trend <- Read_Search_terms %>%
  purrr::pluck("interest_by_country") %>%
  dplyr::left_join(world_df, by = c("location" = "region")) %>%
  tibble::as_tibble() %>%
  ggplot2::ggplot(aes(long, lat, group = group)) +
  ggplot2::geom_polygon(aes(fill = hits))+
  ggplot2::scale_fill_viridis_c() +
  tidyquant::theme_tq() +
  ggplot2::facet_wrap(~keyword, nrow = 1) +
  ggplot2::labs(title = "Keyword Trends")

# -------- Related_queries -------------
related_queries <- Read_Search_terms %>%
  purrr::pluck("related_queries") %>%
  tibble::as_tibble() %>%
  dplyr::filter(related_queries == "top") %>%
  dplyr::mutate(interest = as.numeric(subject)) %>%
  ggplot2::ggplot(aes(value, interest, color = keyword)) +
  ggplot2::geom_segment(aes(xend = value, yend = 0)) +
  ggplot2::geom_point() +
  ggplot2::coord_flip() +
  ggplot2::facet_wrap(~keyword, nrow = 1, scales = "free_y")

# ------ Server -------
server <- function(input, output) {
  # ------ Render Interest over time plot -------
  output$plot <- renderPlotly({
    plotly::ggplotly(Interest_over_time)
  })
  
  # ------ Render Interest by Country plot -------
  output$world_map_plot <- renderPlotly({
    plotly::ggplotly(Country_trend)
  })
  
  # ------ Render Interest by Related queries plot -------
  output$related_queries_plot <- renderPlotly({
    plotly::ggplotly(related_queries)
  })
}