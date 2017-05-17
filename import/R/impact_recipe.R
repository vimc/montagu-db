compute_impact <- function(con, impact_estimate_recipe_ids) {
  message(sprintf("Computing %d impact estimate sets",
                  length(impact_estimate_recipe_ids)))
  for (id in impact_estimate_recipe_ids) {
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
  sql <- c("SELECT",
           "    impact_estimate_recipe.*,",
           "    responsibility_set.touchstone,",
           "    responsibility_set.modelling_group",
           "  FROM impact_estimate_recipe",
           "  JOIN responsibility_set",
           "    ON responsibility_set.id =",
           "         impact_estimate_recipe.responsibility_set",
           " WHERE impact_estimate_recipe.id = $1")
  info <- DBI::dbGetQuery(con, paste(sql, collapse = "\n"),
                          impact_estimate_recipe_id)
  message(sprintf(" - %s / %s / %s / %s",
                  info$touchstone, info$modelling_group, info$disease,
                  info$name))

  ## Hmm, there are too many zeros and not enough NAs coming out here!
  res <- compute_impact_data(con, impact_estimate_recipe_id)
  dat <- res$data
  cols <- res$cols
  res$value <- eval(parse(text = info$script), dat, .GlobalEnv)

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
                  value = res$value)
  DBI::dbWriteTable(con, "impact_estimate", d, append = TRUE)
  invisible(res)
}

impact_estimate_list <- function(con) {
  sql <- c("SELECT",
           "    impact_estimate_recipe.*,",
           "    responsibility_set.touchstone,",
           "    responsibility_set.modelling_group",
           "  FROM impact_estimate_recipe",
           "  JOIN responsibility_set",
           "    ON responsibility_set.id =",
           "         impact_estimate_recipe.responsibility_set")
  DBI::dbGetQuery(con, paste(sql, collapse = "\n"))
}

impact_estimate_clear <- function(con, impact_estimate_recipe_ids) {
  sql <- c("SELECT id",
           "  FROM impact_estimate_set",
           sprintf(" WHERE impact_estimate_recipe IN (%s)",
                   paste(impact_estimate_recipe_ids, collapse = ", ")))
  ids <- DBI::dbGetQuery(con, paste(sql, collapse = "\n"))$id
  ids_str <- paste(ids, collapse = ", ")
  sql <- "DELETE FROM %s WHERE impact_estimate_set IN (%s)"
  for (t in c("impact_estimate", "impact_estimate_set_ingredient")) {
    DBI::dbExecute(con, sprintf(sql, t, ids_str))
  }
  sql <- "DELETE FROM impact_estimate_set WHERE id IN (%s)"
  DBI::dbExecute(con, sprintf(sql, ids_str))
}
