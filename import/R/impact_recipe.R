compute_impact <- function(con, impact_estimate_recipe_id) {
  for (id in impact_estimate_recipe) {
    compute_impact1(con, id)
  }
}

compute_impact_data <- function(con, impact_estimate_recipe_id) {
  ## TODO: this needs huge work when there is more than one entry in
  ## the burden_estimate_set table.
  ##
  ## * what is the current set of burden estimates
  ##
  ## * do we already have an entry in impact_estimate_set_component
  ##   with these calculations?

  ## The components required to run the script.
  sql <- c(
    "SELECT",
    "  impact_estimate_ingredient.id",
    "    AS impact_estimate_ingredient,",
    "  impact_estimate_ingredient.impact_estimate_recipe",
    "    AS impact_estimate_recipe,",
    "  burden_estimate_set.id",
    "    AS burden_estimate_set,",
    ## We need to know these for the translation
    "  impact_estimate_ingredient.name,",
    "  impact_estimate_ingredient.outcome,",
    ## This needs expanding as version information
    "  burden_estimate_set.uploaded_on",
    "FROM impact_estimate_ingredient",
    "  JOIN burden_estimate_set",
    "    ON burden_estimate_set.responsibility = ",
    "      impact_estimate_ingredient.responsibility",
    "WHERE impact_estimate_ingredient.impact_estimate_recipe = $1")
  cols <- DBI::dbGetQuery(con, paste(sql, collapse = " "),
                          impact_estimate_recipe_id)

  ## Data for the calculation:
  rename <- paste(sprintf("value%d AS %s", seq_along(cols$name), cols$name),
                  collapse = ", ")
  sql <- sprintf(
    "SELECT country, year, %s from select_burden_data2($1, $2, $3, $4)",
    rename)
  pars <- as.list(c(rbind(cols$burden_estimate_set, cols$outcome)))
  list(cols = cols, data = DBI::dbGetQuery(con, sql, pars))
}

compute_impact1 <- function(con, impact_estimate_recipe_id) {
  ## The calculation metadata:
  sql <- "SELECT * from impact_estimate_recipe WHERE id = $1"
  info <- DBI::dbGetQuery(con, sql, impact_estimate_recipe_id)

  res <- compute_impact_data(con, impact_estimate_recipe_id)
  dat <- res$data
  cols <- res$cols

  value <- eval(parse(text = info$script), dat, .GlobalEnv)

  ## impact_estimate_set
  d <- data.frame(impact_estimate_recipe = impact_estimate_recipe_id)
  impact_estimate_set <- insert_values_into(con, "impact_estimate_set", d)

  ## impact_estimate_set_component
  d <- data.frame(impact_estimate_set = impact_estimate_set,
                  impact_estimate_ingredient = cols$impact_estimate_ingredient,
                  burden_estimate_set = cols$burden_estimate_set)
  DBI::dbWriteTable(con, "impact_estimate_set_component", d, append = TRUE)

  ## impact_estimate
  d <- data.frame(impact_estimate_set = impact_estimate_set,
                  year = dat$year,
                  country = dat$country,
                  value = value)
  DBI::dbWriteTable(con, "impact_estimate", d, append = TRUE)
}
