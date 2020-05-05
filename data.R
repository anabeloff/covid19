## DATA ##
# load functions

source("covid_functions.R")

# UPDATE DATA 
setwd("data")

system("wget -N https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
system("wget -N https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")

message("Data downloaded.\n")

## Data from source
# Confirmed
time_confirmed_global <- read.csv("time_series_covid19_confirmed_global.csv")

# Add Hong Kong and Macau
levels(time_confirmed_global$Country.Region) <- c(levels(time_confirmed_global$Country.Region), "Hong Kong", "Macau")
time_confirmed_global[time_confirmed_global$Province.State == "Hong Kong", 2] <- c("Hong Kong")
time_confirmed_global[time_confirmed_global$Province.State == "Macau", 2] <- c("Macau")

con_dt <- time_confirmed_global[c(-1,-3,-4)]


dt_C <- final_dt_day(data_tbl = con_dt)
dt <- final_dt(data_tbl = con_dt)

saveRDS(dt_C, "dt_confirmed.rda")
saveRDS(dt, "dt_confirmed_week.rda")

message("Confirmed cases saved.\n")

# Deaths
time_deaths_global <- read.csv("time_series_covid19_deaths_global.csv")

# Add Hong Kong and Macau
levels(time_deaths_global$Country.Region) <- c(levels(time_deaths_global$Country.Region), "Hong Kong", "Macau")
time_deaths_global[time_deaths_global$Province.State == "Hong Kong", 2] <- c("Hong Kong")
time_deaths_global[time_deaths_global$Province.State == "Macau", 2] <- c("Macau")

con_dtD <- time_deaths_global[c(-1,-3,-4)]

dtD_D <- final_dt_day(data_tbl = con_dtD)
dtD <- final_dt(data_tbl = con_dtD)

saveRDS(dtD_D, "dt_deaths.rda")
saveRDS(dtD, "dt_deaths_week.rda")

message("Death cases saved.\n")


# Labels data frame
plot_labels <- function(dt = NA, cases_by = NA) {
  text_data <- dplyr::group_by(dt,Country) %>%
    dplyr::summarise(CPD = last(CPD), CPD_sum = last(CPD_sum), 
                     cases_type = last(cases_type),
                     cases_by = last(cases_by))
  return(text_data)
}

dt_list = list(A = final_dt_day(data_tbl = con_dt, transform = FALSE, cases_type = "Confirmed cases"),
               B = final_dt_day(data_tbl = con_dtD, transform = FALSE, cases_type = "Deaths"),
               C = final_dt(data_tbl = con_dt, transform = FALSE, cases_type = "Confirmed cases"),
               D = final_dt(data_tbl = con_dtD, transform = FALSE, cases_type = "Deaths"))

dt_summary = lapply(dt_list, plot_labels)
dt_summary = do.call("rbind", dt_summary)

saveRDS(dt_summary, "dt_summary.rda")


message("Summary table saved.\n")
message("COMPLETE!\n")

# CANADA data

# Confirmed
cdn <- time_confirmed_global[time_confirmed_global$Country.Region == "Canada",]
cdn$Country.Region <- cdn$Province.State

cdn <- cdn[c(-1,-3,-4)]

cdn_day_C <- final_dt_day(data_tbl = cdn)
cdn_week_C <- final_dt(data_tbl = cdn)

saveRDS(cdn_day_C, "cdn_day_C.rda")
saveRDS(cdn_week_C, "cdn_week_C.rda")

# Deaths
cdnD <- time_deaths_global[time_deaths_global$Country.Region == "Canada",]
cdnD$Country.Region <- cdnD$Province.State

cdnD <- cdnD[c(-1,-3,-4)]

cdn_day_D <- final_dt_day(data_tbl = cdnD)
cdn_week_D <- final_dt(data_tbl = cdnD)

saveRDS(cdn_day_D, "cdn_day_D.rda")
saveRDS(cdn_week_D, "cdn_week_D.rda")

dt_list_cdn = list(A = final_dt_day(data_tbl = cdn, transform = FALSE, cases_type = "Confirmed cases"),
               B = final_dt_day(data_tbl = cdnD, transform = FALSE, cases_type = "Deaths"),
               C = final_dt(data_tbl = cdn, transform = FALSE, cases_type = "Confirmed cases"),
               D = final_dt(data_tbl = cdnD, transform = FALSE, cases_type = "Deaths"))

dt_summary_cdn = lapply(dt_list_cdn, plot_labels)
dt_summary_cdn = do.call("rbind", dt_summary_cdn)

saveRDS(dt_summary_cdn, "dt_summary_cdn.rda")

message("Canada data saved.\n")
message("COMPLETE!\n")
