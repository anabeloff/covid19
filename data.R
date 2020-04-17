## DATA ##
# load functions
setwd("/srv/shiny-server/covid19/data")

source("../covid_functions.R")

# UPDATE DATA 

#system("wget -q https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv -O data/time_series_covid19_deaths_global.csv")
#system("wget -q https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv -O data/time_series_covid19_confirmed_global.csv")

system("wget -q -N https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
system("wget -q -N https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")

message("Data downloaded.\n")

## Data from source
# Confirmed
time_confirmed_global <- read.csv("time_series_covid19_confirmed_global.csv")

con_dt <- time_confirmed_global[c(-1,-3,-4)]

dt_C <- final_dt_day(data_tbl = con_dt)
dt <- final_dt(data_tbl = con_dt)

saveRDS(dt_C, "dt_confirmed.rda")
saveRDS(dt, "dt_confirmed_week.rda")

message("Confirmed cases saved.\n")

# Deaths
time_deaths_global <- read.csv("time_series_covid19_deaths_global.csv")
con_dtD <- time_deaths_global[c(-1,-3,-4)]

dtD_D <- final_dt_day(data_tbl = con_dtD)
dtD <- final_dt(data_tbl = con_dtD)

saveRDS(dtD_D, "dt_deaths.rda")
saveRDS(dtD, "dt_deaths_week.rda")

message("Death cases saved.\n")
message("COMPLETE!\n")