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

## Baselining
Because we started without migrations, I have created a number of 
migrations that get from an empty database to one that has essential data in it
(like roles and permissions, and the various enum types). These will produce
identical data to that which is in production, but we will never actually run
them on production.

We can manage this with Flyway's baseline feature. Once I have written this
initial suite of migrations we can run:

```
docker run --network=montagu_default \
    docker.montagu.dide.ic.ac.uk:5000/montagu-migrate:master \
    baseline -baselineVersion=2017.09.06.1055
```

on live, where the version will equal to or greater than the last of these 
retroactive migrations. This way, Flyway will not attempt to run these 
migrations on production.
