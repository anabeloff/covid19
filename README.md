# SARS-CoV-2

Visualizing SARS-CoV-2 pandemic development data on log scale allows to see if lockdown efforts are paying off. When plotting cases data on log scale exponential growth appears as straight line going across the plot. But when exponential growth slows down and reaches the plateau the line on the plot starts to bend down.

App deployed at [http://app.anabelov.info/covid19/](http://app.anabelov.info/covid19/)

To run with `shiny` localy:
``` R
runGitHub( "covid19", "anabeloff")
```

To update data run `data.R` script.  

All data comes from [John Hopkins University Corona virus map.](https://github.com/CSSEGISandData/COVID-19)