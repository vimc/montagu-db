# Montagu Database

## Updating the data model

The montagu-db.sql script is generated directly from the [online generator](http://ondras.zarovi.cz/sql/demo/).

1. Copy the contents of [`schema/montagu-db.xml`](schema/montagu-db.xml) into the [online generator](http://ondras.zarovi.cz/sql/demo/)
2. Make your changes
3. Save the xml to `schema/montagu-db.xml`
4. Save the postgres output to `schema/montagu-db.sql`

We do not reformat either file and be sure to update both if you update either.  The xml file will be taken as the canonical form here.

## Setting up docker for use with montagu

We run a private docker registry.  To access it (for pulling) you must be on the VPN.

Then you need to set up a certificate to that your docker client trusts our registry.

On **Linux**, run:

    $ sudo mkdir -p /etc/docker/certs.d/docker.montagu.dide.ic.ac.uk:5000
    $ curl -L https://raw.githubusercontent.com/vimc/montagu-ci/master/registry/certs/domain.crt > domain.crt
    $ sudo cp domain.crt /etc/docker/certs.d/docker.montagu.dide.ic.ac.uk:5000

Or on **Windows**:

1. Download the certificate from https://raw.githubusercontent.com/vimc/montagu-ci/master/registry/certs/domain.crt
2. Start > "Manage Computer Certificates" (also available in the control panel)
3. Right-click on "Trusted Root Certification Authoritites" > "All tasks" > "Import"
4. Browse to the crt file and then keep pressing "Next" to complete the wizard
5. Restart Docker for Windows

Or on Mac

    $ curl -OL https://raw.githubusercontent.com/vimc/montagu-ci/master/registry/certs/domain.crt
    $ sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain domain.crt

Then restart docker

You can **verify** that this works with:

    $ docker pull docker.montagu.dide.ic.ac.uk:5000/postgres

which will pull the image (if needed) but not throw an error.

## Starting an empty copy of the database

Run the empty database mapped to port 8888

```
docker pull docker.montagu.dide.ic.ac.uk:5000/montagu-db:master
docker run --rm -p 8888:5432 docker.montagu.dide.ic.ac.uk:5000/montagu-db:master
```

## Restore a dump (as created from CI)

This will delete all data in the database for the running container and import a dump from a file

```
CONTAINER_ID=$(docker run --rm -d -p 8888:5432 docker.montagu.dide.ic.ac.uk:5000/montagu-db:master)
./scripts/load-dump-into-container.sh montagu.dump $CONTAINER_ID
```

Loading the demograph information takes considerably longer!  Run

```
./scripts/load-demography.sh demography.dump $CONTAINER_ID
```

## Use the empty container for testing

```
docker run -p 5432:5432 docker.montagu.dide.ic.ac.uk:5000/montagu-db:master
psql -h localhost -p 5432 -U vimc -d montagu -c "\dt"
```

## Accessing the dump from R

Install the `RPostgres` package.  On windows, run:

``` r
# install.packages("drat")
drat:::add("dide-tools")
install.packages("RPostgres")
```

On linux first install the postgres development libraries:

```
apt-get install libpq-dev
```

then install the package from source with

``` r
# install.packages("remotes")
remotes::install_github("rstats-db/RPostgres", upgrade = FALSE)
```

To access a local copy of the database (started with docker) run:

```r
con <- DBI::dbConnect(RPostgres::Postgres(),
                 dbname = "montagu",
                 host = "localhost",
                 port = 8888,
                 password = "changeme",
                 user = "vimc")
```

Or change host to `science.montagu.dide.ic.ac.uk` to run a copy running on our server.

## Scripts

The scripts in `bin` are designed to be run from within the docker image; they assume that the database is set up to run *without* a password (which is by default allowed via psql with local access).

## Containers

The database *process* container is disposable; it's just the [official postgres docker image](https://hub.docker.com/_/postgres/) with a few environment variables set and the [`bin`](bin) directory copied as `/montagu-bin` (and added to `$PATH`).

The database *data volume* containers are persistent and we'll need to be able to do a few things to these.

Docker seems to be moving fairly rapidly in terms of data volumes (which we'll be making use of) so I'm going to assume fairly recent docker throughout
