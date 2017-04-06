source("R/common.R")
source("R/permissions.R")
source("R/coverage.R")

## TODO: I need to map the burden estimate bits to the new scenario
## metadata, not the gavi_scenario_name!  Then I can can just drop
## gavi_scenario_name entirely
##
## TODO: need to curate and update the mapping of countries

con <- montagu_connection()
path <- "data"

import_common(con)

## 1. The permissions part; this is part of the database design and
## basically will not change I think.  The biggest difference is that
## the actual list of users will need changing.
import_permissions(con, path)

meta_tables <- c("vaccine", "disease", "outcome",
                 "modelling_group", "model", "model_version")
for (table in meta_tables) {
  import_table(con, table, file.path(path, "meta", paste0(table, ".csv")))
}

## 2. Coverage data; the burden estimates will be driven from these.
## These do require some serious metadata though.
import_touchstones(con, path)
