import_touchstones <- function(con, path) {
  touchstones <- dir(file.path(path, "coverage"), pattern = "\\.yml$")
  for (filename in touchstones) {
    import_touchstone(con, filename, path)
  }
}


import_touchstone <- function(con, filename, path) {
  dat <- yaml::yaml.load_file(file.path(path, "coverage", filename))
  message(sprintf("*** Importing touchstone %s (%s)", dat$id, filename))
  insert_touchstone(con, dat)
  activities <- insert_touchstone_activities(con, dat, path)
  insert_touchstone_scenarios(con, dat, activities, path)
  insert_touchstone_country(con, dat, path)
  for (el in dat$coverage_set) {
    insert_touchstone_coverage(con, dat, el, activities, path)
  }
}

## 'dat' here is the contents of the yaml file
insert_touchstone <- function(con, dat) {
  touchstone <- dat$touchstone_name
  d <- dat[c("id", "touchstone_name", "version", "description",
             "year_start", "year_end")]
  d$status <- "finished"
  insert_values_into(con, "touchstone", d, "id", TRUE)
}

insert_touchstone_activities <- function(con, dat, path) {
  activities <- read_csv(file.path(path, "meta", "activities.csv"))
  activities$comment <- NULL
  activities <-
    activities[activities$touchstone == dat$touchstone_name, , drop = FALSE]
  activities$touchstone <- dat$id # versioned touchstone id
  activities$name <- sprintf("%s: %s, %s, %s",
                           activities$disease,
                           activities$vaccine,
                           activities$gavi_support_level,
                           activities$activity_type)

  v <- c("name", "touchstone", "vaccine", "gavi_support_level", "activity_type")
  activities$id <- insert_values_into(con, "coverage_set", activities[v])
  activities
}

insert_touchstone_coverage <- function(con, dat, el, activities, path) {
  if (!is.null(el$filename)) {
    cov <- read_csv(file.path(path, "coverage", dat$id, el$filename))

    el$touchstone_name <- el$touchstone
    el$touchstone <- dat$id

    i <- (activities$touchstone == dat$id &
          activities$activity_type == el$activity_type &
          activities$gavi_support_level == el$gavi_support_level)
    msg <- setdiff(activities$vaccine[i], cov$vaccine)
    if (length(msg) > 0L) {
      stop("Missing vaccine coverage")
    }

    tmp <- activities[i, , drop = FALSE]
    j <- match(cov$vaccine, tmp$vaccine)
    if (any(is.na(j))) {
      stop("Can't associate data")
    }

    cov$coverage_set <- tmp$id[j]
    cov$vaccine <- NULL
    sql_fmt <- "SELECT COUNT(*) AS len FROM coverage WHERE coverage_set IN (%s)"
    sql <- sprintf(sql_fmt, paste(tmp$id, collapse = ", "))
    if (DBI::dbGetQuery(con, sql)$len == 0) {
      message(sprintf("Importing coverage for %s: %s",
                      dat$id, el$filename))
      DBI::dbWriteTable(con, "coverage", cov, append = TRUE)
    }
  }
}

insert_touchstone_scenarios <- function(con, dat, activities, path) {
  scenarios <- read_csv(file.path(path, "meta", "scenarios.csv"))
  scenarios <- scenarios[scenarios$touchstone == dat$touchstone_name, ]
  scenarios$type <- paste(scenarios$code, scenarios$disease, sep = "\r")

  ## There will be some redudancy here so check that it's OK:
  n <- tapply(scenarios$activities, scenarios$type,
              function(x) length(unique(x)))
  if (any(n != 1)) {
    stop("Inconsistent scenarios")
  }

  ## FFS, more drama; we might want to collect the different original
  ## names here, but that's probably better done in the metadata
  i <- !duplicated(paste(scenarios$activities, scenarios$type, sep = "\n"))
  tmp <- scenarios[i, , drop = FALSE]
  upload <- data_frame(id = tmp$code,
                       description = tmp$gavi_scenario_name,
                       disease = tmp$disease)
  insert_values_into(con, "scenario_description", upload, "id", TRUE)

  tmp2 <- data_frame(touchstone = dat$id,
                     scenario_description = upload$id)
  tmp$scenario_id <-
    insert_values_into(con, "scenario", tmp2,
                       c("touchstone", "scenario_description"))

  sa <- strsplit(tmp$activities, ",", fixed = TRUE)
  len <- lengths(sa)
  i <- match(paste(rep(tmp$disease, len), unlist(sa), sep = "\r"),
             paste(activities$disease, activities$code, sep = "\r"))
  if (any(is.na(i))) {
    stop("Can't map activity")
  }

  scenario_coverage_set <-
    data.frame(scenario = tmp$scenario_id[rep(seq_along(len), len)],
               coverage_set = activities$id[i],
               order = sequence(len))

  DBI::dbWriteTable(con, "scenario_coverage_set", scenario_coverage_set,
                    append = TRUE)
}

insert_touchstone_country <- function(con, dat, path) {
  d <- read_csv(file.path(path, "coverage", dat$id, "touchstone_country.csv"))
  DBI::dbWriteTable(con, "touchstone_country", d, append = TRUE)
}
