# SARS-CoV-2

Visualizing SARS-CoV-2 pandemic development data on log scale allows to see if lockdown efforts are paying off. When plotting cases data on log scale exponential growth appears as straight line going across the plot. But when exponential growth slows down and reaches the plateau the line on the plot starts to bend down.

App deployed at [app.anabelov.info/covid19/](http://app.anabelov.info/covid19/)

To run with `shiny` localy:
``` R
# Update and build data files
source("data.R")

# run app
runGitHub( "covid19", "anabeloff")
```

# Running in Docker 

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