/* Create demographic_dataset table */
/* This is what a touchstone will now link to, rather than just demographic_source */

CREATE TABLE demographic_dataset (
  id SERIAL NOT NULL ,
  description TEXT NOT NULL ,
  demographic_source INTEGER NOT NULL ,
  demographic_statistic_type INTEGER NOT NULL ,
  PRIMARY KEY (id)
);

/* Foreign keys for demographic_dataset into demographic_source and demographic_statistic_type */

ALTER TABLE demographic_dataset ADD FOREIGN KEY (demographic_source) REFERENCES demographic_source (id);
ALTER TABLE demographic_dataset ADD FOREIGN KEY (demographic_statistic_type) REFERENCES demographic_statistic_type (id);



/* Create touchstone_demographic_dataset table */
/* This allows a touchstone to have multiple demographic datasets - compared to touchstone_demographic_source */
/* NB, touchstone is an FK, but TEXT not INTEGER. */

CREATE TABLE touchstone_demographic_dataset (
  id  SERIAL ,
  touchstone TEXT NOT NULL ,
  demographic_dataset INTEGER NOT NULL ,
  PRIMARY KEY (id)
);

/* Foreign keys - touchstone (id), and demographic_dataset (id) */

ALTER TABLE touchstone_demographic_dataset ADD FOREIGN KEY (demographic_dataset) REFERENCES demographic_dataset (id);
ALTER TABLE touchstone_demographic_dataset ADD FOREIGN KEY (touchstone) REFERENCES touchstone (id);

/* Every demographic_statistic now needs to belong to a demographic_dataset */

ALTER TABLE demographic_statistic ADD demographic_dataset INTEGER;
ALTER TABLE demographic_statistic ADD FOREIGN KEY (demographic_dataset) REFERENCES demographic_dataset (id);

/* Add touchstone_demographic_dataset field to touchstone - and add FK */

ALTER TABLE touchstone ADD touchstone_demographic_dataset INTEGER;
ALTER TABLE touchstone ADD FOREIGN KEY (touchstone_demographic_dataset) REFERENCES touchstone_demographic_dataset (id);


/* UNWPP_2012 (source 1) has types int_pop (10), and tot_pop (20) */

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (1, 'UNWPP_2012 Interpolated Population', 1, 10);
UPDATE demographic_statistic SET demographic_dataset=1 WHERE demographic_source=1 AND demographic_statistic_type=10;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (2, 'UNWPP_2012 Total Population', 1, 20);
UPDATE demographic_statistic SET demographic_dataset=2 WHERE demographic_source=1 AND demographic_statistic_type=20;

/* UNWPP_2015 (source 2) has types int_pop (10), and tot_pop (20) */

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (3, 'UNWPP_2015 Interpolated Population', 2, 10);
UPDATE demographic_statistic SET demographic_dataset=3 WHERE demographic_source=2 AND demographic_statistic_type=10;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (4, 'UNWPP_2015 Total Population', 2, 20);
UPDATE demographic_statistic SET demographic_dataset=4 WHERE demographic_source=2 AND demographic_statistic_type=10;

