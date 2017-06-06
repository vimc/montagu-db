FROM r-base:3.3.1

RUN apt-get update && apt-get -y install \
  libpq-dev \
  libssl-dev \
  pkg-config \
  postgresql-client

RUN install.r \
  DBI \
  remotes \
  yaml

RUN Rscript -e 'remotes::install_github("rstats-db/RPostgres")'

## This will strip out a bunch of weight that we don't need in the
## final version.
RUN Rscript -e 'remove.packages("BH")'

WORKDIR /montagu-db-import
COPY common /montagu-db-import/common/
COPY R /montagu-db-import/R
COPY import.R .
COPY minimal.R .

CMD ["Rscript", "import.R"]
