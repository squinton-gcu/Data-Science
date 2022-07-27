FROM bioconductor/bioconductor_docker:devel

WORKDIR /application

COPY requirements-src.r /application/requirements-src.r
COPY requirements-bioc.r /application/requirements-bioc.r 

RUN apt-get update
RUN Rscript requirements-src.r 

RUN Rscript -e 'requireNamespace("BiocManager"); BiocManager::install(ask=F);' \
&& Rscript requirements-bioc.R

RUN Rscript 

COPY ./application

FROM python:3.8-slim-buster

WORKDIR /application

COPY requirements-p.txt /application/requirements-p.txt

RUN pip3 install -r requirements-p.txt
COPY ./application