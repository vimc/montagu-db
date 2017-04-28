CREATE OR REPLACE FUNCTION
  select_burden_data_col(set_id int, outcome_id int)
  RETURNS
    TABLE(country TEXT, year INTEGER, value DECIMAL)
  AS
    'SELECT country, year, value
       FROM burden_estimate
       WHERE burden_estimate_set = set_id AND outcome = outcome_id'
  LANGUAGE SQL;
CREATE OR REPLACE FUNCTION
  select_burden_data2(set1 int, outcome1 int,
                      set2 int, outcome2 int)
  RETURNS TABLE(country TEXT, year INTEGER,
                value1 DECIMAL, value2 DECIMAL)
  AS $$
    SELECT
      vals_1.country,
      vals_1.year,
      vals_1.value AS value1,
      vals_2.value AS value2
    FROM
      (SELECT * FROM select_burden_data_col(set1, outcome1)) AS vals_1
    JOIN
    (SELECT * FROM select_burden_data_col(set2, outcome2)) AS vals_2
    ON vals_1.year = vals_2.year AND vals_1.country = vals_2.country
  $$
  LANGUAGE SQL;
CREATE OR REPLACE FUNCTION
  select_burden_data3(set1 int, outcome1 int,
                      set2 int, outcome2 int,
                      set3 int, outcome3 int)
  RETURNS TABLE(country TEXT, year INTEGER,
                value1 DECIMAL, value2 DECIMAL, value3 DECIMAL)
  AS $$
    SELECT
      vals_1.country,
      vals_1.year,
      vals_1.value AS value1,
      vals_2.value AS value2,
      vals_3.value AS value3
    FROM
      (SELECT * FROM select_burden_data_col(set1, outcome1)) AS vals_1
    JOIN
    (SELECT * FROM select_burden_data_col(set2, outcome2)) AS vals_2
    ON vals_1.year = vals_2.year AND vals_1.country = vals_2.country
    JOIN
    (SELECT * FROM select_burden_data_col(set3, outcome3)) AS vals_3
    ON vals_1.year = vals_3.year AND vals_1.country = vals_3.country
  $$
  LANGUAGE SQL;
CREATE OR REPLACE FUNCTION
  select_burden_data4(set1 int, outcome1 int,
                      set2 int, outcome2 int,
                      set3 int, outcome3 int,
                      set4 int, outcome4 int)
  RETURNS TABLE(country TEXT, year INTEGER,
                value1 DECIMAL, value2 DECIMAL, value3 DECIMAL, value4 DECIMAL)
  AS $$
    SELECT
      vals_1.country,
      vals_1.year,
      vals_1.value AS value1,
      vals_2.value AS value2,
      vals_3.value AS value3,
      vals_4.value AS value4
    FROM
      (SELECT * FROM select_burden_data_col(set1, outcome1)) AS vals_1
    JOIN
    (SELECT * FROM select_burden_data_col(set2, outcome2)) AS vals_2
    ON vals_1.year = vals_2.year AND vals_1.country = vals_2.country
    JOIN
    (SELECT * FROM select_burden_data_col(set3, outcome3)) AS vals_3
    ON vals_1.year = vals_3.year AND vals_1.country = vals_3.country
    JOIN
    (SELECT * FROM select_burden_data_col(set4, outcome4)) AS vals_4
    ON vals_1.year = vals_4.year AND vals_1.country = vals_4.country
  $$
  LANGUAGE SQL;
CREATE OR REPLACE FUNCTION
  select_burden_data5(set1 int, outcome1 int,
                      set2 int, outcome2 int,
                      set3 int, outcome3 int,
                      set4 int, outcome4 int,
                      set5 int, outcome5 int)
  RETURNS TABLE(country TEXT, year INTEGER,
                value1 DECIMAL, value2 DECIMAL, value3 DECIMAL, value4 DECIMAL, value5 DECIMAL)
  AS $$
    SELECT
      vals_1.country,
      vals_1.year,
      vals_1.value AS value1,
      vals_2.value AS value2,
      vals_3.value AS value3,
      vals_4.value AS value4,
      vals_5.value AS value5
    FROM
      (SELECT * FROM select_burden_data_col(set1, outcome1)) AS vals_1
    JOIN
    (SELECT * FROM select_burden_data_col(set2, outcome2)) AS vals_2
    ON vals_1.year = vals_2.year AND vals_1.country = vals_2.country
    JOIN
    (SELECT * FROM select_burden_data_col(set3, outcome3)) AS vals_3
    ON vals_1.year = vals_3.year AND vals_1.country = vals_3.country
    JOIN
    (SELECT * FROM select_burden_data_col(set4, outcome4)) AS vals_4
    ON vals_1.year = vals_4.year AND vals_1.country = vals_4.country
    JOIN
    (SELECT * FROM select_burden_data_col(set5, outcome5)) AS vals_5
    ON vals_1.year = vals_5.year AND vals_1.country = vals_5.country
  $$
  LANGUAGE SQL;
