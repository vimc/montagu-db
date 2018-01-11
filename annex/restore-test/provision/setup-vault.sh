#!/bin/sh
set -ex

if which -a vault > /dev/null; then
    echo "vault is already installed"
else
    apt-get update
    apt-get install -y unzip

    VAULT_VERSION=0.8.3
    VAULT_ZIP=vault_${VAULT_VERSION}_linux_amd64.zip
    wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/${VAULT_ZIP}
    unzip ${VAULT_ZIP}
    mv vault /usr/bin
    rm ${VAULT_ZIP}
fi

vault auth -method=github
vault read -field=password /secret/registry/vimc | \
    docker login -u vimc --password-stdin docker.montagu.dide.ic.ac.uk:5000
