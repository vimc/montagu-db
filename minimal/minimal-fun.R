import_minimal <- function(host = NULL, port = NULL) {
  if (is.null(host)) {
    host <- Sys.getenv("MONTAGU_DB_HOST", "localhost")
  }
  if (is.null(port)) {
    port <- as.integer(Sys.getenv("MONTAGU_DB_PORT", 8888))
  }

  con <- montagu_connection(host, port)
  common <- read_common()
  for (x in setdiff(names(common), "role_permission")) {
    import_data_frame(con, x, common[[x]])
  }
  import_role_permission(con, common$role_permission)
}

montagu_connection <- function(host = "localhost", port = 5432) {
  DBI::dbConnect(RPostgres::Postgres(),
                 dbname = "montagu",
                 host = host,
                 port = port,
                 password = "changeme",
                 user = "vimc")
}

read_csv <- function(filename, ...) {
  read.csv(filename, stringsAsFactors = FALSE, check.names = FALSE,
           na.strings = c("NA", "#VALUE!", "N/A", "#DIV/0!", "#N/A", "null"),
           ...)
}

import_data_frame <- function(con, tbl, data) {
  if (tbl == "user") {
    tbl_dat <- DBI::dbReadTable(con, tbl)
  } else {
    tbl_dat <- DBI::dbGetQuery(con, sprintf("SELECT * FROM %s LIMIT 1", tbl))
  }
  if (nrow(tbl_dat) == 0L) {
    message(sprintf("Importing '%s'", tbl))
    v <- intersect(names(data), names(tbl_dat))
    DBI::dbWriteTable(con, tbl, data[v], append = TRUE)
  }
  invisible(NULL)
}

read_common <- function() {
  files <- dir("common", pattern = "\\.csv$", full.names = TRUE)
  common <- lapply(files, read_csv)
  names(common) <- sub("\\.csv$", "", basename(files))
  common
}

import_role_permission <- function(con, dat) {
  role <- DBI::dbReadTable(con, "role")

  ## Rewrite data so that it becomes a mapping from role.id ->
  ## permission.name by using the 'name' and 'scope_prefix' columns in
  ## the CSV file to get a role.id, and just using the third column
  ## ('permission') directly.
  scope <- function(x, name) {
    ifelse(is.na(x$scope_prefix), x[[name]],
           paste(x$scope_prefix, x[[name]], sep = "."))
  }
  dat$match_on <- scope(dat, "role")
  role$match_on <- scope(role, "name")
  dat$role <- match(dat$match_on, role$match_on)
  import_data_frame(con, "role_permission", dat[c("role", "permission")])
}

download_countries <- function() {
  orig <- read.csv("common/country.csv", stringsAsFactors = FALSE)
  dat <- xml2::read_xml("https://mrcdata.dide.ic.ac.uk/resources/iso3166.xml")
  countries <- xml2::xml_find_all(dat, "//c")
  id <- c(xml2::xml_attr(countries, "c3"), "XK")
  name <- c(xml2::xml_attr(countries, "n"), "Kosovo")
  tbl <- data.frame(id = id, name = name, stringsAsFactors = FALSE)

  msg <- setdiff(orig$id, tbl$id)
  if (length(msg) > 0L) {
    stop("This will remove entries")
  }

  write.csv(tbl, "common/country.csv", row.names = FALSE)
}
