FROM r-base:3.3.1

RUN apt-get update && apt-get -y install \
  gnumeric \
  libpq-dev \
  libssl-dev \
  pkg-config \
  postgresql-client

RUN install.r \
  DBI \
  cellranger \
  remotes \
  tidyr \
  yaml

RUN Rscript -e 'remotes::install_github("rstats-db/RPostgres")' && \
  Rscript -e 'remotes::install_github("richfitz/cleanr")'

## This will strip out a bunch of weight that we don't need in the
## final version.
RUN Rscript -e 'remove.packages("BH")'
