## This is a _massive_ hack but one that is possibly useful for
## getting RPostgres to regognise burden_estimate_stochastic as a
## foreign table.
## library(DBI)
## setMethod("dbListTables", "PqConnection", function(conn) {
##   sql <- "SELECT table_name
## FROM INFORMATION_SCHEMA.tables
## WHERE table_schema not in ('information_schema', 'pg_catalog');"
##   dbGetQuery(conn, sql)[[1]]
## })

con <- DBI::dbConnect(RPostgres::Postgres(),
                      dbname = "montagu",
                      host = "db",
                      port = 5432,
                      password = "changeme",
                      user = "vimc")
con_annex <- DBI::dbConnect(RPostgres::Postgres(),
                            dbname = "montagu",
                            host = "db-annex",
                            port = 5432,
                            password = "changeme",
                            user = "vimc")

DBI::dbReadTable(con, "burden_estimate_stochastic")

d <- DBI::dbGetQuery(con, "SELECT * FROM burden_estimate LIMIT 20")

## Can't copy into a foreign table
## DBI::dbWriteTable(con, "burden_estimate_stochastic", d, append = TRUE)
DBI::dbWriteTable(con_annex, "burden_estimate_stochastic", d, append = TRUE)

## Yay, the data is there
DBI::dbReadTable(con, "burden_estimate_stochastic")
