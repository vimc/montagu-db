import_impact_estimate_recipes <- function(con, path) {
  impact <- read_csv(file.path(path, "meta", "impact.csv"))

  g <- paste0(impact$touchstone, impact$disease, impact$modelling_group,
              sep = "\r")
  message("Importing impact estimate calculations")
  for (x in split(impact, g)) {
    import_impact_estimate_recipes1(con, x)
  }
}

import_impact_estimate_recipes1 <- function(con, impact) {
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
                           burden_outcome = sub(re, "\\2", tmp),
                           name = sub(re, "\\3", tmp))

  d <- data.frame(version = 1L,
                  name = impact$name,
                  script = impact$script,
                  impact_outcome = impact$impact_outcome,
                  activity_type = impact$activity_type,
                  support_type = impact$support_type,
                  comment = as.character(impact$comment))
  impact_estimate_recipe <-
    insert_values_into(con, "impact_estimate_recipe", d)

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
  burden_outcomes <- DBI::dbReadTable(con, "burden_outcome")
  burden_outcome_id <-
    burden_outcomes$id[match(components$burden_outcome, burden_outcomes$code)]

  d <- data.frame(responsibility = responsibility_id,
                  impact_estimate_recipe = impact_estimate_recipe[i],
                  burden_outcome = burden_outcome_id,
                  name = components$name)
  DBI::dbWriteTable(con, "impact_estimate_ingredient", d, append = TRUE)
}
