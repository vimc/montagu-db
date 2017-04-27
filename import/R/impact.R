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
