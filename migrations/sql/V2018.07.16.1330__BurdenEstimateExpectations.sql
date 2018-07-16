create table burden_estimate_expectation (
	id 				     serial   primary key,
	responsibility       integer  not null unique references responsibility(id),
	year_min_inclusive   smallint not null,
	year_max_inclusive   smallint not null,
	age_min_inclusive    smallint not null,
	age_max_inclusive    smallint not null,
	cohort_min_inclusive smallint null,
	cohort_max_inclusive smallint null
);

comment on table burden_estimate_expectation is 
'This table, in combination with burden_estimate_country_expectation and '
'burden_estimate_outcome_expectation, describes in detail the burden estimates we '
'expect to be uploaded for a particular responsibility. If you imagine plotting '
'expected year and age combinations on x and y axes, then the year_* and age_* '
'columns provide a rectangular area. Within those bounds, the cohort columns '
'optionally give us the ability to describe a triangular area. If a '
'cohort_min_inclusive is defined then only people born in that year and '
'afterwards are included. So if this is set to  2000 then the only ages expected '
'in 2000 are 0. Whereas by 2010, ages 0 - 10 are expected.  Similarly, if '
'cohort_max_inclusive is defined then only people born in that year or before '
'are included.';

create table burden_estimate_country_expectation (
	burden_estimate_expectation integer not null references burden_estimate_expectation(id),
	country 					text    not null references country(id),
    primary key (burden_estimate_expectation, country)
);

create table burden_estimate_outcome_expectation (
	burden_estimate_expectation integer not null references burden_estimate_expectation(id),
	outcome 					text    not null references burden_outcome(code),
    primary key (burden_estimate_expectation, outcome)
);
