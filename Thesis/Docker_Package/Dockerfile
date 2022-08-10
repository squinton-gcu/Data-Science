FROM bioconductor/bioconductor_docker:devel

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends build-essential libpq-dev python3.8 python3-pip python3-setuptools python3-dev
RUN pip3 install --upgrade pip

ENV PYTHONPATH "${PYTHONPATH}:/application"

WORKDIR /application

COPY scripts/ application/
COPY Data_Files/ application/
COPY main_setup.sh application/
COPY requirements-p application/
COPY launch.r application/
	
RUN install2.r shiny shinydashboard ggplot2 reshape stringr \
	&& rm -rf /tmp/downloaded_packages

RUN R -e 'BiocManager::install("MAI")'

RUN pip3 install -r "application/requirements-p"

RUN bash application/main_setup.sh

# select port
EXPOSE 3838

CMD ["Rscript", "application/launch.r"]

