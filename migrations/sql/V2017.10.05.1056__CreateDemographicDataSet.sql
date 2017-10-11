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

/* Updates and inserts moved to montagu-data/i662 */

/* None of these changes break the API, which is good news. Once we are using the new changes, then
   the following things could be dropped..

   * remove field demographic_statistic.demographic_source
     (you get to it via demographic_statistic.demographic_dataset.demographic_source

   * remove field demographic_statistic.demographic_statistic_type
     (similar, this is demographic.statistic.demographic_dataset.demographic_statistic_type

   * remove touchstone_demographic_source table.
     (no longer relevant, because touchstone_demographic_dataset does the work)

*/
