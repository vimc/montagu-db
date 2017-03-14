FROM r-base:3.3.2

RUN apt-get update && apt-get -y install \
  libpq-dev \
  libssl-dev \
  pkg-config \
  postgresql-client

RUN install.r \
  DBI \
  remotes

RUN Rscript -e 'remotes::install_github("rstats-db/RPostgres")'
