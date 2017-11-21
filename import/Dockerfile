FROM r-base:3.4.0

RUN apt-get update && apt-get -y install \
  libcurl4-openssl-dev \
  libpq-dev \
  libssl-dev \
  pkg-config \
  postgresql-client

RUN install.r -e \
  DBI \
  RcppRoll \
  data.table \
  drat \
  httr \
  jsonlite \
  readxl \
  remotes \
  whisker \
  yaml

RUN Rscript -e 'remotes::install_github("rstats-db/RPostgres")'
