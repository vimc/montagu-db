#!/usr/bin/env bash

apt-get update
apt-get install -yy \
        git \
        unzip

## Install docker
if which -a docker > /dev/null; then
    echo "docker is already installed"
else
    echo "installing docker"
    # The big docker directory is /var/lib/docker - we'll move that
    # out onto the external disk:
    mkdir -p /mnt/data/docker/var-lib-docker
    ln -s /mnt/data/docker/var-lib-docker /var/lib/docker

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
         "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce
fi

## Install vault
if which -a vault > /dev/null; then
    echo "vault is already installed"
else
    VAULT_VERSION=0.8.3
    VAULT_ZIP=vault_${VAULT_VERSION}_linux_amd64.zip
    wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/${VAULT_ZIP}
    unzip ${VAULT_ZIP}
    mv vault /usr/bin
    rm ${VAULT_ZIP}
fi

## Set up montagu user
if getent passwd montagu > /dev/null; then
    echo "User montagu already set up"
else
    adduser --quiet --gecos "User" --disabled-password montagu
    usermod -aG docker montagu
    usermod -aG ssh montagu
    chmod -R o-rwx ~montagu
    chmod -R g-rwx ~montagu
    # Ideally set the umask at this point
fi
