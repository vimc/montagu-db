# Database migrations
We are using [Flyway](https://flywaydb.org/) for database migrations.

Because we started without migrations, I am going to create a number of 
migrations that get from an empty database to one that has essential data in it
(like roles and permissions, and the various enum types). These will produce
identical data to that which is in production, but we will never actually run
them on production.

We can manage this with Flyway's baseline feature. Once I have written this
initial suite of migrations we can run:

```
./flyway.sh baseline -baselineVersion=2017.08.24.1639
```

on live, where the version will equal to or greater than the last of these 
retroactive migrations. This way, Flyway will not attempt to run these 
migrations on production.
