DO $$
	declare role_id int;
begin
	insert into role (name, scope_prefix, description)
	values (
		'estimates-writer', 
		null, 
		'Upload burden estimates to ANY group (useful for stochastic ingest tool)'
	)
	returning id into role_id;

	-- All users get estimates.read and responsibilities.read, so we don't need to 
	-- add these here
	insert into role_permission values (role_id, 'estimates.read-unfinished');
	insert into role_permission values (role_id, 'estimates.write');
end $$;