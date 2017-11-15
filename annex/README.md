# annex

## Provisioning the annex machine

We need

* docker (community edition)
* git
* unzip
* vault

On a fresh machine, you can install all prerequisites by running

```
sudo ./provision.sh
```

(See [the script](provision.sh) for details)

## Working on the annex machine

*We do not have sole ownership of the annex machine - it is a shared DIDE resource and so there are differences to other `.montagu` machines*

All montagu related things are owned by the user `montagu`; use `sudo su montagu` to become that user, or login as them; copy your .ssh public identity into `~/.ssh/authorized_keys`, then add to your `~/.ssh/config`:

```
Host annex.montagu
  User montagu
  Compression yes
  ForwardAgent yes
```

The password for su is stored in the vault.

## Preparing

(this section is needed only if we start from scratch - run as the `montagu` user)

```
git clone https://github.com/vimc/montagu-db ~/annex
~/annex/annex/vault-auth
vault read -field=password /secret/registry/vimc | \
    docker login -u vimc --password-stdin docker.montagu.dide.ic.ac.uk:5000
```

## Deployment

Currently this is a transient store (see VIMC-1016, VIMC-1017).  There is quite a bit of logic required to get this right and it will likely end up with a simpler set of scripts to the deploy (but similar).

1. if the container is running it will be stopped
1. if a volume is not present one will be created
1. start the db container and wait for it to allow connections
1. if a volume _was_ created set the root password from the vault
1. run the schema migrations

```
~/annex/annex/deploy.sh
```

To stop the container (but leave the data volume in place) run

```
~/annex/annex/stop.sh
```

To stop the container and remove the data volume run

```
~/annex/annex/destroy.sh
```

## Migrations

After initial deployment, migrations can be handled from the main montagu deployment.  When deploying in production mode it will perform any required migrations.

Re-deployment should only be required when updating the underlying postgres container (e.g., security fixes).