CREATE OR REPLACE FUNCTION
  select_burden_data6(set1 int, outcome1 int,
                      set2 int, outcome2 int,
                      set3 int, outcome3 int,
                      set4 int, outcome4 int,
                      set5 int, outcome5 int,
                      set6 int, outcome6 int)
  RETURNS TABLE(country TEXT, year INTEGER,
                value1 DECIMAL, value2 DECIMAL, value3 DECIMAL, value4 DECIMAL, value5 DECIMAL, value6 DECIMAL)
  AS $$
    SELECT
      vals_1.country,
      vals_1.year,
      vals_1.value AS value1,
      vals_2.value AS value2,
      vals_3.value AS value3,
      vals_4.value AS value4,
      vals_5.value AS value5,
      vals_6.value AS value6
    FROM
      (SELECT * FROM select_burden_data_col(set1, outcome1)) AS vals_1
    JOIN
    (SELECT * FROM select_burden_data_col(set2, outcome2)) AS vals_2
    ON vals_1.year = vals_2.year AND vals_1.country = vals_2.country
    JOIN
    (SELECT * FROM select_burden_data_col(set3, outcome3)) AS vals_3
    ON vals_1.year = vals_3.year AND vals_1.country = vals_3.country
    JOIN
    (SELECT * FROM select_burden_data_col(set4, outcome4)) AS vals_4
    ON vals_1.year = vals_4.year AND vals_1.country = vals_4.country
    JOIN
    (SELECT * FROM select_burden_data_col(set5, outcome5)) AS vals_5
    ON vals_1.year = vals_5.year AND vals_1.country = vals_5.country
    JOIN
    (SELECT * FROM select_burden_data_col(set6, outcome6)) AS vals_6
    ON vals_1.year = vals_6.year AND vals_1.country = vals_6.country
  $$
  LANGUAGE SQL;
CREATE OR REPLACE FUNCTION
  select_burden_data7(set1 int, outcome1 int,
                      set2 int, outcome2 int,
                      set3 int, outcome3 int,
                      set4 int, outcome4 int,
                      set5 int, outcome5 int,
                      set6 int, outcome6 int,
                      set7 int, outcome7 int)
  RETURNS TABLE(country TEXT, year INTEGER,
                value1 DECIMAL, value2 DECIMAL, value3 DECIMAL, value4 DECIMAL, value5 DECIMAL, value6 DECIMAL, value7 DECIMAL)
  AS $$
    SELECT
      vals_1.country,
      vals_1.year,
      vals_1.value AS value1,
      vals_2.value AS value2,
      vals_3.value AS value3,
      vals_4.value AS value4,
      vals_5.value AS value5,
      vals_6.value AS value6,
      vals_7.value AS value7
    FROM
      (SELECT * FROM select_burden_data_col(set1, outcome1)) AS vals_1
    JOIN
    (SELECT * FROM select_burden_data_col(set2, outcome2)) AS vals_2
    ON vals_1.year = vals_2.year AND vals_1.country = vals_2.country
    JOIN
    (SELECT * FROM select_burden_data_col(set3, outcome3)) AS vals_3
    ON vals_1.year = vals_3.year AND vals_1.country = vals_3.country
    JOIN
    (SELECT * FROM select_burden_data_col(set4, outcome4)) AS vals_4
    ON vals_1.year = vals_4.year AND vals_1.country = vals_4.country
    JOIN
    (SELECT * FROM select_burden_data_col(set5, outcome5)) AS vals_5
    ON vals_1.year = vals_5.year AND vals_1.country = vals_5.country
    JOIN
    (SELECT * FROM select_burden_data_col(set6, outcome6)) AS vals_6
    ON vals_1.year = vals_6.year AND vals_1.country = vals_6.country
    JOIN
    (SELECT * FROM select_burden_data_col(set7, outcome7)) AS vals_7
    ON vals_1.year = vals_7.year AND vals_1.country = vals_7.country
  $$
  LANGUAGE SQL;
CREATE OR REPLACE FUNCTION
  select_burden_data8(set1 int, outcome1 int,
                      set2 int, outcome2 int,
                      set3 int, outcome3 int,
                      set4 int, outcome4 int,
                      set5 int, outcome5 int,
                      set6 int, outcome6 int,
                      set7 int, outcome7 int,
                      set8 int, outcome8 int)
  RETURNS TABLE(country TEXT, year INTEGER,
                value1 DECIMAL, value2 DECIMAL, value3 DECIMAL, value4 DECIMAL, value5 DECIMAL, value6 DECIMAL, value7 DECIMAL, value8 DECIMAL)
  AS $$
    SELECT
      vals_1.country,
      vals_1.year,
      vals_1.value AS value1,
      vals_2.value AS value2,
      vals_3.value AS value3,
      vals_4.value AS value4,
      vals_5.value AS value5,
      vals_6.value AS value6,
      vals_7.value AS value7,
      vals_8.value AS value8
    FROM
      (SELECT * FROM select_burden_data_col(set1, outcome1)) AS vals_1
    JOIN
    (SELECT * FROM select_burden_data_col(set2, outcome2)) AS vals_2
    ON vals_1.year = vals_2.year AND vals_1.country = vals_2.country
    JOIN
    (SELECT * FROM select_burden_data_col(set3, outcome3)) AS vals_3
    ON vals_1.year = vals_3.year AND vals_1.country = vals_3.country
    JOIN
    (SELECT * FROM select_burden_data_col(set4, outcome4)) AS vals_4
    ON vals_1.year = vals_4.year AND vals_1.country = vals_4.country
    JOIN
    (SELECT * FROM select_burden_data_col(set5, outcome5)) AS vals_5
    ON vals_1.year = vals_5.year AND vals_1.country = vals_5.country
    JOIN
    (SELECT * FROM select_burden_data_col(set6, outcome6)) AS vals_6
    ON vals_1.year = vals_6.year AND vals_1.country = vals_6.country
    JOIN
    (SELECT * FROM select_burden_data_col(set7, outcome7)) AS vals_7
    ON vals_1.year = vals_7.year AND vals_1.country = vals_7.country
    JOIN
    (SELECT * FROM select_burden_data_col(set8, outcome8)) AS vals_8
    ON vals_1.year = vals_8.year AND vals_1.country = vals_8.country
  $$
  LANGUAGE SQL;
