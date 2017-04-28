compute_impact <- function(con, impact_estimate_recipe_id) {
  message(sprintf("Computing %d impact estimate sets",
                  impact_estimate_recipe_id))
  for (id in impact_estimate_recipe_id) {
    message("*")
    compute_impact1(con, id)
  }
}

compute_all_impact <- function(con) {
  dat <- DBI::dbReadTable(con, "impact_estimate_recipe")
  compute_impact(con, dat$id)
}

compute_impact_data <- function(con, impact_estimate_recipe_id) {
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
    "  impact_estimate_ingredient.burden_outcome,",
    ## This needs expanding as version information
    "  burden_estimate_set.uploaded_on",
    ## Then a nasty join to get the *current set of responsibilities*
    "FROM impact_estimate_ingredient",
    "  JOIN responsibility",
    "    ON impact_estimate_ingredient.responsibility = responsibility.id",
    "  JOIN burden_estimate_set",
    "    ON responsibility.current_burden_estimate_set = ",
    "       burden_estimate_set.id",
    "WHERE impact_estimate_ingredient.impact_estimate_recipe = $1")
  cols <- DBI::dbGetQuery(con, paste(sql, collapse = " "),
                          impact_estimate_recipe_id)

  ## Data for the calculation:
  rename <- paste(sprintf("value%d AS %s", seq_along(cols$name), cols$name),
                  collapse = ", ")
  n <- nrow(cols)
  args <- paste0("$", seq_len(n * 2), collapse = ", ")
  sql <- sprintf(
    "SELECT country, year, %s from select_burden_data%d(%s)", rename, n, args)
  pars <- as.list(c(rbind(cols$burden_estimate_set, cols$burden_outcome)))
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

  ## impact_estimate_set_ingredient
  d <- data.frame(impact_estimate_set = impact_estimate_set,
                  impact_estimate_ingredient = cols$impact_estimate_ingredient,
                  burden_estimate_set = cols$burden_estimate_set)
  DBI::dbWriteTable(con, "impact_estimate_set_ingredient", d, append = TRUE)

  ## impact_estimate
  d <- data.frame(impact_estimate_set = impact_estimate_set,
                  year = dat$year,
                  country = dat$country,
                  value = value)
  DBI::dbWriteTable(con, "impact_estimate", d, append = TRUE)
}
