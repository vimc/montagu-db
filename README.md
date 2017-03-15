# Montagu Database

## Updating the data model

The montagu-db.sql script is generated directly from the [online generator](http://ondras.zarovi.cz/sql/demo/).

1. Copy the contents of [`schema/montagu-db.xml`](schema/montagu-db.xml) into the [online generator](http://ondras.zarovi.cz/sql/demo/)
2. Make your changes
3. Save the xml to `schema/montagu-db.xml`
4. Save the postgres output to `schema/montagu-db.sql`

We do not reformat either file and be sure to update both if you update either.  The xml file will be taken as the canonical form here.

## Data lifecycle

At the moment we're thinking of things as totally disposable (create the database structure, import legacy data, point the API at it, throw it all away when done).  This allows us to change the data model pretty freely but it's not going to be appropriate for anything but that because once we have data from users we will need to be doing something more clever if we want to update the data model (e.g., create a second database, run an import script, check that everything works, swap it over.

So we need support here for building the database.

This repo will contain information only on setting the database up in the first place, and for doing a backup and restore.  It will also contain some scripts for filling the database with synthetic data for testing purposes.

## Scripts

The scripts in `bin` are designed to be run from within the docker image; they assume that the database is set up to run *without* a password (which is by default allowed via psql with local access).

## Containers

The database *process* container is disposable; it's just the [official postgres docker image](https://hub.docker.com/_/postgres/) with a few environment variables set and the [`bin`](bin) directory copied as `/montagu-bin` (and added to `$PATH`).

The database *data volume* containers are persistent and we'll need to be able to do a few things to these.

Docker seems to be moving fairly rapidly in terms of data volumes (which we'll be making use of) so I'm going to assume fairly recent docker throughout

### Containers here

* schema only
* synthetic data

### Build the postgres server container vimc/montagu-db

This contains the support scripts here and a few environment variables set up.  Rebuild this with

```
./scripts/create-montagu-db.sh
```

This build disables the cache because the build should only take a second or so.

### Build a new data volume containing just the database structure

```
./scripts/create-empty.sh montagu-db-data
```

which will build the postgres container, create a new data volume, and set the schema up within that container.  The argument is the name of the data volume; this will be stored on your computer (and can't be pushed to a registry).  If the volume name given already exists, the script will error; you can delete an image with

```
docker volume rm montagu-db-data
```

(specifying the image to delete).  If no volume name is given then docker will use a randomly generated image name which will be a long hexadecimal string.

### Build a container containing synthetic data

There are a bunch of dependencies in R for this, so run

```
./scripts/create-montagu-synthetic.sh
```

to create a container containing them.  This is only used for this step at this point.  This build _is_ cached because it takes quite a while, so to refresh run

```
docker build --no-cache --tag vimc/montagu-synthetic synthetic
```

Run

```
./scripts/create-synthetic.sh montagu-db-data-synthetic
```

which will set up the schema but also populate it with synthetic data (currently totally rubbish data but we can improve this with time).  The above call will create a data volume called `montagu-db-data-synthetic`, but pass a different argument to the script to create a data volume with a different name (or no argument to create an unnamed data volume)

### Run the database pointing at a data volume

All we have to do here is point the database container at the database volume.  This also exposes the postgres port 5432 as 8888 for local access but we'd typically be using either `--link` or the new docker networking to join containers together.

```
docker run -d \
    -v montagu-db-data:/var/lib/postgresql/data \
    --name montagu-db-run \
    -p 8888:5432 \
    vimc/montagu-db
```

(change the `montagu-db-data` to point at your preferred data volume, e.g., `montagu-db-data-synthetic`)

For development it's often nice to have a container that you can destroy and not have to worry about cleaning the containers up, such as:

```
docker run --rm \
    -v montagu-db-data:/var/lib/postgresql/data \
    -p 8888:5432 \
    vimc/montagu-db
```

(this will remove the container once it exits and avoids naming the container so that you don't get clashes).

**Do not point two containers at the same data volume**

Verify that the database is accessible with:

```
psql -h localhost -p 8888 -U vimc -d montagu
```

(password is `changeme`).  The command `\dt` will list the tables.

The database _process_ container can be safely deleted and the volume will persist.

```
docker rm montagu-db-run
```

### Dump the database contents

This can *probably* be done by dumping to stdout but I have managed to lock up my computer once with that, and to get a dump that won't restore another time.  This is a bit of a faff but will work well enough for now.  Probably the trick will be to have an agreed backup location to use and dump/restore from there.

```
docker exec montagu-db-run montagu-dump.sh dump.pg
docker cp montagu-db-run:dump.pg .
```

### Restore the database contents

```
docker cp dump.pg montagu-db-run:dump.pg
docker exec montagu-db-run montagu-restore.sh dump.pg
```

I do not know if this is going to be a suitable way of managing containers!