/* UNWPP_2017 (source 3) has types 1..5, 9..13, 15..22 */

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (5, 'UNWPP_2017 Fertility, age-specific', 3, 1);
UPDATE demographic_statistic SET demographic_dataset=5 WHERE demographic_source=3 AND demographic_statistic_type=1;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (6, 'UNWPP_2017 Sex Ratio at birth', 3, 2);
UPDATE demographic_statistic SET demographic_dataset=6 WHERE demographic_source=3 AND demographic_statistic_type=2;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (7, 'UNWPP_2017 Births, number', 3, 3);
UPDATE demographic_statistic SET demographic_dataset=7 WHERE demographic_source=3 AND demographic_statistic_type=3;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (8, 'UNWPP_2017 Birth rate, CBR', 3, 4);
UPDATE demographic_statistic SET demographic_dataset=8 WHERE demographic_source=3 AND demographic_statistic_type=4;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (9, 'UNWPP_2017 Death rate, CDR', 3, 5);
UPDATE demographic_statistic SET demographic_dataset=9 WHERE demographic_source=3 AND demographic_statistic_type=5;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (10, 'UNWPP_2017 Fertility, total births per woman', 3, 9);
UPDATE demographic_statistic SET demographic_dataset=10 WHERE demographic_source=3 AND demographic_statistic_type=9;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (11, 'UNWPP_2017 Population, interpolated', 3, 10);
UPDATE demographic_statistic SET demographic_dataset=11 WHERE demographic_source=3 AND demographic_statistic_type=10;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (12, 'UNWPP_2017 Life Expectancy, expected remaining years', 3, 11);
UPDATE demographic_statistic SET demographic_dataset=12 WHERE demographic_source=3 AND demographic_statistic_type=11

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (13, 'UNWPP_2017 Life Expectancy at birth', 3, 12);
UPDATE demographic_statistic SET demographic_dataset=13 WHERE demographic_source=3 AND demographic_statistic_type=12;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (14, 'UNWPP_2017 Deaths, number by age', 3, 13);
UPDATE demographic_statistic SET demographic_dataset=14 WHERE demographic_source=3 AND demographic_statistic_type=13;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (15, 'UNWPP_2017 Survivors from 100000', 3, 15);
UPDATE demographic_statistic SET demographic_dataset=15 WHERE demographic_source=3 AND demographic_statistic_type=15;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (16, 'UNWPP_2017 Net Migration Rate', 3, 16);
UPDATE demographic_statistic SET demographic_dataset=16 WHERE demographic_source=3 AND demographic_statistic_type=16;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (17, 'UNWPP_2017 Births, number quinquennial', 3, 17);
UPDATE demographic_statistic SET demographic_dataset=17 WHERE demographic_source=3 AND demographic_statistic_type=17;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (18, 'UNWPP_2017 Population, quinquennial', 3, 18);
UPDATE demographic_statistic SET demographic_dataset=18 WHERE demographic_source=3 AND demographic_statistic_type=18;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (19, 'UNWPP_2017 Mortality, probability of dying', 3, 19);
UPDATE demographic_statistic SET demographic_dataset=19 WHERE demographic_source=3 AND demographic_statistic_type=19;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (20, 'UNWPP_2017 Population, total', 3, 20);
UPDATE demographic_statistic SET demographic_dataset=20 WHERE demographic_source=3 AND demographic_statistic_type=20;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (21, 'UNWPP_2017 Mortality, Under 5 U5MR', 3, 21);
UPDATE demographic_statistic SET demographic_dataset=21 WHERE demographic_source=3 AND demographic_statistic_type=21;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (22, 'UNWPP_2017 Mortality, Under 1 IMR', 3, 22);
UPDATE demographic_statistic SET demographic_dataset=22 WHERE demographic_source=3 AND demographic_statistic_type=22;

/* cm_2015 (source 4) - not in a touchstone, but has three sources, 6,7,8 */

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (23, 'CM_2015 Mortality, Under 5 U5MR', 4, 6);
UPDATE demographic_statistic SET demographic_dataset=23 WHERE demographic_source=4 AND demographic_statistic_type=6;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (24, 'CM_2015 Mortality, Under 1 IMR', 4, 7);
UPDATE demographic_statistic SET demographic_dataset=24 WHERE demographic_source=4 AND demographic_statistic_type=7;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (25, 'CM_2015 Mortality, Neonatal 28 day NMR', 4, 8);
UPDATE demographic_statistic SET demographic_dataset=25 WHERE demographic_source=4 AND demographic_statistic_type=8;

/* unwpp_2017_cm2-15_hybrid (source 5) - one source, 23, the hybrid NMR */

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (26, 'UNWPP_2017_CM_2015 Mortality Neonatal 28 day', 5, 23);
UPDATE demographic_statistic SET demographic_dataset=26 WHERE demographic_source=5 AND demographic_statistic_type=23;

