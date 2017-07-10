#!/usr/bin/env Rscript

## NOTE: there is no reason at all for this being in R as opposed to
## any other language, except that it was factored out of the R code
## used in the import.  It does not get run during a build.
##
## Because different numbers of ingredients require functions of
## different arities this creates a bunch of functions from a
## template.
create_impact_functions <- function() {
  ret <- character(0)

  sql_sub_fn <- paste(c(
    "CREATE OR REPLACE FUNCTION",
    "  select_burden_data_col(set_id int, outcome_id int)",
    "  RETURNS",
    "    TABLE(country TEXT, year INTEGER, value DECIMAL)",
    "  AS",
    "    'SELECT country, year, value",
    "       FROM burden_estimate",
    "       WHERE burden_estimate_set = set_id AND burden_outcome = outcome_id'",
    "  LANGUAGE SQL;"), collapse = "\n")

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
      "  LANGUAGE SQL;")
    paste(sql, collapse = "\n")
  }

  c(sql_sub_fn,
    vapply(1:8, select_burden_data_fun, character(1)))
}

dir.create("functions", FALSE, TRUE)
writeLines(create_impact_functions(), "functions/impact.sql")
