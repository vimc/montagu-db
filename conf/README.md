## Configuration

- `pg_hba.conf`: host based authentication file.  Required for any database will use streaming replication

- `postgresql.conf`: common settings, applied to all databases
- `postgresql.default.conf`: PostgreSQL's default configuration settings, included for reference only (these are the values from 9.6.2).  This might be useful for digging up values where the docs are unclear

- `postgresql.production.conf.in`: additional settings to be applied in production.  Assumes (and requires) a machine with ample memory.
- `postgresql.test.conf.in`: additional settings to be applied in production.  Suitable for machines with less memory, but assumes relatively small databases.

The `.in` files will be appended onto `postgresql.conf` to create, in the container `/etc/montagu/postgresql.production.conf` and `/etc/montagu/postgresql.test.conf`
