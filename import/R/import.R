montagu_import <- function(path, host = "localhost", port = 5432) {
  con <- montagu_connection(host, port)

  import_common(con)

  ## 1. The permissions part; this is part of the database design and
  ## basically will not change I think.  The biggest difference is that
  ## the actual list of users will need changing.
  import_permissions(con, path)

  ## 2. Metadata
  meta_tables <- c("vaccine", "disease", "outcome", "impact_outcome",
                   "modelling_group", "model", "model_version",
                   "touchstone_name")
  for (table in meta_tables) {
    import_table(con, table, file.path(path, "meta", paste0(table, ".csv")))
  }

  ## 3. Coverage data; the burden estimates will be driven from these.
  ## These do require some serious metadata though.
  import_touchstones(con, path)

  ## 4. Burden estimates
  import_burden(con, path)

  ## 5. Impact calculations, which must happen _after_ the touchstones
  ## and burden estimates have been created.  The functions for this
  ## should probably be part of the schema but that's a bit of a faff
  ## for now.
  create_impact_functions(con)
  import_impact_estimate_recipes(con, path)

  ## How much data?
  tbls <- DBI::dbListTables(con)
  n <- vapply(tbls, function(x)
    DBI::dbGetQuery(con, sprintf("SELECT COUNT(*) as n FROM %s", x))$n,
    integer(1))
  n <- sort(n)
  message(sprintf("Tables & rows:\n%s",
                  paste(sprintf(" - %s: %s", names(n), n),
                        collapse = "\n")))
}
