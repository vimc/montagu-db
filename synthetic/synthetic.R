montagu_synthetic <- function() {
  con <- montagu_connection()

  import_simple_tables(con)

  import_touchstone_country(con)
  import_scenario_description(con)
  import_scenario(con)
  import_coverage_set(con)
  import_scenario_coverage_set(con)
  import_responsibility_set(con)
  import_responsibility(con)
  import_burden_estimate_set(con)
  import_burden_estimate(con)
  import_role_permission(con)
}

montagu_connection <- function() {
  host <- Sys.getenv("MONTAGU_DB")
  if (nzchar(host)) {
    port <- 5432L
  } else {
    ## This will be where I'll tend to export things to by convention.
    host <- "localhost"
    port <- 8888
  }

  DBI::dbConnect(RPostgres::Postgres(),
                 dbname = "montagu",
                 host = host,
                 port = port,
                 password = "changeme",
                 user = "vimc")
}

read_csv <- function(filename, ...) {
  read.csv(filename, stringsAsFactors = FALSE, check.names = FALSE,
           na.strings = c("NA", "#VALUE!", "N/A", "#DIV/0!", "#N/A"),
           ...)
}

import_table <- function(con, tbl, filename) {
  n <- DBI::dbGetQuery(con, sprintf("SELECT COUNT(*) FROM %s LIMIT 1", tbl))[[1]]
  if (n == 0L) {
    d <- read_csv(filename)
    import_data_frame(con, tbl, d)
  }
  invisible(NULL)
}

import_data_frame <- function(con, tbl, data) {
  tbl_dat <- DBI::dbGetQuery(con, sprintf("SELECT * FROM %s LIMIT 1", tbl))
  if (nrow(tbl_dat) == 0L) {
    message(sprintf("Importing '%s'", tbl))
    v <- intersect(names(data), names(tbl_dat))
    DBI::dbWriteTable(con, tbl, data[v], append = TRUE)
  }
  invisible(NULL)
}

import_simple_tables <- function(con) {
  simple <- c("modelling_group", "model", "model_version",
              "vaccine", "scenario_type", "disease", "vaccination_level",
              "country", "outcome",
              "touchstone_status", "responsibility_set_status",
              "touchstone",
              "permission", 
              "role")
  for (nm in simple) {
    filename <- file.path("data", paste0(nm, ".csv"))
    dat <- read_csv(filename)
    import_data_frame(con, nm, dat)
    n <- DBI::dbGetQuery(con, paste("SELECT COUNT(*) FROM", nm))[[1]]
    if (n != nrow(dat)) {
      stop("Error importing table ", nm)
    }
  }
}

import_touchstone_country <- function(con) {
  touchstone <- DBI::dbGetQuery(con, "SELECT id FROM touchstone")$id
  dat <- read_csv("data/touchstone_country.csv")
  dat$touchstone <- touchstone
  import_data_frame(con, "touchstone_country", dat)
}

import_scenario_description <- function(con) {
  disease <- vaccine <- "YF"
  scenario_type <- c("none", "routine", "routine", "campaign", "campaign")
  vaccination_level <- c("none", "without", "with", "without", "with")
  description <-
    sprintf("%s / %s / %s", disease, vaccination_level, scenario_type)
  id <- sprintf("%s-%s-%s", disease, vaccination_level, scenario_type)
  dat <- data.frame(id, description, vaccination_level, disease, vaccine,
                    scenario_type, stringsAsFactors = FALSE)
  import_data_frame(con, "scenario_description", dat)
}

import_scenario <- function(con) {
  touchstone <- DBI::dbGetQuery(con, "SELECT id FROM touchstone")[[1]]
  scenario_description <-
    DBI::dbGetQuery(con, "SELECT id FROM scenario_description")[[1]]
  dat <- data.frame(touchstone, scenario_description, stringsAsFactors = FALSE)
  import_data_frame(con, "scenario", dat)
}

