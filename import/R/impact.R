create_impact_functions <- function(con) {
  sql_sub_fn <- c(
    "CREATE OR REPLACE FUNCTION",
    "  select_burden_data_col(set_id int, outcome_id int)",
    "  RETURNS",
    "    TABLE(country TEXT, year INTEGER, value DECIMAL)",
    "  AS",
    "    'SELECT country, year, value",
    "       FROM burden_estimate",
    "       WHERE burden_estimate_set = set_id AND outcome = outcome_id'",
    "  LANGUAGE SQL")
  res <- DBI::dbExecute(con, paste(sql_sub_fn, collapse = " "))

  select_burden_data_fun <- function(n) {
    i <- seq_len(n)
    j <- i[-1L]
    args <- paste(sprintf("set%d int, outcome%d int", i, i),
                  collapse = paste0(",\n", strrep(" ", 22)))
    values <- paste(sprintf("value%d DECIMAL", i), collapse = ", ")
    use <- paste(sprintf("vals_%d.value AS value%d", i, i),
                 collapse = paste0(",\n      "))
    join_fmt <- paste(
      "    JOIN",
      "    (SELECT * FROM select_burden_data_col(set%d, outcome%d)) AS vals_%d",
      "    ON vals_1.year = vals_%d.year AND vals_1.country = vals_%d.country",
      sep = "\n")
    join <- sprintf(join_fmt, j, j, j, j, j)
    sql <- c(
      "CREATE OR REPLACE FUNCTION",
      sprintf("  select_burden_data%d(%s)", n, args),
      "  RETURNS TABLE(country TEXT, year INTEGER,",
      sprintf("                %s)", values),
      "  AS $$",
      "    SELECT",
      "      vals_1.country,",
      "      vals_1.year,",
      sprintf("      %s", use),
      "    FROM",
      "      (SELECT * FROM select_burden_data_col(set1, outcome1)) AS vals_1",
      join,
      "  $$",
      "  LANGUAGE SQL")
    paste(sql, collapse = "\n")
  }

  for (i in 2:8) {
    DBI::dbExecute(con, select_burden_data_fun(i))
  }
}

import_impact_estimate_calculations <- function(con, path) {
  impact <- read_csv(file.path(path, "meta", "impact.csv"))

  g <- paste0(impact$touchstone, impact$disease, impact$modelling_group,
              sep = "\r")
  message("Importing impact estimate calculations")
  for (x in split(impact, g)) {
    import_impact_estimate_calculations1(con, x)
  }
}

import_impact_estimate_calculations1 <- function(con, impact) {
  touchstone <- impact$touchstone[[1L]]
  disease <- impact$disease[[1L]]
  modelling_group <- impact$modelling_group[[1L]]
  message(sprintf(" - %s / %s / %s", touchstone, disease, modelling_group))

  ## Then we look up what is needed:
  tmp <- strsplit(impact$scenario, "\\s*,\\s*")
  n <- lengths(tmp)
  tmp <- unlist(tmp)
  i <- rep(seq_along(n), n)
  re <- "^([^:]+):([^:]+):([^:]+)$"
  stopifnot(all(grepl(re, tmp)))
  components <- data_frame(scenario = sub(re, "\\1", tmp),
                           outcome = sub(re, "\\2", tmp),
                           name = sub(re, "\\3", tmp))

  d <- data.frame(version = 1L,
                  name = impact$name,
                  script = impact$script,
                  activity_type = impact$activity_type,
                  support_type = impact$support_type,
                  comment = as.character(impact$comment))
  impact_estimate_calculation <-
    insert_values_into(con, "impact_estimate_calculation", d)

  ## Then we need to do a *massive* join to pull all this together:
  sql <- c(
    "SELECT",
    "  responsibility.id AS responsibility_id,",
    "  scenario_description.id AS scenario_description_id",
    "FROM responsibility",
    "  JOIN responsibility_set",
    "    ON responsibility.responsibility_set = responsibility_set.id",
    "  JOIN scenario",
    "    ON responsibility.scenario = scenario.id",
    "  JOIN scenario_description",
    "    ON scenario.scenario_description = scenario_description.id",
    "WHERE",
    "  responsibility_set.touchstone = $1",
    "  AND responsibility_set.modelling_group = $2",
    "  AND scenario_description.disease = $3")
  d <- DBI::dbGetQuery(con, paste(sql, collapse = " "),
                       list(touchstone, modelling_group, disease))

  responsibility_id <- d$responsibility_id[
    match(components$scenario, d$scenario_description_id)]
  if (any(is.na(responsibility_id))) {
    ## This can fail for all sorts of reasons but the nasty one that I
    ## have seen so far is that if the impact estimate references the
    ## wrong touchstone version it will appear that nothing is there!
    stop("Failed to identify responsibilities within this touchstone")
  }
  outcomes <- DBI::dbReadTable(con, "outcome")
  outcome_id <- outcomes$id[match(components$outcome, outcomes$code)]

  d <- data.frame(responsibility = responsibility_id,
                  impact_estimate_calculation = impact_estimate_calculation[i],
                  outcome = outcome_id,
                  name = components$name)
  DBI::dbWriteTable(con, "impact_estimate_component", d, append = TRUE)
}
