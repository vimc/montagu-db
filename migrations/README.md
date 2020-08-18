# Database migrations
We are using [Flyway](https://flywaydb.org/) for database migrations.

## Write a new migration
Add a new file to `sql`. This should be named following this scheme:

```
Vyear.month.day.hour.minute__Description.sql
```

These migrations can be applied by running the `montagu-migrate` image that gets
built from this repository by TeamCity. They will automatically be applied to
real systems as part of the deploy process.

The `montagu-migrate` image expects the database to be running and accessible 
at:

* host: `db`
* port: `5432`
* user: `vimc`
* password: `changeme`

You can override these by passing in command line options. Please see the Flyway
docs for more details.

## Generate documentation
Once TeamCity has build and the db Docker image has been pushed, run [the tool](https://github.com/vimc/montagu-db-docs) against the short commit hash.

## Baselining
Because we started without migrations, I have created a number of 
migrations that get from an empty database to one that has essential data in it
(like roles and permissions, and the various enum types). These will produce
identical data to that which is in production, but we will never actually run
them on production.

We can manage this with Flyway's baseline feature. Once I have written this
initial suite of migrations we can run:

```
password=$(vault read -field=password secret/database/production/users/import)
docker run --network=montagu_default \
    vimc/montagu-migrate:master \   
    baseline -baselineVersion=2017.09.06.1055 \
    -user=import -password=$password
```

on live, where the version will equal to or greater than the last of these 
retroactive migrations. This way, Flyway will not attempt to run these 
migrations on production.

## Fixing mis-ordered migrations
If you accidentally deploy a migration to production that has been erroneously dated to 
a future date, to fix it you will need to 
1. Rename the migration script in this repo to reflect the date it was actually run
2. Manually edit the `schema_version` table to reflect the new name. Use the 
`montagu-data` repo to do this, as per [this](https://github.com/vimc/montagu-data/blob/9d500278adf683c85a75edf7506efb5ec580e443/2018-064-i2381-fix-migration/README.md)
example