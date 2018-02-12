# Montagu Database
## View the documentation
You can view the full documentation for the master branch
[here](https://vimc.github.io/montagu-db-docs/latest) (see [here](https://vimc.github.io/montagu-db-docs) for previous versions).

The closest equivalent to the old diagram is [here](https://vimc.github.io/montagu-db-docs/latest/diagrams/summary/relationships.real.compact.png),
which you can also navigate to by clicking the "Relationships" tab. But I 
encourage you to explore the full documentation. In particular, if you click on 
any one table you will get a mini diagram explaining its relationships to other 
tables, which is often clearer.

## Updating the data model and docs
See [migrations](migrations/README.md).

## Setting up docker for use with montagu

We run a private docker registry.  To access it (for pulling) you must be on the VPN.

Then you need to set up a certificate to that your docker client trusts our registry.

On **Linux**, run:

    $ sudo mkdir -p /etc/docker/certs.d/docker.montagu.dide.ic.ac.uk:5000
    $ curl -L https://raw.githubusercontent.com/vimc/montagu-ci/master/registry/certs/domain.crt > domain.crt
    $ sudo cp domain.crt /etc/docker/certs.d/docker.montagu.dide.ic.ac.uk:5000

Or on **Windows**:

1. Download the certificate from https://raw.githubusercontent.com/vimc/montagu-ci/master/registry/certs/domain.crt
2. Start > "Manage Computer Certificates" (also available in the control panel)
3. Right-click on "Trusted Root Certification Authoritites" > "All tasks" > "Import"
4. Browse to the crt file and then keep pressing "Next" to complete the wizard
5. Restart Docker for Windows

Or on Mac

    $ curl -OL https://raw.githubusercontent.com/vimc/montagu-ci/master/registry/certs/domain.crt
    $ sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain domain.crt

Then restart docker

You can **verify** that this works with:

    $ docker pull docker.montagu.dide.ic.ac.uk:5000/postgres

which will pull the image (if needed) but not throw an error.

## Starting an empty copy of the database

Run the empty database mapped to port 8888

```
docker pull docker.montagu.dide.ic.ac.uk:5000/montagu-db:master
docker run --rm -p 8888:5432 docker.montagu.dide.ic.ac.uk:5000/montagu-db:master
```

## Restore a dump (from backup)

See the [montagu-backup](https://github.com/vimc/montagu-backup) repo for information on backing up and restoring.  Once done, you should have database file at `/montagu/db.dump`

```
docker run --rm -d --name montagu_db docker.montagu.dide.ic.ac.uk:5000/montagu-db:master
docker cp /montagu/db.dump montagu_db:/tmp/import.dump
docker exec montagu_db /montagu-bin/restore-dump.sh /tmp/import.dump
```

## Using an alternative configuration

There is only one at present `/etc/montagu/postgresql.test.conf`, to use it add this as an argument when running a container, e.g.

```
docker run --rm docker.montagu.dide.ic.ac.uk:5000/montagu-db:master /etc/montagu/postgresql.test.conf
```
