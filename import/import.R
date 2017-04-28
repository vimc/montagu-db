source("R/common.R")
source("R/permissions.R")
source("R/coverage.R")
source("R/burden.R")
source("R/import.R")
source("R/impact.R")
source("R/impact_recipe.R")

montagu_import_path <- Sys.getenv("MONTAGU_IMPORT_PATH", "data_import")
montagu_db_host <- Sys.getenv("MONTAGU_DB_HOST", "localhost")
montagu_db_port <- as.integer(Sys.getenv("MONTAGU_DB_PORT", 8888))

montagu_import(montagu_import_path, montagu_db_host, montagu_db_port)
