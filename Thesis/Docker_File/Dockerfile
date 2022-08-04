FROM bioconductor/bioconductor_docker:devel AS base

WORKDIR /application

COPY scripts/ application/
COPY Data_Files/ application/
COPY main_setup.sh application/
COPY shiny-server.conf application/
COPY shiny-server.sh application/
COPY requirements-p application/

RUN apt-get update \
&& apt-get -y install python 3.7 \
&& apt -y install python3-pip

RUN R -e "install.packages(c('shiny', 'ggplot2', 'reshape', 'stringr'), repos = 'http://cran/rstudio.com/')" 

RUN R -e 'BiocManager::install("MAI")'

RUN pip3 install -r "application/requirements-p"

# select port
EXPOSE 3838

CMD ["bash", "application/main_setup.sh"]
