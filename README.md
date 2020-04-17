# SARS-CoV-2

App visualizes  SARS-CoV-2 data to see if lockdown efforts are actually paying off. By plotting cases on log scale we can easily see the moment when exponential growth reaches the plateau. Basically, when line starts to bend down that means exponential growth is slowing and reaching the plateau.  

App deployed at [http://app.anabelov.info/covid19/](http://app.anabelov.info/covid19/)

To run with `shiny` localy:
``` R
runGitHub( "covid19", "anabeloff")
```

All data comes from [John Hopkins University Corona virus map.](https://coronavirus.jhu.edu/map.html)