/* unwpp_2017_1 (source 6) - all the UNWPP data, plus the fix for mortality, the central death rate */
/* And the births-by-age-of-woman. So that's 1-5, 9-22, 24-25 */

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (27, 'UNWPP_2017_1 Fertility, age-specific', 6, 1);
UPDATE demographic_statistic SET demographic_dataset=27 WHERE demographic_source=6 AND demographic_statistic_type=1;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (28, 'UNWPP_2017_1 Sex Ratio at birth', 6, 2);
UPDATE demographic_statistic SET demographic_dataset=28 WHERE demographic_source=6 AND demographic_statistic_type=2;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (29, 'UNWPP_2017_1 Births, number', 6, 3);
UPDATE demographic_statistic SET demographic_dataset=29 WHERE demographic_source=6 AND demographic_statistic_type=3;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (30, 'UNWPP_2017_1 Birth rate, CBR', 6, 4);
UPDATE demographic_statistic SET demographic_dataset=30 WHERE demographic_source=6 AND demographic_statistic_type=4;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (31, 'UNWPP_2017_1 Death rate, CDR', 6, 5);
UPDATE demographic_statistic SET demographic_dataset=31 WHERE demographic_source=6 AND demographic_statistic_type=5;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (32, 'UNWPP_2017_1 Fertility, total births per woman', 6, 9);
UPDATE demographic_statistic SET demographic_dataset=32 WHERE demographic_source=6 AND demographic_statistic_type=9;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (33, 'UNWPP_2017_1 Population, interpolated', 6, 10);
UPDATE demographic_statistic SET demographic_dataset=33 WHERE demographic_source=6 AND demographic_statistic_type=10;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (34, 'UNWPP_2017_1 Life Expectancy, expected remaining years', 6, 11);
UPDATE demographic_statistic SET demographic_dataset=34 WHERE demographic_source=6 AND demographic_statistic_type=11;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (35, 'UNWPP_2017_1 Life Expectancy at birth', 6, 12);
UPDATE demographic_statistic SET demographic_dataset=35 WHERE demographic_source=6 AND demographic_statistic_type=12;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (36, 'UNWPP_2017_1 Deaths, number by age', 6, 13);
UPDATE demographic_statistic SET demographic_dataset=36 WHERE demographic_source=6 AND demographic_statistic_type=13;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (37, 'UNWPP_2017_1 Deaths, total', 6, 14);
UPDATE demographic_statistic SET demographic_dataset=37 WHERE demographic_source=6 AND demographic_statistic_type=14;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (38, 'UNWPP_2017_1 Survivors from 100000', 6, 15);
UPDATE demographic_statistic SET demographic_dataset=38 WHERE demographic_source=6 AND demographic_statistic_type=15;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (39, 'UNWPP_2017_1 Net Migration Rate', 6, 16);
UPDATE demographic_statistic SET demographic_dataset=39 WHERE demographic_source=6 AND demographic_statistic_type=16;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (40, 'UNWPP_2017_1 Births, number quinquennial', 6, 17);
UPDATE demographic_statistic SET demographic_dataset=40 WHERE demographic_source=6 AND demographic_statistic_type=17;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (41, 'UNWPP_2017_1 Population, quinquennial', 6, 18);
UPDATE demographic_statistic SET demographic_dataset=41 WHERE demographic_source=6 AND demographic_statistic_type=18;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (42, 'UNWPP_2017_1 Mortality, probability of dying', 6, 19);
UPDATE demographic_statistic SET demographic_dataset=42 WHERE demographic_source=6 AND demographic_statistic_type=19;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (43, 'UNWPP_2017_1 Population, total', 6, 20);
UPDATE demographic_statistic SET demographic_dataset=43 WHERE demographic_source=6 AND demographic_statistic_type=20;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (44, 'UNWPP_2017_1 Mortality, Under 5 U5MR', 6, 21);
UPDATE demographic_statistic SET demographic_dataset=44 WHERE demographic_source=6 AND demographic_statistic_type=21;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (45, 'UNWPP_2017_1 Mortality, Under 1 IMR', 6, 22);
UPDATE demographic_statistic SET demographic_dataset=45 WHERE demographic_source=6 AND demographic_statistic_type=22;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (46, 'UNWPP_2017_1 Mortality: Central Death Rate', 6, 24);
UPDATE demographic_statistic SET demographic_dataset=46 WHERE demographic_source=6 AND demographic_statistic_type=24;

