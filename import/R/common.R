PATH_COMMON <- "common"

montagu_connection <- function(host = "localhost", port = 5432) {
  DBI::dbConnect(RPostgres::Postgres(),
                 dbname = "montagu",
                 host = host,
                 port = port,
                 password = "changeme",
                 user = "vimc")
}

import_common <- function(con) {
  files <- dir(PATH_COMMON, pattern = "\\.csv$", full.names = TRUE)
  for (f in files) {
    import_table(con, sub("\\.csv$", "", basename(f)), f)
  }
}

read_csv <- function(filename, ...) {
  read.csv(filename, stringsAsFactors = FALSE, check.names = FALSE,
           na.strings = c("NA", "#VALUE!", "N/A", "#DIV/0!", "#N/A", "null"),
           ...)
}

import_table <- function(con, tbl, filename) {
  n <- DBI::dbGetQuery(con,
                       sprintf("SELECT COUNT(*) FROM %s LIMIT 1", tbl))[[1]]
  if (n == 0L) {
    d <- read_csv(filename)
    import_data_frame(con, tbl, d)
  }
  invisible(NULL)
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

data_frame <- function(...) {
  data.frame(..., stringsAsFactors = FALSE)
}

as_sql_values <- function(x) {
  i <- vlapply(x, is.character)
  x[i] <- vcapply(x[i], squote, USE.NAMES = FALSE)
  vcapply(x, as.character, USE.NAMES = FALSE)
}
squote <- function(x) {
  sprintf("'%s'", gsub("'", "\\'", x, fixed = TRUE))
}
vcapply <- function(X, FUN, ...) {
  vapply(X, FUN, character(1), ...)
}
viapply <- function(X, FUN, ...) {
  vapply(X, FUN, integer(1), ...)
}
vlapply <- function(X, FUN, ...) {
  vapply(X, FUN, logical(1), ...)
}
pastec <- function(...) {
  paste(..., collapse = ", ")
}
`%||%` <- function(a, b) {
  if (is.null(a)) b else a
}

insert_values_into <- function(con, table, d, key = NULL,
                               text_key = FALSE, id = NULL) {
  id <- id %||% (if (length(key) == 1L) key else "id")
  stopifnot(length(id) == 1L)
  insert1 <- function(i) {
    x <- as.list(d[i, , drop = FALSE])
    x <- x[!vlapply(x, is.na)]
    sql <- c(sprintf("INSERT INTO %s", table),
             sprintf("  (%s)", paste(names(x), collapse = ", ")),
             "VALUES",
             sprintf("  (%s)", paste0("$", seq_along(x), collapse = ", ")),
             sprintf("RETURNING %s", id))
    sql <- paste(sql, collapse = "\n")
    if (is.null(key)) {
      DBI::dbGetQuery(con, sql, x)[[id]]
    } else {
      ## Try and retrieve first:
      sql_get <- c(sprintf("SELECT %s FROM %s WHERE", id, table),
                   paste(sprintf("%s = $%d", key, seq_along(key)),
                         collapse = " AND "))
      ret <- DBI::dbGetQuery(con, paste(sql_get, collapse = "\n"), x[key])[[id]]
      if (length(ret) == 0L) {
        ret <- DBI::dbGetQuery(con, sql, x)[[id]]
      }
      ret
    }
  }

  if (!is.data.frame(d)) {
    d <- as.data.frame(d, stringsAsFactors = FALSE)
  }
  tmp <- lapply(seq_len(nrow(d)), insert1)
  vapply(tmp, identity, if (text_key) character(1) else integer(1))
}
