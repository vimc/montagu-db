alter table burden_estimate_expectation
	drop column responsibility;

alter table responsibility
	add column expectations integer null references burden_estimate_expectation(id);
