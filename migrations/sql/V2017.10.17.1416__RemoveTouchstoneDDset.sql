/* i662 erroneously added touchstone->touchstone_demographic_dataset */
/* Don't want this - we only need touchstone_demographic_dataset->touchstone - which we have. */
/* All data in this field will be NA, so removing it should be no problem. */

ALTER TABLE touchstone DROP COLUMN touchstone_demographic_dataset;
