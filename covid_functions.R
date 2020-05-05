## FUNCTIONS ##

# Create data frames for ggplot2
library(dplyr)
library(tidyr)
#################################################
# Create data frame with week average data points

final_dt <- function(data_tbl = NA,
                     transform = TRUE,
                     cases_type = NA) {
  data_tbl <- data_tbl %>%
    dplyr::group_by(Country.Region) %>%
    dplyr::summarise_all(list(sum))
  
  # diff show how many cases added per recorded day
  cases_diff <- function(x) {
    x = as.numeric(x[-1])
    x = c(x[1], diff(x))
    return(x)
  }
  
  dt_diff <- apply(data_tbl, 1, cases_diff)
  dimnames(dt_diff) <- list(colnames(data_tbl)[-1], data_tbl$Country.Region)
  dt_diff <- as.data.frame(dt_diff) %>%
    mutate(days = row.names(dt_diff)) %>%
    pivot_longer(-days, names_to = "Country", values_to = "CPD")
  
  
  dt_sum <- as.data.frame(t(data_tbl[-1]))
  colnames(dt_sum) <- data_tbl$Country.Region
  dt_sum$days <- row.names(dt_sum)
  dt_sum <- pivot_longer(dt_sum, -days, names_to = "Country_sum", values_to = "CPD_sum")
  
  
  dt <- cbind(dt_sum[-2], dt_diff[-1])
  dt$days <- gsub("X", "", dt$days)
  dt$days <- gsub(".20$", ".2020", dt$days)
  dt$days <- as.Date(dt$days, "%m.%d.%Y")
  
  
  if(transform == TRUE) {
    dt <- dplyr::group_by(dt, week = format(days, '%W-%Y', ), Country) %>%
      dplyr::summarise(CPD_sum = log10(mean(CPD_sum)+1), CPD = log10(mean(abs(CPD))+1), Days = last(days)) 
  } else {
    dt <- dplyr::group_by(dt, week = format(days, '%W-%Y', ), Country) %>%
      dplyr::summarise(CPD_sum = mean(CPD_sum), CPD = mean(abs(CPD)), Days = last(days), cases_type = cases_type, cases_by = "week")
  }
  
  
  return(dt)
}


#########################################
# Create data frame with day data points.

final_dt_day <- function(data_tbl = NA,
                         transform = TRUE,
                         cases_type = NA) {
  data_tbl <- data_tbl %>%
    dplyr::group_by(Country.Region) %>%
    dplyr::summarise_all(list(sum))
  
  # diff show how many cases added per recorded day
  cases_diff <- function(x) {
    x = as.numeric(x[-1])
    x = c(x[1], diff(x))
    return(x)
  }
  
  dt_diff <- apply(data_tbl, 1, cases_diff)
  dimnames(dt_diff) <- list(colnames(data_tbl)[-1], data_tbl$Country.Region)
  dt_diff <- as.data.frame(dt_diff) %>%
    mutate(days = row.names(dt_diff)) %>%
    pivot_longer(-days, names_to = "Country", values_to = "CPD")
  
  
  dt_sum <- as.data.frame(t(data_tbl[-1]))
  colnames(dt_sum) <- data_tbl$Country.Region
  dt_sum$days <- row.names(dt_sum)
  dt_sum <- pivot_longer(dt_sum, -days, names_to = "Country_sum", values_to = "CPD_sum")
  
  
  dt <- cbind(dt_sum[-2], dt_diff[-1])
  dt$days <- gsub("X", "", dt$days)
  dt$days <- gsub(".20$", ".2020", dt$days)
  dt$days <- as.Date(dt$days, "%m.%d.%Y")
  
  if(transform == TRUE) {
    dt <- dplyr::group_by(dt, days, Country) %>%
      dplyr::mutate(CPD_sum = log10(CPD_sum+1), CPD = log10(abs(CPD)+1), Days = days)
  } else {
    dt <- dplyr::group_by(dt, days, Country) %>%
      dplyr::mutate(CPD_sum = CPD_sum, CPD = abs(CPD), Days = days, cases_type = cases_type, cases_by = "day")
  }
  
  
  return(dt)
}

#########################################
# Create summary data frame 
# by day
plot_labels_day <- function(dt = NA) {
  text_data <- dplyr::group_by(dt,Country) %>%
    dplyr::summarise(CPD = last(CPD), CPD_sum = last(CPD_sum), 
                     cases_type = last(cases_type),
                     cases_by = last(cases_by))
  return(text_data)
}

# by week
# here we take mean of last 7 data points 
# bacause orininal table contains day by day data until week is full.

plot_labels_week <- function(dt = NA) {
  text_data <- dplyr::group_by(dt,Country) %>%
    dplyr::summarise(CPD = mean(tail(CPD, 7)), CPD_sum = last(CPD_sum), 
                     cases_type = last(cases_type),
                     cases_by = last(cases_by))
  return(text_data)
}

