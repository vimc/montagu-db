import_permissions <- function(con, path) {
  for (nm in c("permission", "role")) {
    filename <- file.path(PATH_COMMON, "permissions", paste0(nm, ".csv"))
    dat <- read_csv(filename)
    import_data_frame(con, nm, dat)
    n <- DBI::dbGetQuery(con, paste("SELECT COUNT(*) FROM", nm))[[1]]
    if (n != nrow(dat)) {
      stop("Error importing table ", nm)
    }
  }
  import_role_permission(con)
  dat <- read_csv(file.path(path, "permissions", "app_user.csv"))
  app_user_create(con, dat$username, dat$name, dat$email)
}

import_role_permission <- function(con) {
  role <- DBI::dbReadTable(con, "role")
  dat <- read_csv(file.path(PATH_COMMON, "permissions", "role_permission.csv"))

  ## Rewrite data so that it becomes a mapping from role.id ->
  ## permission.name by using the 'name' and 'scope_prefix' columns in
  ## the CSV file to get a role.id, and just using the third column
  ## ('permission') directly.
  scope <- function(x, name) {
    ifelse(x$scope_prefix == "null", x[[name]],
           paste(x$scope_prefix, x[[name]], sep = "."))
  }
  dat$match_on <- scope(dat, "role")
  role$match_on <- scope(role, "name")
  dat$role <- match(dat$match_on, role$match_on)
  import_data_frame(con, "role_permission", dat[c("role", "permission")])
}

app_user_create <- function(con, username, name, email) {
  d <- data_frame(username = username, name = name, email = email)
  message(sprintf("Creating %d users in 'app_user'", nrow(d)))
  insert_values_into(con, "app_user", d, "username", TRUE)
  app_user_add_permission(con, username, "user")
}

app_user_add_permission <- function(con, username, role_name = "user") {
  stopifnot(length(role_name) == 1L)
  role <- DBI::dbGetQuery(con, "SELECT id FROM role WHERE name = $1",
                          role_name)$id
  dat <- data.frame(username = username,
                    role = role,
                    scope_id = "null",
                    stringsAsFactors = FALSE)
  insert_values_into(con, "user_role", dat, names(dat), TRUE, "username")
}