import_coverage_set <- function(con) {
  touchstone <- DBI::dbGetQuery(con, "SELECT id FROM touchstone")[[1]]
  vaccine <- "YF"
  vaccination_level <- c("without", "with", "without", "with")
  scenario_type <- c("routine", "routine", "campaign", "campaign")
  name <- sprintf("%s / %s / %s", vaccine, vaccination_level, scenario_type)
  dat <- data.frame(name = name, touchstone = touchstone, vaccine = vaccine,
                    vaccination_level = vaccination_level,
                    scenario_type = scenario_type,
                    stringsAsFactors = FALSE)
  import_data_frame(con, "coverage_set", dat)
  id <- DBI::dbGetQuery(con, "SELECT id FROM coverage_set")$id

  country <- DBI::dbGetQuery(con, "SELECT country FROM touchstone_country")[[1]]
  tmp <- DBI::dbReadTable(con, "touchstone")
  year <- tmp$year_start:tmp$year_end

  ## TODO: pull this out into its own thing
  ## This is _total_ junk data.
  dat <- expand.grid(country = country, year = year, coverage_set = id,
                     age_from = 1, age_to = 100)
  dat$percentage_coverage <- round(runif(nrow(dat), 0, 100), 2)
  dat$gavi_support <- runif(nrow(dat)) < 0.7
  import_data_frame(con, "coverage", dat)
}

import_scenario_coverage_set <- function(con) {
  sql <- c("SELECT scenario_description.*, scenario.id AS scenario_id",
           "FROM scenario JOIN scenario_description ON",
           "scenario.scenario_description = scenario_description.id")
  scenario <- DBI::dbGetQuery(con, paste(sql, collapse = " "))
  coverage_set <- DBI::dbReadTable(con, "coverage_set")

  f <- function(i) {
    x <- scenario[i, ]
    v <- c("routine", if (x$scenario_type == "campaign") "campaign")
    coverage_set$id[
      coverage_set$vaccine == x$vaccine &
      coverage_set$vaccination_level == x$vaccination_level &
      coverage_set$scenario_type %in% v]
  }

  coverage_set_id <- lapply(seq_len(nrow(scenario)), f)
  dat <- data.frame(
    scenario = rep(scenario$scenario_id, lengths(coverage_set_id)),
    coverage_set = unlist(coverage_set_id, use.names = FALSE))
  import_data_frame(con, "scenario_coverage_set", dat)
}

import_responsibility_set <- function(con) {
  modelling_group <- DBI::dbGetQuery(con, "SELECT id FROM modelling_group")[[1]]
  touchstone <- DBI::dbGetQuery(con, "SELECT id FROM touchstone")[[1]]
  status <- "submitted"
  dat <- data.frame(modelling_group, touchstone, status,
                    stringsAsFactors = FALSE)
  import_data_frame(con, "responsibility_set", dat)
}

import_responsibility <- function(con) {
  responsibility_set <-
    DBI::dbGetQuery(con, "SELECT id FROM responsibility_set LIMIT 1")[[1]]
  scenario <-
    DBI::dbGetQuery(con, "SELECT id from scenario")[[1]]
  dat <- data.frame(responsibility_set, scenario, stringsAsFactors = FALSE)
  import_data_frame(con, "responsibility", dat)
}

import_burden_estimate_set <- function(con) {
  responsibility <- DBI::dbGetQuery(con, "SELECT id FROM responsibility")[[1]]
  ## TODO: this will need care if more than one data set is added here.
  model_version <-
    DBI::dbGetQuery(con, "SELECT id FROM model_version LIMIT 1")[[1]]
  dat <- data.frame(responsibility,
                    model_version,
                    run_info = "information on model run",
                    validation = "not sure what we'll collect here",
                    interpolated = FALSE,
                    complete = TRUE,
                    uploaded_by = "rgf",
                    stringsAsFactors = FALSE)
  import_data_frame(con, "burden_estimate_set", dat)
}

import_burden_estimate <- function(con) {
  burden_estimate_set <-
    DBI::dbGetQuery(con, "SELECT id FROM burden_estimate_set")[[1]]
  country <- DBI::dbGetQuery(con, "SELECT country FROM touchstone_country")[[1]]
  tmp <- DBI::dbReadTable(con, "touchstone")
  year <- tmp$year_start:tmp$year_end
  outcome <- DBI::dbGetQuery(con, "SELECT id from outcome")[[1]]
  dat <- expand.grid(burden_estimate_set = burden_estimate_set,
                     country = country,
                     year = year,
                     outcome = outcome,
                     stochastic = FALSE)
  dat$value <- round(runif(nrow(dat), 0, 10000), 2)
  import_data_frame(con, "burden_estimate", dat)
}

import_role_permission <- function(con) {
  role <- DBI::dbReadTable(con, "role")
  dat <- read_csv("data/role_permission.csv")
  # Rewrite data so that it becomes a mapping from role.id -> permission.name
  # by using the 'name' and 'scope_prefix' columns in the CSV file to get a
  # role.id, and just using the third column ('permission') directly.
  stop("needs implementing")
}