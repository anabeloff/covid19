FROM rocker/shiny

RUN apt-get update \
	&& apt-get install -y --no-install-recommends apt-utils \
	&& apt-get install -y --no-install-recommends \
	zlib1g-dev \
	libxml2-dev \
	libjpeg-dev \
	libpng-dev
	
RUN R -e "install.packages('dplyr')"
RUN R -e "install.packages('tidyr')"
RUN R -e "install.packages('ggplot2')"
RUN R -e "install.packages('shinythemes')"

# Cleanup
RUN rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
		&& apt-get clean \
		&& rm -rf /var/lib/apt/lists/ 
