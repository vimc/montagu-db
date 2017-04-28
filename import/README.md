## Importing the data

Start an empty container that includes the schema;

```
docker pull montagu.dide.ic.ac.uk:5000/montagu-db:master
docker run --rm -p 8888:5432 montagu.dide.ic.ac.uk:5000/montagu-db:master
docker run --rm -p 5432:5432 montagu.dide.ic.ac.uk:5000/montagu-db:master
```

Create a symlink `data_import` to the data you want to import

Run R from *this* directory

The `import.R` file can be used now

```r
source("R/common.R")
source("R/permissions.R")
source("R/coverage.R")
source("R/burden.R")
source("R/import.R")
source("R/impact.R")

montagu_import_path <- Sys.getenv("MONTAGU_IMPORT_PATH", "data_import")
montagu_db_host <- Sys.getenv("MONTAGU_DB_HOST", "localhost")
montagu_db_port <- as.integer(Sys.getenv("MONTAGU_DB_PORT", 5432))
montagu_import(montagu_import_path, montagu_db_host, montagu_db_port)
```
