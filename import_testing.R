## docker pull docker.montagu.dide.ic.ac.uk:5000/montagu-db:master
## docker run --rm -p 8888:5432 docker.montagu.dide.ic.ac.uk:5000/montagu-db:master

## work in the top level montagu_db/import directory where a symlink
## has been created.
source("R/common.R")
source("R/permissions.R")
source("R/coverage.R")
source("R/burden.R")
source("R/import.R")
source("R/impact.R")
source("R/impact_recipe.R")

options(error = recover)
montagu_import("data_import", "localhost", 8888)
