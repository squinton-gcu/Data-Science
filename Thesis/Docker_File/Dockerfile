FROM bioconductor/bioconductor_docker:devel

RUN apt-get update \
&& apt-get -y install python 3.7 \
&& apt -y install python3-pip
	
RUN install2.r shiny shinydashboard ggplot2 reshape stringr \
	&& rm -rf /tmp/downloaded_packages
	
WORKDIR /application

COPY scripts/ application/
COPY Data_Files/ application/
COPY main_setup.sh application/
COPY requirements-p application/
COPY launch.r application/

RUN R -e 'BiocManager::install("MAI")'

RUN pip3 install -r "application/requirements-p"

# select port
EXPOSE 3838

CMD ["bash", "application/main_setup.sh"]
