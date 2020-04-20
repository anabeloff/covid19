# SARS-CoV-2

Visualizing SARS-CoV-2 pandemic development data on log scale allows to see if lockdown efforts are paying off. When plotting cases data on log scale exponential growth appears as straight line going across the plot, but when exponential growth slows down and reaches the plateau the line on the plot starts to bend down. Plotting on log scale makes changes in pandemic trend more obvious.  

App is deployed at [app.anabelov.info/covid19/](http://app.anabelov.info/covid19/)

Options include:
- Day/Week: dot on the plot represents cases recorded in one day or average per week.
- Confirmed cases / Deaths
- Of course it is Canada centric, separate tab to see situation on provincial level.

Remarks on the countries list:
- You can select maximum 9 countries at once. Because 3x3 plot looks good.
- I decided to put limited list of countries because full list would be too balky and data for most is limited.
- Selection is based on my perception of what countries my friends might be interested in.

## Run in R

If you have installed `shiny` run localy:
``` R
# Update and build data files
source("data.R")

# run app
runGitHub("covid19", "anabeloff")
```

## Running in Docker 

Build an image using provided Dickerfile (or pull exicting image from your repository).
``` bash
docker build -t shinyser -f Dockerfile .
```

Run the container:
``` bash
docker run --rm --detach --name="covid19" -p 3838:3838 --mount type=bind,source="/home/user/covid19",target=/srv/shiny-server/covid19 766815054095.dkr.ecr.ca-central-1.amazonaws.com/shinyser:latest
```
Mount the directory or Docker volume containing cloned git repository to `shiny-server` dir inside the container.  
To update the data run `data.R` file inside the container.  
``` bash
docker exec -it -w /srv/shiny-server/covid19 covid19  Rscript data.R
```

All data comes from [John Hopkins University Corona virus map.](https://github.com/CSSEGISandData/COVID-19)