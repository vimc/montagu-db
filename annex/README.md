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

## Preparing

```
git clone https://github.com/vimc/montagu-db ~/annex
~/annex/annex/vault-auth
vault read -field=password /secret/registry/vimc | \
    docker login -u vimc --password-stdin docker.montagu.dide.ic.ac.uk:5000
```

## Deployment

```
~/annex/annex/deploy.sh
```
