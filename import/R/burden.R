import_burden <- function(con, path) {
  touchstones <- dir(file.path(path, "burden"), full.names = TRUE)
  files <- unlist(lapply(touchstones, dir, full.names = TRUE,
                         pattern = "\\.yml$"))
  for (filename in files) {
    import_burden1(con, path, filename)
  }
}

import_burden1 <- function(con, path, filename) {
  message("Importing ", filename)
  dat <- yaml::yaml.load_file(filename)
  if (length(dat$scenarios) == 0L) {
    message("...skipping as no associated scenarios")
    return()
  }

  if (is.null(dat$touchstone_version)) {
    sql <- c("SELECT * FROM touchstone WHERE touchstone_name = $1",
             "ORDER BY version DESC LIMIT 1")
    tmp <- DBI::dbGetQuery(con, paste(sql, collapse = " "), dat$touchstone)
    dat$touchstone_id <- tmp$id
    dat$touchstone_version <- tmp$version
  } else {
    sql <- c("SELECT id FROM touchstone WHERE",
             "touchstone_name = $1 AND version = $2")
    dat$touchstone_id <-
      DBI::dbGetQuery(con, paste(sql, collapse = " "),
                      list(dat$touchstone, dat$touchstone_version))$id
    stopifnot(length(dat$touchstone_id) == 1L)
  }

  scenarios <- read_csv(file.path(path, "meta", "scenarios.csv"))
  scenarios <- scenarios[scenarios$touchstone == dat$touchstone &
                         basename(scenarios$filename) == dat$filename, ]

  ## Set up model version here would be better I think because we
  ## could just pull it from the model metadata?  Oh well.
  sql <- c("SELECT id FROM model_version WHERE",
           "model = $1 AND version = $2")
  model_version <- DBI::dbGetQuery(con, paste(sql, collapse = " "),
                                   list(dat$model,
                                        dat$model_version %||% "unknown"))$id
  if (length(model_version) != 1) {
    stop("model version not found")
  }

  responsibility_set <-
    insert_values_into(con, "responsibility_set",
                       list(modelling_group = dat$modelling_group,
                            touchstone = dat$touchstone_id,
                            status = "approved"),
                       key = c("modelling_group", "touchstone"))

  tmp <- DBI::dbGetQuery(con, "SELECT * FROM scenario WHERE touchstone = $1",
                         dat$touchstone_id)
  tmp <- data.frame(
    responsibility_set = responsibility_set,
    scenario = tmp$id[match(dat$scenarios, tmp$scenario_description)])
  dat$scenarios_responsibility <-
    insert_values_into(con, "responsibility", tmp)

  ## Then a burden estimate set
  tmp <- data_frame(model_version = model_version,
                    responsibility = dat$scenarios_responsibility,
                    run_info = dat$scenarios_run_info,
                    interpolated = FALSE,
                    complete = TRUE,
                    uploaded_by = "richfitz")
  burden_estimate_set <- insert_values_into(con, "burden_estimate_set", tmp)

  burden_outcome <- DBI::dbReadTable(con, "burden_outcome")

  ## Then import the actual files
  burden <- read_csv(sub("\\.yml", ".csv", filename))
  burden$burden_estimate_set <-
    burden_estimate_set[match(burden$scenario_code, dat$scenarios)]
  burden$burden_outcome <-
    burden_outcome$id[match(burden$burden_outcome, burden_outcome$code)]
  burden$country <- burden$country_code
  burden$stochastic <- FALSE
  burden$country_code <- burden$activities <- burden$scenario_code <- NULL

  message("...importing burden estimates")
  DBI::dbWriteTable(con, "burden_estimate", burden, append = TRUE)
}