INSERT INTO demographic_dataset (id, description, demographic_source, demographic_statistic_type) VALUES (47, 'UNWPP_2017_1 Fertility: Births by age of mother', 6, 25);
UPDATE demographic_statistic SET demographic_dataset=47 WHERE demographic_source=6 AND demographic_statistic_type=25;

/* Guessing at the syntax for this from other examples...*/
ALTER SEQUENCE demographic_dataset_id_seq RESTART WITH 48;

/* Backward compatibiltiy for previous touchstones. Current touchstone_demographic table is:

   id              touchstone demographic_source
   id              touchstone demographic_source
1   1            201310gavi-1                  2
2   2            201510gavi-4                  1
3   3            201510gavi-5                  1
4   4            201510gavi-7                  1
5   5            201510gavi-9                  1
6   6  201210gavi-201607wue-1                  1
7   7 201210gavi-201303gavi-1                  1
8   8           201510gavi-42                  1
9   9           201310gavi-42                  2
10 10            201708test-1                  3
11 11            201708test-1                  5
12 13            201708test-2                  5
13 14            201708test-2                  6

*/

/* 20310gavi-1. Old Source 2. New dataset: 3,4 */
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201310gavi-1', 3)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201310gavi-1', 4)

/* The next seven touchstones all use old source 1 => new dataset: 1,2 */
/* Touchstones: 201510gavi-{4,5,7,9} 2012gavi-201607wue-1, 201210gavi-201303gavi-1 and 20150gavi-42 */

INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201510gavi-4', 1)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201510gavi-4', 2)

INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201510gavi-5', 1)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201510gavi-5', 2)

INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201510gavi-7', 1)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201510gavi-7', 2)

INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201510gavi-9', 1)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201510gavi-9', 2)

INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201210gavi-201607wue-1', 1)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201210gavi-201607wue-1', 2)

INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201210gavi-201303gavi-1', 1)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201210gavi-201303gavi-1', 2)

INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201510gavi-42', 1)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201510gavi-42', 2)

/* 201310gavi-42 - old source = 2. new dataset = 3,4 */
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201310gavi-42', 3)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201310gavi-42', 4)

/* 201708test-1 - old sources 3 and 5. new datasets = 5-22 and 26 */

INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 5)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 6)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 7)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 8)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 9)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 10)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 11)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 12)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 13)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 14)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 15)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 16)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 17)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 18)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 19)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 20)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 21)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 22)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-1', 26)

/* The next bit, the 201708test-2 touchstone - this is the legacy way of doing it - effectively, the changes
   made to fix the demography required a whole separate data source to be created.

   If this happens in the future, we'll be able to select (source, type) for different sources - hence, 
   we would then use all the correct data from (say) UNWPP_2017, and just the corrected data from UNWPP_2017_1.

   As it is, this is a backward compatibility issue, so 201708test-2 uses the UNWPP_2017_1 sources (27-45),
   and the hybrid CM/UNWPP separate source, which was fine. (26).  
*/

/* Anyway. 201708test-2 uses old sources 5 and 6. New datasets: 26 (from src 5), and 27-47 (from src 6). */
/* Note that 46 and 47 are new datasets added (central mortality rate, and births-per-woman-of-age) */
   
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 26)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 27)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 28)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 29)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 30)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 31)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 32)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 33)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 34)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 35)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 36)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 37)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 38)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 39)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 40)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 41)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 42)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 43)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 44)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 45)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 46)
INSERT INTO touchstone_demographic_dataset (touchstone, demographic_dataset) VALUES ('201708test-2', 47)

/* None of these changes break the API, which is good news. Once we are using the new changes, then
   the following things could be dropped..

   * remove field demographic_statistic.demographic_source
     (you get to it via demographic_statistic.demographic_dataset.demographic_source

   * remove field demographic_statistic.demographic_statistic_type
     (similar, this is demographic.statistic.demographic_dataset.demographic_statistic_type

   * remove touchstone_demographic_source table.
     (no longer relevant, because touchstone_demographic_dataset does the work)

*/
